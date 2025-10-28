import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_kantin_controller.dart';
import 'package:dikantin_partner/app/models/history_canteen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeKantinView extends GetView<HomeKantinController> {
  HomeKantinView({super.key});

  @override
  final HomeKantinController controller = Get.put(HomeKantinController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2857),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.refreshData();
          },
          child: Container(
            color: Color(0xFFFEFEFE),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Header()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeKantinController controller = Get.find<HomeKantinController>();

    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          color: Color(0xFF1E2857),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                Obx(() => Text(
                      controller.canteenName.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                SizedBox(height: 16.h),
                Container(
                  width: 180.w,
                  decoration: BoxDecoration(
                    color: Color(0xFFf4f8fa),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.all(4.w),
                  child: Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedItem.value = 'Buka';
                              controller.updateCanteenStatus('open');
                              Get.snackbar(
                                "Status Kantin",
                                "Status diubah ke Buka",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.white,
                                colorText: Colors.black,
                                margin: EdgeInsets.all(10.w),
                                borderRadius: 10.r,
                                duration: Duration(seconds: 2),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedItem.value == 'Buka'
                                    ? Color(0xFF1E2857)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Text(
                                'Buka',
                                style: TextStyle(
                                  color: controller.selectedItem.value == 'Buka'
                                      ? Colors.white
                                      : Color(0xFF1E2857),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedItem.value = 'Tutup';
                              controller.updateCanteenStatus('close');
                              Get.snackbar(
                                "Status Kantin",
                                "Status diubah ke Tutup",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.white,
                                colorText: Colors.black,
                                margin: EdgeInsets.all(10.w),
                                borderRadius: 10.r,
                                duration: Duration(seconds: 2),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedItem.value == 'Tutup'
                                    ? Color(0xFF1E2857)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Text(
                                'Tutup',
                                style: TextStyle(
                                  color:
                                      controller.selectedItem.value == 'Tutup'
                                          ? Colors.white
                                          : Color(0xFF1E2857),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Pendapatan",
                      style: TextStyle(
                          color: Color(0xFFeaeaea),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Hari ini",
                                style: TextStyle(
                                    color: Color(0xFFeaeaea),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w100),
                              ),
                              SizedBox(height: 3.h),
                              Obx(
                                () => Text(
                                  "Rp ${controller.totalIncomeToday.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              "Bulan ini",
                              style: TextStyle(
                                  color: Color(0xFFeaeaea),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w100),
                            ),
                            SizedBox(height: 3.h),
                            Obx(() => Text(
                                  "Rp ${controller.totalIncomeMonth.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ))
                          ],
                        ))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: Color(0xFFf4f8fa),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_rounded,
                                      color: Color(0xFF1E2857),
                                      size: 36.sp,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Dilayani",
                                          style: TextStyle(
                                              color: Color(0xFF1E2857),
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 3.h),
                                        Obx(
                                          () => Text(
                                            "${controller.totalOrderServed.value}",
                                            style: TextStyle(
                                              color: Color(0xFF1E2857),
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Container(
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: Color(0xFFf4f8fa),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.assignment_turned_in_sharp,
                                      color: Color(0xFF1E2857),
                                      size: 36.sp,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Selesai",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 3.h),
                                        Obx(
                                          () => Text(
                                            "${controller.totalOrderDone.value}",
                                            style: TextStyle(
                                              color: Color(0xFF1E2857),
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Riwayat Pesanan',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: RiwayatPesanan()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RiwayatPesanan extends StatelessWidget {
  const RiwayatPesanan({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeKantinController controller = Get.find<HomeKantinController>();

    Widget buildListView(RxList<HistoryModel> data) {
      return Obx(() => ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
            itemCount: data.length >= 2 ? 2 : data.length,
            itemBuilder: (context, index) {
              var item = data[index];
              return Card(
                margin: EdgeInsets.only(bottom: 14.h),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
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
                                      .map((menu) => "${menu.qty} ${menu.name}")
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rp ${controller.formatRupiah(item.totalMainCost)}",
                                  style: TextStyle(
                                    color: Color(0xFF403E3E),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Pembayaran: ${item.paymentMethodLabel}",
                                  style: TextStyle(
                                    color: Color(0xFF7C7C7C),
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ));
    }

    return buildListView(controller.daftarMenu);
  }
}
