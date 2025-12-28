// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/home_courier_controller.dart';

class CourierItemDialog extends GetView<HomeCourierController> {
  final List<dynamic> items;

  const CourierItemDialog({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Text(
            'Detail Item Pesanan',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final String note = item['note'] ?? 'Tidak ada catatan';
            final bool isCanceled = item['status'] == 'cancelled';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['menu_name'] ?? 'Nama Menu Tidak Tersedia',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          decoration: isCanceled
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: isCanceled ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                    if (isCanceled)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Text(
                          'Dibatalkan',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Jumlah: ${item['qty']} x ${controller.formatCurrency((item['selling_cost'] ?? 0).toDouble())}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isCanceled ? Colors.grey : Colors.grey[700],
                    decoration: isCanceled
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                Text(
                  'Catatan: $note',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isCanceled ? Colors.grey : Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (index < items.length - 1) Divider(height: 12.h),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF1E2857),
            fixedSize: Size(70.w, 30.h),
          ),
          child: Text(
            'Tutup',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
