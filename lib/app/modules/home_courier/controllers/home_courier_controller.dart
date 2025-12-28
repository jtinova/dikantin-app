// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'dart:convert';
import 'package:dikantin_app_rebuild/app/service/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';

import '../../../service/api_client_service.dart';
import '../widgets/courier_detail_sheet.dart';
import '../widgets/courier_item_dialog.dart';

class HomeCourierController extends GetxController
    with GetTickerProviderStateMixin {
  final baseURL = AppUrl.baseURLAPI;

  var isLoading = true.obs;
  var courierData = {}.obs;
  var orderList = [].obs;
  var pendingOrders = [].obs;
  var deliveredOrders = [].obs;
  var isBalanceVisible = false.obs;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await getProfile();
    await getPendingOrders().then((_) {
      if (Get.arguments != null) {
        handleNotificationArguments(Get.arguments);
      }
    });
  }

  void handleNotificationArguments(Map<String, dynamic> args) {
    if (args['action'] == 'open_detail') {
      final String orderId = args['order_delivery_id']!.toString();

      if (orderId.isNotEmpty) {
        _showOrderDetailFromNotification(orderId);
      }
    }
  }

  Future<void> _showOrderDetailFromNotification(String orderId) async {
    EasyLoading.show(status: 'Loading...');

    try {
      final details = await getOrderDetail(orderId);

      EasyLoading.dismiss();

      if (details.isNotEmpty) {
        Map<String, dynamic> orderSimple = {
          'id': orderId,
          'status': details['transaction_summary']['status'] ?? 'pending',
          'building_name': details['customer_information']['building_name'],
          // ... field lain jika diperlukan oleh logika tombol
        };

        final List<dynamic> orderItems = details['transaction_details'] ?? [];
        
        if (Get.context != null) {
          showModalBottomSheet(
            context: Get.context!,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            builder: (context) => CourierDetailSheet(
              order: orderSimple,
              details: details,
              orderItems: orderItems,
              controller: this,
              onShowItems: (items) => _showOrderItemsDialog(context, items),
            ),
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
    } catch (e) {
      EasyLoading.dismiss();
      print("Error notification detail: $e");
    }
  }

  void _showOrderItemsDialog(BuildContext context, List<dynamic> items) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CourierItemDialog(items: items);
      },
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void goToConfirmationTab() {
    tabController.animateTo(1);
  }

  Future<void> getProfile() async {
    try {
      isLoading(true);

      final response = await ApiClient.get(AppUrl.courierProfile);

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
      isLoading(true);
      final response = await ApiClient.get(AppUrl.pendingOrders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          orderList.value = data['data'];

          pendingOrders.value =
              orderList.where((order) => order['status'] == 'pending').toList();
          deliveredOrders.value = orderList
              .where((order) =>
                  order['status'] == 'delivered' ||
                  order['status'] == 'arrived')
              .toList();
        }
      } else {
        print("Error response: ${response.statusCode} - ${response.body}");
      }
    } catch (e, stackTrace) {
      print("Error getting orders: $e");
      print("Stack trace: $stackTrace");
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> getOrderDetail(String orderId) async {
    try {
      final response = await ApiClient.get('${AppUrl.detailOrder}/$orderId');

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

  Future<void> startOrderToDelivered(String orderId) async {
    try {
      final response = await ApiClient.patch(
        AppUrl.deliveryOrder,
        body: {'order_delivery_id': orderId},
      );

      if (response.statusCode == 200) {
        await getPendingOrders();
        goToConfirmationTab();
      } else {
        print("Error response while updating order: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating order status: $e");
    }
  }

  Future<void> markOrderAsArrived(String orderId) async {
    try {
      final response = await ApiClient.patch(
        AppUrl.arrivedOrder,
        body: {'order_delivery_id': orderId},
      );

      if (response.statusCode == 200) {
        await getPendingOrders();
        goToConfirmationTab();
      } else {
        print("Error response while updating order: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating order status: $e");
    }
  }

  Future<void> completeOrder() async {
    try {
      final barcodeScanResult = await scanBarcode();
      if (barcodeScanResult == null || barcodeScanResult.isEmpty) {
        Get.snackbar(
          'Dibatalkan',
          'Pemindaian QrCode dibatalkan atau kosong.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final response = await ApiClient.patch(
        AppUrl.completeOrder,
        body: {'transaction_id': barcodeScanResult},
      );

      if (response.statusCode == 200) {
        await getPendingOrders();
        Get.snackbar(
          'Sukses',
          'Pesanan berhasil diselesaikan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        final res = json.decode(response.body);

        print("Error completing order: $res");

        Get.snackbar(
          'Gagal',
          'Gagal menyelesaikan pesanan. Kode QR mungkin tidak valid.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print("Error completing order: $e");
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menyelesaikan pesanan.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<String?> scanBarcode() async {
    try {
      final ScanResult result = await BarcodeScanner.scan(
        options: ScanOptions(
          restrictFormat: [
            BarcodeFormat.qr,
          ],
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
        snackPosition: SnackPosition.TOP,
      );
      return null;
    } catch (e) {
      print("Error umum: $e");
      return null;
    }
  }

  Future<void> showWithdrawalHistory() async {
    try {
      final response = await ApiClient.get(AppUrl.withDrawlHistory);

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
                            title: Text(formatCurrency(double.tryParse(
                                    withdrawal['withdrawal_amount']
                                            ?.toString() ??
                                        '0') ??
                                0)),
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

  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  String capitalizeFirst(String text) {
    return text
        .split('_')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}
