// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../order/controllers/order_controller.dart';
import '../../order/widgets/order_detail_content.dart';

class HistoryOrder extends StatefulWidget {
  const HistoryOrder({super.key});

  @override
  State<HistoryOrder> createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  final OrderController controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Riwayat Pemesanan',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          child: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
            size: 25.r,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () {
            return RefreshIndicator(
              onRefresh: () async {
                await controller.getHistory();
              },
              child: controller.historyOrder.isEmpty
                  ? Stack(
                      children: [
                        ListView(),
                        Center(
                          child: Text(
                            "Tidak ada riwayat pesanan",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      itemCount: controller.historyOrder.length,
                      itemBuilder: (context, index) {
                        final order = controller.historyOrder[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.only(bottom: 8.h),
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
                                          Radius.circular(10.r)),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            controller
                                                .formatDateTime(order.date),
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                          Row(
                                            children: [
                                              Text(
                                                controller.capitalizeFirst(
                                                    order.orderType!),
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Icon(Icons.circle, size: 5.r),
                                              SizedBox(width: 5.w),
                                              Text(
                                                controller.capitalizeFirst(
                                                    order.status),
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      controller.getStatusColor(
                                                          order.status),
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
                                Divider(color: Colors.grey, thickness: 1),
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
                                        await controller
                                            .getDetailProgress(order.id);

                                        if (controller.detailOrder.isNotEmpty) {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(15.r),
                                              ),
                                            ),
                                            builder: (context) {
                                              return OrderDetailBottom(
                                                order: controller
                                                    .detailOrder.first,
                                                controller: controller,
                                              );
                                            },
                                          );
                                        } else {
                                          Get.snackbar(
                                            "Informasi",
                                            "Detail pesanan tidak ditemukan",
                                            animationDuration: Duration(
                                              milliseconds: 200,
                                            ),
                                            duration: Duration(
                                              milliseconds: 1650,
                                            ),
                                            backgroundColor: Color.fromARGB(
                                              255,
                                              238,
                                              238,
                                              238,
                                            ),
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
                                        backgroundColor: Color(0xFF1E2857),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 25.w,
                                          vertical: 10.h,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
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
                    ),
            );
          },
        ),
      ),
    );
  }
}
