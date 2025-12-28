import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_courier_controller.dart';

class CourierHeader extends GetView<HomeCourierController> {
  const CourierHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
      color: const Color(0xFF1E2857),
      padding: EdgeInsets.all(20.w),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Saldo Anda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(
                          controller.isBalanceVisible.value
                              ? controller.formatCurrency(
                                  (controller.courierData['total_balance'] ?? 0)
                                      .toDouble())
                              : '• • • • • •',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(width: 8.w),
                    IconButton(
                      icon: Obx(() => Icon(
                            controller.isBalanceVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                            size: 20.r,
                          )),
                      onPressed: () {
                        controller.isBalanceVisible.value =
                            !controller.isBalanceVisible.value;
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15.h),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.COURIER_WITHDRAWAL_HISTORY);
              },
              child: Text(
                'Riwayat Penarikan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}