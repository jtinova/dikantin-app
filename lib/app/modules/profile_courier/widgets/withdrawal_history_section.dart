import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/courier_profile_controller.dart';

class WithdrawalHistoryView extends GetView<CourierProfileController> {
  const WithdrawalHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final CourierProfileController controller =
        Get.find<CourierProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Penarikan',
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          child: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
            size: 25.sp,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.withdrawalHistory.isEmpty) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (controller.withdrawalHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_toggle_off,
                    size: 80.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Belum ada riwayat penarikan',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          // Tampilkan daftar riwayat jika ada
          return RefreshIndicator(
            onRefresh: () async {
              await controller.getWithdrawalHistory();
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
              itemCount: controller.withdrawalHistory.length,
              itemBuilder: (context, index) {
                final history = controller.withdrawalHistory[index];
                final double amount = double.tryParse(
                        history['withdrawal_amount']?.toString() ?? '0') ??
                    0.0;
                final String formattedDate = history['withdrawal_date'] != null
                    ? DateFormat('dd MMM yyyy | HH:mm', 'id_ID')
                        .format(DateTime.parse(history['withdrawal_date']))
                    : '-';

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ListTile(
                    leading: Icon(
                      CupertinoIcons.news,
                      color: Color(0xFF1E2857),
                    ),
                    title: Text(
                      controller.formatCurrency(amount),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Icon(
                      CupertinoIcons.checkmark_seal,
                      color: Color(0xFF1E2857),
                      size: 25.sp,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
