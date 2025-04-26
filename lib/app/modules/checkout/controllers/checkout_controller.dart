// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../data/api.dart';
import '../../../data/db_provider.dart';
import '../../../models/cart.dart';

class CheckoutController extends GetxController {
  var isLoading = false.obs;
  var selectedDeliveryOption = ''.obs;
  var selectedPaymentType = ''.obs;
  var calculateResult = Rxn<Map<String, dynamic>>();
  var groupedItemsByCanteen = <String, List<Map<String, dynamic>>>{}.obs;

  Future<void> getCalculate(List<CartItem> selectedItems) async {
    isLoading.value = true;

    String url = AppUrl.calculateOrder;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    }

    List<Map<String, dynamic>> menuPayload = selectedItems
        .map((item) => {
              "id": item.menu.id,
              "qty": item.quantity,
            })
        .toList();

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"menu": menuPayload}),
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        calculateResult.value = res['data'];
        groupItemsByCanteen(res['data']['details']);
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "${res['message']}",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.0,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createOrder({
    required String tipePesan,
    required String metodePembayaran,
    required String gedung,
    required String detailLokasi,
    required List<CartItem> selectedItems,
  }) async {
    isLoading.value = true;

    String url = AppUrl.createOrder;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    if (gedung == '') {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Mohon Pilih Gedung Tujuan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    } else if (detailLokasi == '') {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Mohon Lengkapi Detail Lokasi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    } else if (tipePesan.isEmpty) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Mohon Pilih Opsi Pesanan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    } else if (metodePembayaran.isEmpty) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Mohon Pilih Metode Pembayaran",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    List<Map<String, dynamic>> menuPayload = selectedItems
        .map((item) => {
              "id": item.menu.id,
              "qty": item.quantity,
            })
        .toList();

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "tipe_pesanan": tipePesan,
          "metode_pembayaran": metodePembayaran,
          "id_gedung": gedung,
          "detail_tujuan": detailLokasi,
          "menu": menuPayload,
        }),
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Pesanan Berhasil",
          "Pesanan Anda Berhasil Dibuat",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.0,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "${res['message']}",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.0,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> groupItemsByCanteen(List<dynamic> details) async {
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (var item in details) {
      final canteenName = item['canteen'] ?? 'Tanpa Nama Kantin';

      if (!grouped.containsKey(canteenName)) {
        grouped[canteenName] = [];
      }
      grouped[canteenName]!.add(item);
    }

    groupedItemsByCanteen.value = grouped;
  }

  String getDeliveryOptionTitle(String value) {
    switch (value) {
      case 'dine_in':
        return 'Ditempat';
      case 'deliver':
        return 'Diantar';
      case 'pick_up':
        return 'Diambil';
      default:
        return 'Pilih Opsi';
    }
  }

  String getPaymentTypeTitle(String value) {
    switch (value) {
      case 'cash':
        return 'Cash';
      case 'credit_card':
        return 'QRIS';
      default:
        return 'Pilih Opsi';
    }
  }

  String formatRupiah(dynamic price) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    final safePrice = (price ?? 0) as int;
    return formatCurrency.format(safePrice);
  }

  String formatPhoneNumber(String number) {
    if (number.startsWith('0')) {
      number = '+62${number.substring(1)}';
    }

    final buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      buffer.write(number[i]);
      if (i == 2 || i == 6 || i == 10 || i == 14) {
        buffer.write(' ');
      }
    }
    return buffer.toString().trim();
  }
}
