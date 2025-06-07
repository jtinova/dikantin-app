// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../data/api.dart';
import '../../../data/db_provider.dart';
import '../../../models/order.dart';
import '../../../models/order_detail.dart';

class OrderController extends GetxController {
  var selectedIndex = 0.obs;
  var selectedStatus = "Status".obs;
  var selectedDate = "Semua".obs;

  var progressOrder = <Order>[].obs;
  var shippingOrder = <Order>[].obs;
  var historyOrder = <Order>[].obs;
  var pickUpOrder = <Order>[].obs;

  var detailOrder = <OrderDetail>[].obs;
  var detailShipping = <OrderDetail>[].obs;

  List<String> statusOptions = [
    "Status",
    "Diproses",
    "Dikirim",
    "Selesai",
    "Dibatalkan",
  ];

  List<String> dateOptions = ["Semua", "Hari Ini", "Minggu Ini", "Bulan Ini"];

  @override
  void onInit() {
    super.onInit();
    getProgress();
    getShipping();
    getHistory();
    getPickUp();
  }

  Future<void> refreshAll() async {
    EasyLoading.show(status: 'Loading...');

    try {
      await Future.wait([
        getProgress(),
        getShipping(),
        getHistory(),
        getPickUp(),
      ]);
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getProgress() async {
    EasyLoading.show(status: 'Loading...');

    String url = AppUrl.trackingProgress;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        progressOrder.value = (res['data'] as List)
            .map((item) => Order.fromJsonProgress(item))
            .toList();

        print(res);
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getShipping() async {
    EasyLoading.show(status: 'Loading...');

    String url = AppUrl.trackingShipping;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        shippingOrder.value = (res['data'] as List)
            .map((item) => Order.fromJsonProgress(item))
            .toList();

        print(res);
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getHistory() async {
    EasyLoading.show(status: 'Loading...');

    String url = AppUrl.trackingHistory;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        historyOrder.value = (res['data'] as List)
            .map((item) => Order.fromJsonProgress(item))
            .toList();

        print(historyOrder);
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getPickUp() async {
    EasyLoading.show(status: 'Loading...');

    String url = AppUrl.pickUpOrder;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        pickUpOrder.value = (res['data'] as List)
            .map((item) => Order.fromJsonProgress(item))
            .toList();

        print(pickUpOrder);
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> cancelOrder(String id) async {
    EasyLoading.show(status: 'Loading...');

    String url = AppUrl.cancelOrder;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(
          {
            "transaction_detail_id": id,
          },
        ),
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        Get.snackbar(
          "Berhasil",
          res["message"],
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );

        refreshAll();

        print(res);
      } else {
        final res = json.decode(req.body);

        Get.snackbar(
          "Gagal",
          res["message"],
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );

        print(res);
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getDetailProgress(String id) async {
    EasyLoading.show(status: 'Loading...');

    String url = "${AppUrl.trackingDetailProgress}$id";
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        final detail = OrderDetail.fromJson(res['data']);

        detailOrder.value = [detail];
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getDetailShipping(String id) async {
    EasyLoading.show(status: 'Loading...');

    String url = "${AppUrl.trackingDetailShipping}$id";
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        final detail = OrderDetail.fromJsonShipping(res['data']);

        detailShipping.value = [detail];
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
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
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  String capitalizeFirst(String text) {
    return text
        .split('_')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  String formatRupiah(int price) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    return formatCurrency.format(price);
  }

  String formatDateTime(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year.toString();
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '$day/$month/$year | $hour:$minute';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Color getStatusColor(String status) {
  switch (status) {
    case "pending":
      return Color(0xFF1E2857);
    case "cooking":
      return Colors.orange;
    case "Siap Diambil":
      return Colors.deepPurple;
    case "on_delivery":
      return Colors.blue;
    case "done":
      return Colors.green;
    case "cancel":
      return Colors.red;
    default:
      return Colors.black;
  }
}
}
