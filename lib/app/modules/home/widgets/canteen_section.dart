// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/home_controller.dart';

class Canteens extends StatelessWidget {
  const Canteens({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 7.h,
      ),
      child: SizedBox(
        height: 30.h,
        child: Obx(() {
          if (controller.isLoading.value) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                  ),
                  child: Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: 75.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: controller.canteens.map((canteen) {
              bool isSelected =
                  controller.selectedCanteenId.value == canteen.id;

              return GestureDetector(
                onTap: () {
                  // Fetch menu by canteen
                  controller.getMenuByCanteen(id: canteen.id, context: context);

                  // Highlight this canteen
                  controller.selectedCanteenId.value = canteen.id;

                  // Reset category selection
                  controller.selectedCategoryId.value = "";
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                  ),
                  child: Container(
                    width: 75.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: isSelected
                          ? Color(0xFF1E2857)
                          : Color(0xFF1E2857).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      canteen.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isSelected ? Colors.white : Color(0xFF1E2857),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
