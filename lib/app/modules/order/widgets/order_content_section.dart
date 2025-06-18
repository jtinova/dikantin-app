// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';
import 'order_detail_content.dart';

class OrderContent extends StatelessWidget {
  const OrderContent({super.key, required this.controller});
  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            final items = controller.progressOrder;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  "Tidak ada pesanan",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(bottom: 3.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                              child: Image.asset(
                                "assets/images/logo_dikantin.png",
                                width: 85.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 13.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.transactionCode,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  controller.formatDateTime(order.date),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                          .capitalizeFirst(order.orderType!),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.circle,
                                      size: 5.r,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      controller.capitalizeFirst(order.status),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: controller
                                            .getStatusColor(order.status),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Harga Total : Rp ${controller.formatRupiah(order.grandTotal)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Text(
                              "Total ${order.totalQty} item",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                await controller.getDetailProgress(order.id);

                                if (controller.detailOrder.isNotEmpty) {
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
                                        order: controller.detailOrder.first,
                                        controller: controller,
                                      );
                                    },
                                  );
                                } else {
                                  Get.snackbar(
                                    "Informasi",
                                    "Detail pesanan tidak ditemukan",
                                    animationDuration:
                                        Duration(milliseconds: 200),
                                    duration: Duration(milliseconds: 1650),
                                    backgroundColor:
                                        Color.fromARGB(255, 238, 238, 238),
                                    borderWidth: 5.w,
                                    snackPosition: SnackPosition.TOP,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 20.h,
                                    ),
                                    icon: Icon(
                                      CupertinoIcons.info_circle,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2857),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          case 1:
            final items = controller.pickUpOrder;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  "Tidak ada pengambilan",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(bottom: 3.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                              child: Image.asset(
                                "assets/images/image_carousel.png",
                                width: 85.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 13.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.transactionCode,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  controller.formatDateTime(order.date),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                          .capitalizeFirst(order.orderType!),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.circle,
                                      size: 5.r,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      controller.capitalizeFirst(order.status),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: controller
                                            .getStatusColor(order.status),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Harga Total : Rp ${controller.formatRupiah(order.grandTotal)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Text(
                              "Total ${order.totalQty} item",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2857),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          case 2:
            final items = controller.shippingOrder;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  "Tidak ada pengiriman",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(bottom: 3.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                              child: Image.asset(
                                "assets/images/image_carousel.png",
                                width: 85.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 13.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.transactionCode,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  controller.formatDateTime(order.date),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                          .capitalizeFirst(order.orderType!),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.circle,
                                      size: 5.r,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      controller.capitalizeFirst(order.status),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: controller
                                            .getStatusColor(order.status),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Harga Total : Rp ${controller.formatRupiah(order.grandTotal)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Text(
                              "Total ${order.totalQty} item",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                await controller.getDetailShipping(order.id);

                                if (controller.detailShipping.isNotEmpty) {
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
                                        order: controller.detailShipping.first,
                                        controller: controller,
                                      );
                                    },
                                  );
                                } else {
                                  Get.snackbar(
                                    "Informasi",
                                    "Detail pesanan tidak ditemukan",
                                    animationDuration:
                                        Duration(milliseconds: 200),
                                    duration: Duration(milliseconds: 1650),
                                    backgroundColor:
                                        Color.fromARGB(255, 238, 238, 238),
                                    borderWidth: 5.w,
                                    snackPosition: SnackPosition.TOP,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 20.h,
                                    ),
                                    icon: Icon(
                                      CupertinoIcons.info_circle,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2857),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          case 3:
            final items = controller.historyOrder;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  "Tidak ada riwayat pesanan",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(bottom: 3.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                              child: Image.asset(
                                "assets/images/image_carousel.png",
                                width: 85.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 13.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.transactionCode,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  controller.formatDateTime(order.date),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                          .capitalizeFirst(order.orderType!),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.circle,
                                      size: 5.r,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      controller.capitalizeFirst(order.status),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: controller
                                            .getStatusColor(order.status),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Harga Total : Rp ${controller.formatRupiah(order.grandTotal)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Text(
                              "Total ${order.totalQty} item",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[400],
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          default:
            return Container();
        }
      }),
    );
  }
}
