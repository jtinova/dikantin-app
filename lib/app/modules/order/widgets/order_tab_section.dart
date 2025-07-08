import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';

class OrderTabs extends StatelessWidget {
  const OrderTabs({super.key, required this.controller});

  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tabButton("Diproses", 0, controller),
              tabButton("Ditempat", 1, controller),
              tabButton("Diambil", 2, controller),
              tabButton("Diantar", 3, controller),
            ],
          )),
    );
  }
}

Widget tabButton(
  String title,
  int index,
  OrderController controller,
) {
  return GestureDetector(
    onTap: () => controller.selectedIndex.value = index,
    child: Container(
      width: Get.width / 4.7.w,
      padding: EdgeInsets.symmetric(vertical: 4.7.h),
      decoration: BoxDecoration(
        color: controller.selectedIndex.value == index
            ? Colors.white
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: controller.selectedIndex.value == index
            ? [BoxShadow(color: Colors.black12, blurRadius: 4.r)]
            : [],
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: controller.selectedIndex.value == index
              ? Colors.black
              : Colors.grey,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
