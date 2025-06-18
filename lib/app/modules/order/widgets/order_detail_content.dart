// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/order_detail.dart';
import '../controllers/order_controller.dart';
import 'cancel_order_section.dart';

class OrderDetailBottom extends StatelessWidget {
  const OrderDetailBottom({
    super.key,
    required this.order,
    required this.controller,
  });

  final OrderDetail order;
  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              "Detail Pesanan",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID Transaksi",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                order.transactionCode,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Status Pesanan",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                controller.capitalizeFirst(order.status),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: controller.getStatusColor(order.status),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Waktu Pemesanan",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                controller.formatDateTime(order.date),
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            height: 15.h,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nama Kurir",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                order.status == "on_delivery"
                    ? order.delivery!.courierName
                    : '-',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Waktu Pengiriman",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                order.status == "on_delivery"
                    ? controller.formatDateTime(order.delivery!.deliveryDate!)
                    : '-',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gedung Tujuan",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                order.status == "on_delivery"
                    ? order.delivery!.buildingName
                    : '-',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            height: 15.h,
            color: Colors.grey,
          ),
          ...order.details.map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Tooltip(
                        message: item.name,
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "x ${item.qty}",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        controller.capitalizeFirst(item.status),
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Text(
                      "Rp ${controller.formatRupiah(item.salesSubtotal)}",
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              )),
          Divider(
            thickness: 1,
            height: 15.h,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jumlah Item",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                order.totalQty.toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Biaya Pengiriman",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                "Rp ${controller.formatRupiah(order.deliveryFee)}",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Biaya",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Rp ${controller.formatRupiah(order.grandTotal)}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            height: 30.h,
            child: ElevatedButton(
              onPressed: () async {
                if (order.status == "pending") {
                  Navigator.pop(context);

                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => CancelOrder(
                      controller: controller,
                      order: order,
                    ),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    order.status == "pending" ? Colors.red : Color(0xFF1E2857),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                order.status == "pending"
                    ? "Batalkan Pesanan"
                    : "Tunjukkan Barcode",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
