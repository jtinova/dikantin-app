import 'package:dikantin_partner/app/models/history_canteen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/riwayatkantin_controller.dart';

class DetailPesananView extends GetView<RiwayatKantinController> {
  DetailPesananView({super.key});

  @override
  final RiwayatKantinController controller = Get.put(RiwayatKantinController());

  @override
  Widget build(BuildContext context) {
    final HistoryModel data = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
              color: Color(0xFF19345E),
              borderRadius: BorderRadius.circular(10)),
          child: IconButton(
              iconSize: 15.sp,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              )),
        ),
        title: Text(
          "Rincian Pesanan",
          style: TextStyle(
              color: Color(0xFF403E3E),
              fontSize: 17.sp,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Pesanan(item: data),
          ListPesanan(
            item: data,
            controller: controller,
          ),
        ],
      )),
    );
  }
}

class Pesanan extends StatelessWidget {
  const Pesanan({super.key, required this.item});

  final HistoryModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 16.h, left: 10.w, right: 10.w, bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.transactionCode,
                  style: TextStyle(
                      color: Color(0xFF403E3E),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  item.customerName,
                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 13.sp),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Status: ${item.statusLabel}",
                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 13.sp),
                ),
                Text(
                  item.date,
                  style: TextStyle(color: Color(0xFF403E3E), fontSize: 13.sp),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ListPesanan extends StatelessWidget {
  const ListPesanan({super.key, required this.item, required this.controller});

  final HistoryModel item;
  final RiwayatKantinController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pesanan",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4.h),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: item.menu.length,
                itemBuilder: (context, index) {
                  var pesanan = item.menu[index];
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                pesanan.imagePath,
                                width: 60.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 60.w,
                                  height: 60.h,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.redAccent,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pesanan.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFF403E3E),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Rp ${controller.formatRupiah(pesanan.mainCost)}",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xFF403E3E),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "X ${pesanan.qty}",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xFF403E3E),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    pesanan.note!.isNotEmpty
                                        ? "Catatan: ${pesanan.note}"
                                        : "Catatan: -",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFF403E3E),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Divider(color: Color(0xFFD9D9D9), height: 1.h),
                      ),
                    ],
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Modal",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Rp ${controller.formatRupiah(item.totalMainCost)}",
                  style: TextStyle(
                    color: Color(0xFF403E3E),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
