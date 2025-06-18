// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/home_controller.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (controller.isLoading.value) {
            return Skeletonizer(
              enabled: true,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                ),
                child: Container(
                  width: double.infinity,
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ),
            );
          }

          return CarouselSlider(
            options: CarouselOptions(
              height: 150.h,
              autoPlay: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              viewportFraction: 0.91,
              aspectRatio: 16 / 9,
              autoPlayInterval: Duration(seconds: 5),
              onPageChanged: (index, reason) {
                controller.updateIndex(index);
              },
            ),
            items: controller.bannerList.map((item) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF1E2857),
                    image: DecorationImage(
                      image: AssetImage(item),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
        Obx(() {
          if (controller.isLoading.value) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) {
                  return Container(
                    width: 15.w,
                    height: 2.5.h,
                    margin: EdgeInsets.symmetric(
                      vertical: 6.h,
                      horizontal: 2.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  );
                },
              ),
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.bannerList.asMap().entries.map((entry) {
              int index = entry.key;
              return Container(
                width: 15.w,
                height: 2.5.h,
                margin: EdgeInsets.symmetric(
                  vertical: 6.h,
                  horizontal: 2.w,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: controller.currentIndex.value == index
                      ? const Color(0xFF1E2857)
                      : const Color(0xFF1E2857).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15.r),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
