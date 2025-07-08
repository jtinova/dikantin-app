// lib/app/modules/order/widgets/order_content_section.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';
import 'order_detail_content.dart';

class OrderContent extends StatelessWidget {
  const OrderContent({super.key, required this.controller});
  final OrderController controller;

  // Widget helper untuk menampilkan pesan saat daftar kosong
  Widget _buildEmptyState(String message) {
    return Stack(
      children: [
        ListView(),
        Center(
          child: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderList(List<dynamic> items, BuildContext context) {
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
                    Expanded(
                      child: Column(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                controller.capitalizeFirst(order.orderType!),
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
                                  color:
                                      controller.getStatusColor(order.status),
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
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        // Periksa tipe pesanan untuk memanggil fungsi detail yang benar
                        if (order.orderType == 'deliver' &&
                            order.status == 'on_delivery') {
                          await controller.getDetailShipping(order.id);
                        } else {
                          await controller.getDetailProgress(order.id);
                        }

                        // Tentukan detail mana yang akan ditampilkan
                        final detailToShow = order.orderType == 'deliver' &&
                                order.status == 'on_delivery'
                            ? controller.detailShipping.first
                            : controller.detailOrder.first;

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
                                controller: controller,
                              );
                            },
                          );
                        } else {
                          Get.snackbar(
                            "Informasi",
                            "Detail pesanan tidak ditemukan",
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            return controller.progressOrder.isEmpty
                ? _buildEmptyState("Tidak ada pesanan diproses")
                : _buildOrderList(controller.progressOrder, context);
          case 1:
            return controller.dineInOrder.isEmpty
                ? _buildEmptyState("Tidak ada pesanan untuk di tempat")
                : _buildOrderList(controller.dineInOrder, context);
          case 2:
            return controller.pickUpOrder.isEmpty
                ? _buildEmptyState("Tidak ada pesanan untuk diambil")
                : _buildOrderList(controller.pickUpOrder, context);
          case 3:
            return controller.shippingOrder.isEmpty
                ? _buildEmptyState("Tidak ada pesanan untuk diantar")
                : _buildOrderList(controller.shippingOrder, context);
          default:
            return Container();
        }
      }),
    );
  }
}
