// ignore_for_file: unused_field, deprecated_member_use, must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

import '../../../routes/app_pages.dart';
import '../controllers/home_courier_controller.dart';

class HomeCourierView extends GetView<HomeCourierController> {
  HomeCourierView({super.key}) {
    Get.put(HomeCourierController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(360, 690), minTextAdapt: true, splitScreenMode: true);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 100)),
        builder: (context, snapshot) {
          return GetX<HomeCourierController>(
            builder: (controller) {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  Container(
                    height: 240.h,
                    color: Color(0xFF1E2857),
                    padding: EdgeInsets.all(20.w),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Saldo Anda',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => Text(
                                        controller.isBalanceVisible.value
                                            ? controller.formatCurrency(
                                                (controller.courierData[
                                                            'total_balance'] ??
                                                        0)
                                                    .toDouble())
                                            : '• • • • • •',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  SizedBox(width: 8.w),
                                  IconButton(
                                    icon: Icon(
                                      controller.isBalanceVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                      size: 20.r,
                                    ),
                                    onPressed: () {
                                      controller.isBalanceVisible.value =
                                          !controller.isBalanceVisible.value;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.COURIER_WITHDRAWAL_HISTORY);
                            },
                            child: Text(
                              'Riwayat Penarikan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Text(
                      'Daftar Pickup Pesanan',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: customTabBar(),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: controller.tabController,
                            children: [
                              // Tab 1: Untuk Dikirim
                              RefreshIndicator(
                                onRefresh: () async {
                                  await controller.getPendingOrders();
                                  await controller.getProfile();
                                },
                                child: controller.pendingOrders.isEmpty
                                    ? ListView(
                                        children: [
                                          SizedBox(height: 50.h),
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Lottie.asset(
                                                  'assets/animations/Animation - 1746119107847.json',
                                                  width: 200.w,
                                                  height: 200.h,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    print(
                                                        "Error loading Lottie: $error");
                                                    return Icon(
                                                      CupertinoIcons.cube_box,
                                                      size: 80.r,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                ),
                                                SizedBox(height: 16.h),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : ListView.builder(
                                        itemCount:
                                            controller.pendingOrders.length,
                                        padding: EdgeInsets.all(10.w),
                                        itemBuilder: (context, index) {
                                          final order =
                                              controller.pendingOrders[index];
                                          return Card(
                                            margin:
                                                EdgeInsets.only(bottom: 10.h),
                                            child: ListTile(
                                              onTap: () {
                                                showOrderDetail(context, order);
                                              },
                                              title: Text(
                                                order['building_name'] ??
                                                    'Lokasi tidak tersedia',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller.formatCurrency(
                                                        (order['grand_total'] ??
                                                                0)
                                                            .toDouble()),
                                                  ),
                                                  Text(
                                                    order['destination_detail'] ??
                                                        'Detail lokasi tidak tersedia',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 4.h),
                                                decoration: BoxDecoration(
                                                  color: getStatusColor(
                                                      order['status']),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r),
                                                ),
                                                child: Text(
                                                  getStatusText(
                                                      order['status']),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),

                              // Tab 2: Konfirmasi
                              RefreshIndicator(
                                onRefresh: () async {
                                  await controller.getPendingOrders();
                                  await controller.getProfile();
                                },
                                child: controller.deliveredOrders.isEmpty
                                    ? ListView(
                                        children: [
                                          SizedBox(height: 50.h),
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Lottie.asset(
                                                  'assets/animations/Animation - 1746119107847.json',
                                                  width: 200.w,
                                                  height: 200.h,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    print(
                                                        "Error loading Lottie: $error");
                                                    return Icon(
                                                      CupertinoIcons
                                                          .check_mark_circled,
                                                      size: 80.r,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                ),
                                                SizedBox(height: 16.h),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : ListView.builder(
                                        itemCount:
                                            controller.deliveredOrders.length,
                                        padding: EdgeInsets.all(10.w),
                                        itemBuilder: (context, index) {
                                          final order =
                                              controller.deliveredOrders[index];
                                          return Card(
                                            margin:
                                                EdgeInsets.only(bottom: 10.h),
                                            child: ListTile(
                                              onTap: () {
                                                showOrderDetail(context, order);
                                              },
                                              title: Text(
                                                order['building_name'] ??
                                                    'Lokasi tidak tersedia',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller.formatCurrency(
                                                        (order['grand_total'] ??
                                                                0)
                                                            .toDouble()),
                                                  ),
                                                  Text(
                                                    order['destination_detail'] ??
                                                        'Detail lokasi tidak tersedia',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 4.h),
                                                decoration: BoxDecoration(
                                                  color: getStatusColor(
                                                      order['status']),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r),
                                                ),
                                                child: Text(
                                                  getStatusText(
                                                      order['status']),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget customTabBar() {
    return AnimatedBuilder(
      animation: controller.tabController.animation!,
      builder: (context, child) {
        return Container(
          height: 45.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: tabItem(index: 0, title: 'Untuk Dikirim'),
              ),
              Expanded(
                child: tabItem(index: 1, title: 'Konfirmasi'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget tabItem({required int index, required String title}) {
    final bool isSelected = controller.tabController.index == index;

    return GestureDetector(
      onTap: () {
        controller.tabController.animateTo(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF1E2857) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Color(0xFF1E2857),
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  void showOrderDetail(BuildContext context, Map<String, dynamic> order) async {
    final details = await controller.getOrderDetail(order['id'].toString());
    final List<dynamic> orderItems = details['transaction_details'] ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Pesanan',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            if (details.isNotEmpty &&
                details['customer_information'] != null) ...[
              DetailRow(
                title: 'Pelanggan',
                value: details['customer_information']['full_name'] ?? '-',
              ),
              DetailRow(
                title: 'No. Telepon',
                value: details['customer_information']['phone_number'] ?? '-',
              ),
              DetailRow(
                title: 'Lokasi',
                value:
                    '${details['customer_information']['building_name'] ?? '-'}\n${details['customer_information']['destination_detail'] ?? '-'}',
              ),
            ],
            if (details.isNotEmpty &&
                details['transaction_summary'] != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Total Item',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${details['transaction_summary']['total_qty'] ?? 0} items',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (orderItems.isNotEmpty)
                          InkWell(
                            onTap: () {
                              _showOrderItemsDialog(context, orderItems);
                            },
                            child: Icon(
                              CupertinoIcons.info_circle,
                              size: 18.r,
                              color: Color(0xFF1E2857),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              DetailRow(
                title: 'Total Harga',
                value: controller.formatCurrency(
                    (details['transaction_summary']['total_selling_cost'] ?? 0)
                        .toDouble()),
              ),
              DetailRow(
                title: 'Biaya Antar',
                value: controller.formatCurrency(
                    (details['transaction_summary']['delivery_fee'] ?? 0)
                        .toDouble()),
              ),
              DetailRow(
                title: 'Total Pembayaran',
                value: controller.formatCurrency(
                    (details['transaction_summary']['grand_total'] ?? 0)
                        .toDouble()),
              ),
              DetailRow(
                title: 'Metode Pembayaran',
                value: controller.capitalizeFirst(
                    details['transaction_summary']['payment_method'] ?? '-'),
              ),
            ],
            SizedBox(height: 20.h),
            if (order['status'] == 'pending') ...{
              ElevatedButton(
                onPressed: () {
                  controller.startOrderToDelivered(order['id'].toString());
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E2857),
                  minimumSize: Size(double.infinity, 45.h),
                ),
                child: Text(
                  'Mulai Antar',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            } else if (order['status'] == 'delivered') ...{
              ElevatedButton(
                onPressed: () {
                  controller.markOrderAsArrived(order['id'].toString());
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 45.h),
                ),
                child: Text(
                  'Sampai Tujuan',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            } else if (order['status'] == 'arrived') ...{
              ElevatedButton(
                onPressed: () {
                  controller.completeOrder();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 45.h),
                ),
                child: Text(
                  'Scan QrCode Pelanggan',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            },
          ],
        ),
      ),
    );
  }

  void _showOrderItemsDialog(BuildContext context, List<dynamic> items) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Detail Item Pesanan',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final String note = item['note'] ?? 'Tidak ada catatan';
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['menu_name'] ?? 'Nama Menu Tidak Tersedia',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Jumlah: ${item['qty']} x ${controller.formatCurrency((item['selling_cost'] ?? 0).toDouble())}',
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                      ),
                      Text(
                        'Catatan: $note',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (index < items.length - 1) Divider(height: 10.h),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Tutup',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.amber;
      case 'delivered':
        return Colors.orange;
      case 'arrived':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'Siap Antar';
      case 'delivered':
        return 'Sedang Diantar';
      case 'arrived':
        return 'Telah Tiba';
      case 'completed':
        return 'Selesai';
      default:
        return 'Unknown';
    }
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
