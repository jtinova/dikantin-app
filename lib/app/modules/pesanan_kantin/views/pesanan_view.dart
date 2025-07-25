import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pesanan_controller.dart';
import 'package:animations/animations.dart';
import 'detail_pesanan.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dikantin_app_rebuild/app/models/order_canteen.dart';


class PesananKantinView extends GetView<PesananController> {
  PesananKantinView({super.key});

  @override
  final PesananController controller = Get.put(PesananController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2857),
        elevation: 0,
        title: Text(
          "Pesanan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp, 
            fontWeight: FontWeight.w500
          ),
        ),  
        actions: [
          IconButton(
            icon:  Icon(Icons.question_mark_rounded, color: Color(0xFFFEFEFE),),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  title: Text(
                    'Bantuan',
                    style: TextStyle(
                      color: Color(0xFF19345E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Text(
                      "• Tekan tab 'Pesanan Masuk' untuk melihat daftar pesanan baru.\n"
                      "• Tekan tab 'Dimasak' untuk melihat daftar pesanan dimasak.\n"
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
        child: Container(
          color: Color(0xFFFEFEFE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              Expanded(child: Pesanan()),
            ],
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
    final PesananController controller = Get.find<PesananController>();

    return Container(
      color: Color(0xFFFEFEFE),
      child: TabBar(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        controller: controller.tabController,
        isScrollable: false,
        labelColor: Color(0xFF19345E),
        unselectedLabelColor: Colors.grey[400],
        indicatorColor: Color(0xFF19345E),
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(text: "Pesanan Masuk"),
          Tab(text: "Dimasak"),
        ],
      ),
    );
  }
}

class Pesanan extends StatelessWidget {
  const Pesanan({super.key});

  @override
  Widget build(BuildContext context) {
    final PesananController controller = Get.find<PesananController>();

    Widget buildListView(RxList<TransactionModel> data) {
      return Obx(() => RefreshIndicator(
        onRefresh: () async {
            controller.refreshData();
          },
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          itemCount: data.length,
          itemBuilder: (context, index) {
            var item = data[index];
            return Card(
              margin: EdgeInsets.only(bottom: 10.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            item.details.first.imagePath,
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
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
                              SizedBox(height: 5.h),
                              Row(
                                children: [
                                  Text(
                                    item.dateTime,
                                    style: TextStyle(
                                      color: Color(0xFF7C7C7C),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                item.details
                                    .map((menu) =>
                                        "${menu.qty} ${menu.name}")
                                    .join(", "),
                                style: TextStyle(
                                    color: Color(0xFF585858), fontSize: 13.sp),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
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
                                "Rp ${item.mainCost}",
                                style: TextStyle(
                                    color: Color(0xFF403E3E),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${item.totalQty} Pesanan",
                                style: TextStyle(
                                    color: Color(0xFF7C7C7C), fontSize: 13.sp),
                              ),
                            ],
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
      child: PageTransitionSwitcher(
        duration: Duration(milliseconds: 1000),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: TabBarView(
          key: ValueKey(controller.tabController.index),
          controller: controller.tabController,
          children: [
            buildListView(controller.pesananMasuk),
            buildListView(controller.pesananDimasak),
          ],
        ),
      ),
    );
  }
}