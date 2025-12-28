// ignore_for_file: unused_field, deprecated_member_use, must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/home_courier_controller.dart';
import '../widgets/courier_detail_sheet.dart';
import '../widgets/courier_header.dart';
import '../widgets/courier_item_dialog.dart';
import '../widgets/courier_order_list.dart';
import '../widgets/courier_tab_bar.dart';

class HomeCourierView extends GetView<HomeCourierController> {
  HomeCourierView({super.key}) {
    Get.put(HomeCourierController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 100)),
        builder: (context, snapshot) {
          return GetX<HomeCourierController>(
            builder: (controller) {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  const CourierHeader(),
                  
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
                          child: const CourierTabBar(), 
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: controller.tabController,
                            children: [
                              CourierOrderList(
                                orders: controller.pendingOrders,
                                emptyLottieAsset: 'assets/animations/Animation - 1746119107847.json',
                                fallbackEmptyIcon: CupertinoIcons.cube_box,
                                onItemTap: (order) => _showOrderDetail(context, order),
                              ),
                              CourierOrderList(
                                orders: controller.deliveredOrders,
                                emptyLottieAsset: 'assets/animations/Animation - 1746119107847.json',
                                fallbackEmptyIcon: CupertinoIcons.check_mark_circled,
                                onItemTap: (order) => _showOrderDetail(context, order),
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

  void _showOrderDetail(BuildContext context, Map<String, dynamic> order) async {
    final details = await controller.getOrderDetail(order['id'].toString());
    final List<dynamic> orderItems = details['transaction_details'] ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => CourierDetailSheet(
        order: order,
        details: details,
        orderItems: orderItems,
        controller: controller,
        onShowItems: (items) => _showOrderItemsDialog(context, items),
      ),
    );
  }

  void _showOrderItemsDialog(BuildContext context, List<dynamic> items) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CourierItemDialog(items: items);
      },
    );
  }
}