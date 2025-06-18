import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';

class OrderFilters extends StatelessWidget {
  const OrderFilters({super.key, required this.controller});

  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(() => customDropdown(
              controller.selectedStatus.value,
              controller.statusOptions,
              (newValue) => controller.selectedStatus.value = newValue,
            )),
        Obx(() => customDropdown(
              controller.selectedDate.value,
              controller.dateOptions,
              (newValue) => controller.selectedDate.value = newValue,
            )),
      ],
    );
  }
}

Widget customDropdown(
  String value,
  List<String> options,
  Function(String) onChanged,
) {
  return Container(
    width: 160.w,
    height: 30.h,
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(
        color: Colors.grey.shade500,
      ),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        menuMaxHeight: 150.h,
        borderRadius: BorderRadius.circular(10.r),
        items: options.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey.shade700,
        ),
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (newValue) => onChanged(newValue!),
      ),
    ),
  );
}
