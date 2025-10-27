// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dikantin_partner/app/data/db_provider.dart';
import 'package:dikantin_partner/app/data/api.dart';
import 'package:flutter/material.dart';
import 'package:dikantin_partner/app/models/order_canteen.dart';
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';

class PesananController extends GetxController
    with GetTickerProviderStateMixin {
  RxList<TransactionModel> daftarMenu = <TransactionModel>[].obs;
  late TabController tabController;

  RxList<TransactionModel> pesananMasuk = <TransactionModel>[].obs;
  RxList<TransactionModel> pesananDimasak = <TransactionModel>[].obs;
  RxList<TransactionModel> pesananSelesai = <TransactionModel>[].obs;

  List<TransactionModel> _lastFetchedMasuk = [];
  Timer? _autoRefreshTimer;

  bool _isInitialFetchComplete = false;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    fetchPesanan();
    _startAutoRefresh();
  }

  @override
  void onClose() {
    _autoRefreshTimer?.cancel();
    tabController.dispose();
    super.onClose();
  }

  void refreshData() {
    fetchPesanan();
  }

  Future<void> fetchPesanan() async {
    try {
      final token = await DatabaseProvider().getToken();
      final response = await http.get(
        Uri.parse(AppUrl.orderCanteen),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print(result);
        
        final List data = result['data'];

        List<TransactionModel> masuk = [];
        List<TransactionModel> dimasak = [];
        List<TransactionModel> selesai = [];

        for (var item in data) {
          final transaction = TransactionModel.fromJson(item);

          if (transaction.status == 'on_delivery' && transaction.orderType == 'delivery') {
            selesai.add(transaction);
          } else if (transaction.status == 'pending') {
            masuk.add(transaction);
          } else if (transaction.status == 'cooking') {
            dimasak.add(transaction);
          }
        }

        bool hasNewOrder = false;
        if (_isInitialFetchComplete) {
          if (_lastFetchedMasuk.isEmpty && masuk.isNotEmpty) {
            hasNewOrder = true;
          } else if (masuk.length > _lastFetchedMasuk.length) {
            var oldIds = _lastFetchedMasuk.map((t) => t.id).toSet();
            var newIds = masuk.map((t) => t.id).toSet();
            if (newIds.difference(oldIds).isNotEmpty) {
              hasNewOrder = true;
            }
          }
        }

        if (hasNewOrder) {
          Get.snackbar(
            "Pesanan Baru",
            "Ada pesanan baru masuk",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            duration: Duration(milliseconds: 2500),
            margin: EdgeInsets.all(10),
            borderRadius: 10,
          );
        }

        _lastFetchedMasuk = List.from(masuk);

        pesananMasuk.assignAll(masuk);
        pesananDimasak.assignAll(dimasak);
        pesananSelesai.assignAll(selesai);

        if (!_isInitialFetchComplete) {
          _isInitialFetchComplete = true;
        }
      }
    } catch (e) {
      print("Error fetchPesanan: $e");

      if (!_isInitialFetchComplete) {
        _isInitialFetchComplete = true;
      }
    }
  }

  Future<void> updateOrderProcess(String detailId) async {
    try {
      showLoadingDialog();
      final token = await DatabaseProvider().getToken();
      final response = await http.patch(
        Uri.parse(AppUrl.processCanteen),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'transaction_detail_id': detailId}),
      );

      final data = jsonDecode(response.body);
      hideLoadingDialog();

      if (response.statusCode == 200) {
        final tabIndex = tabController.index;

        await fetchPesanan();
        tabController.index = tabIndex;
        Get.back();

        Future.delayed(Duration(milliseconds: 300), () {
          Get.snackbar(
            "Berhasil",
            "Pesanan Dimasak",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            duration: Duration(milliseconds: 2000),
            margin: EdgeInsets.all(10),
            borderRadius: 10,
          );
        });
      } else {
        Get.snackbar("Error", data['message'] ?? 'Gagal memproses pesanan');
      }
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar("Error", "Terjadi kesalahan saat memproses pesanan");
    }
  }

  Future<void> updateOrderComplete(String detailId) async {
    try {
      showLoadingDialog();
      final token = await DatabaseProvider().getToken();
      final response = await http.patch(
        Uri.parse(AppUrl.completeCanteen),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'transaction_detail_id': detailId}),
      );

      final data = jsonDecode(response.body);
      hideLoadingDialog();
      if (response.statusCode == 200) {
        final tabIndex = tabController.index;

        await fetchPesanan();
        tabController.index = tabIndex;
        Get.back();

        Future.delayed(Duration(milliseconds: 300), () {
          Get.snackbar(
            "Berhasil",
            "Pesanan Selesai",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            duration: Duration(milliseconds: 2000),
            margin: EdgeInsets.all(10),
            borderRadius: 10,
          );
        });
      } else {
        Get.snackbar("Error", data['message'] ?? 'Gagal memproses pesanan');
      }
    } catch (e) {
      hideLoadingDialog();
      Get.snackbar("Error", "Terjadi kesalahan saat menyelesaikan pesanan");
    }
  }

  Future<TransactionModel?> fetchTransactionById(String transactionId) async {
    try {
      final token = await DatabaseProvider().getToken();
      final response = await http.get(
        Uri.parse(AppUrl.orderDetailCanteen + transactionId),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final data = result['data'];
        return TransactionModel.fromJson(data);
      } else {
        print("Gagal mengambil detail transaksi: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetchTransactionById: $e");
      return null;
    }
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(Duration(seconds: 30), (_) {
      fetchPesanan();
    });
  }

  String formatRupiah(int price) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    return formatCurrency.format(price);
  }
}

void showLoadingDialog() {
  Get.dialog(
    Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF19345E)),
            SizedBox(height: 16),
            Text("Memproses...", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void hideLoadingDialog() {
  if (Get.isDialogOpen == true) {
    Get.back();
  }
}
