import 'package:dikantin_partner/app/models/history_canteen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/riwayatkantin_controller.dart';
import '../views/detail_pesanan.dart';

class RiwayatKantinView extends GetView<RiwayatKantinController> {
  RiwayatKantinView({super.key});

  @override
  final RiwayatKantinController controller = Get.put(RiwayatKantinController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2857),
        elevation: 0,
        title: Text(
          "Riwayat Pesanan",
          style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.question_mark_rounded,
              color: Color(0xFFFEFEFE),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  title: Text(
                    'Bantuan',
                    style: TextStyle(
                      color: Color(0xFF19345E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Text(
                      "• Tekan tombol 'Lihat Detail' untuk melihat detail dari pesanan.\n",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Tutup',
                        style: TextStyle(color: Color(0xFF19345E)),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          // Saldo(),
          // Filter(),
          RiwayatPesanan(),
        ],
      )),
    );
  }
}

class RiwayatPesanan extends StatelessWidget {
  const RiwayatPesanan({super.key});

  @override
  Widget build(BuildContext context) {
    final RiwayatKantinController controller =
        Get.find<RiwayatKantinController>();

    Widget buildListView(RxList<HistoryModel> data) {
      return Obx(() => RefreshIndicator(
            onRefresh: () async {
              controller.refreshData();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var item = data[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 10.h),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                item.menu.first.imagePath,
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
                                    item.transactionCode,
                                    style: TextStyle(
                                        color: Color(0xFF403E3E),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 3.h),
                                  Row(
                                    children: [
                                      Text(
                                        item.date,
                                        style: TextStyle(
                                          color: Color(0xFF7C7C7C),
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    item.menu
                                        .map((menu) =>
                                            "${menu.qty} ${menu.name}")
                                        .join(", "),
                                    style: TextStyle(
                                        color: Color(0xFF585858),
                                        fontSize: 13.sp),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Divider(
                            color: Color(0xFFD9D9D9),
                            height: 1.h,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rp ${item.totalMainCost}",
                                      style: TextStyle(
                                          color: Color(0xFF403E3E),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Pembayaran: ${item.paymentMethodLabel}",
                                      style: TextStyle(
                                          color: Color(0xFF7C7C7C),
                                          fontSize: 13.sp),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(() => DetailPesananView(),
                                      arguments: item);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF19345E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                                child: Text(
                                  "Lihat Detail",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ));
    }

    return Expanded(
      child: buildListView(controller.daftarMenu),
    );
  }
}
