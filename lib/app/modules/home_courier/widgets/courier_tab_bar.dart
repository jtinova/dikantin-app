import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/home_courier_controller.dart';

class CourierTabBar extends GetView<HomeCourierController> {
  const CourierTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.tabController.animation!,
      builder: (context, child) {
        return Container(
          height: 45.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: _tabItem(index: 0, title: 'Untuk Dikirim'),
              ),
              Expanded(
                child: _tabItem(index: 1, title: 'Konfirmasi'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tabItem({required int index, required String title}) {
    final bool isSelected = controller.tabController.index == index;

    return GestureDetector(
      onTap: () {
        controller.tabController.animateTo(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E2857) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF1E2857),
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}