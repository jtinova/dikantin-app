// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';

import 'package:dikantin_app_rebuild/app/modules/order/views/order_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:badges/badges.dart' as badges;

import '../../chat/views/chat_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/navigation_controller.dart';

class NavigationView extends GetView<NavigationController> {
  NavigationView({super.key});

  int _backButtonPressCount = 0;
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    controller.init();

    return WillPopScope(
      onWillPop: () async {
        if (_backButtonPressCount == 0) {
          _backButtonPressCount++;
          _timer = Timer(const Duration(seconds: 1), () {
            _backButtonPressCount = 0;
          });
          Get.snackbar(
            "Informasi ",
            "Tekan sekali lagi untuk keluar",
            animationDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1650),
            backgroundColor: const Color.fromARGB(255, 238, 238, 238),
            borderWidth: 5.w,
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 20.w,
            ),
            icon: const Icon(
              CupertinoIcons.info_circle,
            ),
          );
          return false;
        } else {
          _timer.cancel();
          return true;
        }
      },
      child: Scaffold(
        body: PageView(
          onPageChanged: controller.animateToPage,
          controller: controller.pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            // Page
            HomeView(),
            // CartView(),
            OrderView(),
            ChatView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(35, 0, 0, 0),
                blurRadius: 10.r,
                spreadRadius: 0.r,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            child: BottomAppBar(
              shape: CircularNotchedRectangle(),
              color: Colors.white,
              notchMargin: 10.w,
              elevation: 0,
              height: 65.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _bottomAppBarItem(
                        context,
                        icon: CupertinoIcons.house_fill,
                        page: 0,
                        label: "Beranda",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: CupertinoIcons.cart_fill,
                        page: 1,
                        label: "Pesanan",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: CupertinoIcons.chat_bubble_2_fill,
                        page: 2,
                        label: "Chat",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: CupertinoIcons.person_fill,
                        page: 3,
                        label: "Profile",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required IconData icon,
    required int page,
    required String label,
  }) {
    bool isCart = page == 1;

    return ZoomTapAnimation(
      onTap: () => controller.goToPage(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isCart
                ? Obx(() => badges.Badge(
                      showBadge: Get.find<HomeController>().cartCount > 0,
                      position: badges.BadgePosition.topEnd(top: -8, end: -8),
                      badgeStyle:
                          const badges.BadgeStyle(badgeColor: Colors.red),
                      badgeContent: Text(
                        "${Get.find<HomeController>().cartCount}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: controller.currentPage.value == page
                            ? const Color(0xFF1E2857)
                            : Colors.grey,
                      ),
                    ))
                : Icon(
                    icon,
                    color: controller.currentPage.value == page
                        ? const Color(0xFF1E2857)
                        : Colors.grey,
                  ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: controller.currentPage.value == page
                    ? const Color(0xFF1E2857)
                    : Colors.grey,
                fontSize: 16.sp,
                fontWeight: controller.currentPage.value == page
                    ? FontWeight.w500
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
