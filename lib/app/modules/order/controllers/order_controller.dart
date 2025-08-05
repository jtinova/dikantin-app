// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../service/api_client_service.dart';
import '../../../service/api_service.dart';
import '../../../models/order.dart';
import '../../../models/order_detail.dart';
import '../widgets/order_detail_content.dart';

class OrderController extends GetxController {
  var selectedIndex = 0.obs;
  var selectedStatus = "Status".obs;
  var selectedDate = "Semua".obs;

  var progressOrder = <Order>[].obs;
  var shippingOrder = <Order>[].obs;
  var historyOrder = <Order>[].obs;
  var pickUpOrder = <Order>[].obs;
  var dineInOrder = <Order>[].obs;

  var detailOrder = <OrderDetail>[].obs;
  var detailShipping = <OrderDetail>[].obs;

  List<String> statusOptions = [
    "Status",
    "Diproses",
    "Selesai",
    "Dibatalkan",
  ];

  List<String> dateOptions = ["Semua", "Hari Ini", "Minggu Ini", "Bulan Ini"];

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void handleNotificationArguments(Map<String, dynamic> arguments) {
    if (arguments.containsKey('transaction_id')) {
      final String transactionId = arguments['transaction_id'];
      final String orderType = arguments['order_type'] ?? '';

      if (arguments.containsKey('target_sub_tab')) {
        selectedIndex.value = arguments['target_sub_tab'];
      }

      _showOrderDetailFromNotification(transactionId, orderType);
    }
  }

  Future<void> _showOrderDetailFromNotification(
      String orderId, String orderType) async {
    EasyLoading.show(status: 'Loading...');

    if (orderType == 'delivery') {
      await getDetailShipping(orderId);
    } else {
      await getDetailProgress(orderId);
    }

    EasyLoading.dismiss();

    final detailToShow = (orderType == 'delivery' && detailShipping.isNotEmpty)
        ? detailShipping.first
        : (detailOrder.isNotEmpty ? detailOrder.first : null);

    if (detailToShow != null) {
      if (Get.context != null) {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.r),
            ),
          ),
          builder: (context) {
            return OrderDetailBottom(
              order: detailToShow,
              controller: this,
            );
          },
        );
      }
    } else {
      Get.snackbar(
        "Informasi",
        "Tidak dapat menemukan detail pesanan dari notifikasi.",
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
  }

  Future<void> handleHistoryNotificationArguments(
      BuildContext context, dynamic arguments) async {
    final arguments = Get.arguments;
    if (arguments is Map<String, dynamic> &&
        arguments.containsKey('transaction_id')) {
      final String orderId = arguments['transaction_id'];
      final String orderType = arguments['order_type'] ?? '';

      EasyLoading.show(status: 'Loading...');

      if (orderType == 'delivery') {
        await getDetailShipping(orderId);
      } else {
        await getDetailProgress(orderId);
      }

      EasyLoading.dismiss();

      final detailToShow =
          (orderType == 'delivery' && detailShipping.isNotEmpty)
              ? detailShipping.first
              : (detailOrder.isNotEmpty ? detailOrder.first : null);

      if (detailToShow != null) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.r),
            ),
          ),
          builder: (context) {
            return OrderDetailBottom(
              order: detailToShow,
              controller: this,
            );
          },
        );
      } else {
        Get.snackbar(
          "Informasi",
          "Tidak dapat menemukan detail pesanan dari notifikasi.",
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
    }
  }

  Future<void> loadInitialData() async {
    EasyLoading.show(status: 'Loading...');

    try {
      await Future.wait([
        getProgress(),
        getShipping(),
        getPickUp(),
        getDineIn(),
        getHistory(),
      ]);
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

  Future<void> refreshAll() async {
    await loadInitialData();
  }

  Future<void> getProgress() async {
    String url = AppUrl.trackingProgress;

    try {
      final req = await ApiClient.get(url);

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
    } catch (e) {
      print(e);
    }
  }

  Future<void> getShipping() async {
    String url = AppUrl.trackingShipping;

    try {
      final req = await ApiClient.get(url);

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
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPickUp() async {
    String url = AppUrl.pickUpOrder;

    try {
      final req = await ApiClient.get(url);

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
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDineIn() async {
    String url = AppUrl.dineInOrder;

    try {
      final req = await ApiClient.get(url);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        dineInOrder.value = (res['data'] as List)
            .map((item) => Order.fromJsonProgress(item))
            .toList();

        print(dineInOrder);
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
    } catch (e) {
      print(e);
    }
  }

  Future<void> getHistory() async {
    String url = AppUrl.trackingHistory;

    try {
      final req = await ApiClient.get(url);

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
    } catch (e) {
      print(e);
    }
  }

  Future<void> cancelOrder(String id) async {
    String url = AppUrl.cancelOrder;

    try {
      final req = await ApiClient.post(
        url,
        body: {"transaction_detail_id": id},
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
    }
  }

  Future<void> getDetailProgress(String id) async {
    detailOrder.clear();

    String url = "${AppUrl.trackingDetailProgress}$id";

    try {
      final req = await ApiClient.get(url);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        dynamic data = res['data'];

        if (data is List && data.isNotEmpty) {
          final detail = OrderDetail.fromJson(data.first);
          detailOrder.value = [detail];
        } else if (data is Map<String, dynamic>) {
          final detail = OrderDetail.fromJson(data);
          detailOrder.value = [detail];
        }
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
    }
  }

  Future<void> getDetailShipping(String id) async {
    detailShipping.clear();

    String url = "${AppUrl.trackingDetailShipping}$id";

    try {
      final req = await ApiClient.get(url);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        dynamic data = res['data'];

        if (data is List && data.isNotEmpty) {
          final detail = OrderDetail.fromJsonShipping(data.first);
          detailShipping.value = [detail];
        } else if (data is Map<String, dynamic>) {
          final detail = OrderDetail.fromJsonShipping(data);
          detailShipping.value = [detail];
        }
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
      return '-';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Color(0xFF1E2857);
      case "cooking":
        return Colors.orange;
      case "Siap Diambil":
        return Colors.lightGreen;
      case "Pesanan Siap":
        return Colors.lightGreen;
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
