import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/home_controller.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5.h,
            horizontal: 15.w,
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Skeletonizer(
                enabled: true,
                child: Container(
                  height: 10.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              );
            }

            return Text(
              'Kategori',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2857),
              ),
            );
          }),
        ),
        Container(
          height: 80.h,
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 15.w,
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Skeletonizer(
                      enabled: true,
                      child: Column(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 2.5.h),
                          Container(
                            width: 63.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (controller.categories.isEmpty) {
              return Center(
                child: Text(
                  'Tidak ada kategori tersedia',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            return ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: controller.categories.map((category) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 3.h,
                    horizontal: 8.w,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Fetch menu by category
                      controller.filterMenuByCategory(category.id);

                      // Highlight this category
                      controller.selectedCategoryId.value = category.id;

                      // Reset canteen to "Semua"
                      controller.selectedCanteenId.value = "all";
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/logo_dikantin.png'),
                          radius: 30.r,
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(height: 2.5.h),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: controller.selectedCategoryId.value ==
                                    category.id
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: Color(0xFF1E2857),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }
}
