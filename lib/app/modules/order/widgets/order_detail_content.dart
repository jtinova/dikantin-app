// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../models/order_detail.dart';
import '../../profile/widgets/rating_menu_section.dart';
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
          if (order.delivery != null) ...[
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
                  order.delivery!.courierName,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            if (order.delivery!.status == "delivered") ...[
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
                    controller.formatDateTime(order.delivery!.deliveryDate!),
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ] else if (order.delivery!.status == "completed") ...[
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
                    controller.formatDateTime(order.delivery!.deliveryDate!),
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
                    "Waktu Selesai",
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    controller.formatDateTime(order.delivery!.arrivalDate!),
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
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
                  order.delivery!.buildingName,
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
          ],
          ...order.details.map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 3,
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
                      flex: 2,
                      child: Text(
                        "x ${item.qty}",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        controller.capitalizeFirst(item.status),
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    if (order.status == 'done') ...[
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Builder(
                            builder: (context) {
                              final bool hasRated =
                                  item.rating != null && item.rating! > 0;

                              final bool canUpdate =
                                  (item.updateCount ?? 0) < 1;

                              String buttonText;
                              final bool isUpdateAction = hasRated && canUpdate;

                              if (!hasRated) {
                                buttonText = "Nilai";
                              } else if (canUpdate) {
                                buttonText = "Ubah Nilai";
                              } else {
                                buttonText = "Lihat Nilai";
                              }

                              final bool isReadOnly = hasRated && !canUpdate;

                              return TextButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  Get.to(() => RatingMenu(
                                        transactionDetailId: item.id,
                                        menuId: item.id,
                                        menuName: item.name,
                                        isReadOnly: isReadOnly,
                                        isUpdate: isUpdateAction,
                                        orderDate: order.date,
                                        initialRating:
                                            (item.rating ?? 0).toDouble(),
                                        initialComment: item.comment ?? '',
                                      ));
                                },
                                style: TextButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.centerRight,
                                ),
                                child: Text(
                                  buttonText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Rp ${controller.formatRupiah(item.salesSubtotal)}",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
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
                "Metode Pembayaran",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                controller.capitalizeFirst(order.paymentType),
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
                if (order.status == "done" ||
                    order.status == "cancel" ||
                    order.status == "cooking") {
                  Navigator.pop(context);
                } else if (order.status == "pending") {
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

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final String dialogTitle = order.delivery != null
                            ? 'Tunjukkan Barcode ke Kurir'
                            : 'Tunjukkan Barcode ke Kasir';
                        return AlertDialog(
                          title: Text(
                            dialogTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          content: SizedBox(
                            width: 190.w,
                            height: 190.h,
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(
                                  8.w,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2.w,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: QrImageView(
                                  data: order.id,
                                  version: QrVersions.auto,
                                  size: 180.w,
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            SizedBox(
                              width: double.infinity,
                              height: 35.h,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1E2857),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child: Text(
                                  "Tutup",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
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
                order.status == "done" ||
                        order.status == "cancel" ||
                        order.status == "cooking"
                    ? "Tutup"
                    : (order.status == "pending"
                        ? "Batalkan Pesanan"
                        : "Tunjukkan Barcode"),
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
