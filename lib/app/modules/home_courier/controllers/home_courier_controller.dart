// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dikantin_app_rebuild/app/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';

class HomeCourierController extends GetxController {
  final baseURL = AppUrl.baseURLAPI;
  
  var isLoading = true.obs;
  var courierData = {}.obs;
  var orderList = [].obs;
  var pendingOrders = [].obs;
  var deliveredOrders = [].obs;
  var isBalanceVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
    getPendingOrders();
  }

  // Metode untuk pindah ke tab konfirmasi
  void goToConfirmationTab() {
    // Gunakan DefaultTabController untuk berpindah tab
    if (Get.context != null) {
      Future.delayed(Duration(milliseconds: 100), () {
        final tabController = DefaultTabController.of(Get.context!);
        if (tabController != null) {
          tabController.animateTo(1);
        }
      });
    }
  }

  Future<void> getProfile() async {
    try {
      isLoading(true);
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.get(
        Uri.parse('$baseURL/courier/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          courierData.value = data['data'];
        }
      }
    } catch (e) {
      print("Error getting profile: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> getPendingOrders() async {
    try {
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      print("Token yang digunakan: $token");
      print("Token length: ${token.length}");

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print("Request headers: $headers");

      final response = await http.get(
        Uri.parse('$baseURL/shipping/pending'),
        headers: headers,
      );

      print("Request URL: ${Uri.parse('$baseURL/shipping/pending')}");
      print("Response Status Code: ${response.statusCode}");
      print("Response Headers: ${response.headers}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Decoded Data: $data");
        if (data['status'] == 'success') {
          orderList.value = data['data'];
          
          // Memisahkan order berdasarkan status
          pendingOrders.value = orderList.where((order) => order['status'] == 'pending').toList();
          deliveredOrders.value = orderList.where((order) => order['status'] == 'delivered').toList();
          
          print("Order List: ${orderList.value}");
          print("Pending Orders: ${pendingOrders.value}");
          print("Delivered Orders: ${deliveredOrders.value}");
        }
      } else {
        print("Error response: ${response.statusCode} - ${response.body}");
      }
    } catch (e, stackTrace) {
      print("Error getting orders: $e");
      print("Stack trace: $stackTrace");
    }
  }

  Future<Map<String, dynamic>> getOrderDetail(String orderId) async {
    try {
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return {};
      }

      final response = await http.get(
        Uri.parse('$baseURL/shipping/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        }
      }
      return {};
    } catch (e) {
      print("Error getting order detail: $e");
      return {};
    }
  }

  Future<void> updateOrderToDelivered(String orderId) async {
    try {
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.patch(
        Uri.parse('$baseURL/shipping/deliver'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'id_order_delivery': orderId,
        }),
      );

      if (response.statusCode == 200) {
        await getPendingOrders(); // Refresh order list
        // Pindahkan pesanan dari tab "Untuk Dikirim" ke tab "Konfirmasi"
        goToConfirmationTab(); // Pindah ke tab Konfirmasi
      }
    } catch (e) {
      print("Error updating order status: $e");
    }
  }

  Future<void> completeOrder(String orderId) async {
    try {
      // Scan barcode terlebih dahulu
      final barcodeScanResult = await scanBarcode();
      if (barcodeScanResult == null) {
        // Jika user membatalkan scan
        Get.snackbar(
          'Dibatalkan', 
          'Pemindaian barcode dibatalkan',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
        );
        return;
      }
      
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.patch(
        Uri.parse('$baseURL/shipping/delivered'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'id_order_delivery': orderId,
        }),
      );

      if (response.statusCode == 200) {
        await getPendingOrders(); // Refresh order list
        Get.snackbar(
          'Sukses', 
          'Pesanan berhasil diselesaikan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
        );
      }
    } catch (e) {
      print("Error completing order: $e");
    }
  }

  // Fungsi untuk scan barcode
  Future<String?> scanBarcode() async {
    try {
      final ScanResult result = await BarcodeScanner.scan(
        options: ScanOptions(
          restrictFormat: [BarcodeFormat.qr, BarcodeFormat.code39, BarcodeFormat.code128],
          useCamera: -1,
          autoEnableFlash: false,
          android: AndroidOptions(
            aspectTolerance: 0.5,
            useAutoFocus: true,
          ),
        ),
      );
      
      if (result.type == ResultType.Cancelled) {
        return null;
      } else {
        return result.rawContent;
      }
    } on PlatformException catch (e) {
      print("Error saat scan barcode: $e");
      Get.snackbar(
        'Error', 
        'Gagal membuka pemindai barcode: ${e.message}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM
      );
      return null;
    } catch (e) {
      print("Error umum: $e");
      return null;
    }
  }

  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  Future<void> showWithdrawalHistory() async {
    try {
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.get(
        Uri.parse('$baseURL/courier-withdrawals'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          Get.bottomSheet(
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Riwayat Penarikan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (data['data'].isEmpty)
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Belum ada riwayat penarikan'),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data['data'].length,
                        itemBuilder: (context, index) {
                          var withdrawal = data['data'][index];
                          return ListTile(
                            title: Text(formatCurrency(
                                double.tryParse(withdrawal['withdrawal_amount']?.toString() ?? '0') ?? 0)),
                            subtitle: Text(withdrawal['withdrawal_date'] ?? ''),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            isScrollControlled: true,
          );
        }
      }
    } catch (e) {
      print("Error getting withdrawal history: $e");
    }
  }
}
