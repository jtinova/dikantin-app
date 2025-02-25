// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../chat/views/chat_view.dart';
import '../../home/views/home_view.dart';
import '../../order/views/order_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/navigation_controller.dart';

class NavigationView extends GetView<NavigationController> {
  NavigationView({super.key});

  // Variables to track back button
  int _backButtonPressCount = 0;
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    controller.init();

    return WillPopScope(
      onWillPop: () async {
        if (_backButtonPressCount == 0) {
          // start a timer to reset the count if not pressed again
          _backButtonPressCount++;
          _timer = Timer(const Duration(seconds: 1), () {
            _backButtonPressCount = 0;
          });
          // Show a snackbar or toast indicating press again to exit
          Get.snackbar(
            "Information",
            "Press again to exit",
            animationDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1650),
            backgroundColor: Color(0xFF1E2857),
            colorText: Colors.white,
            borderWidth: 5.0,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(20.0),
            icon: const Icon(
              CupertinoIcons.info_circle,
              color: Colors.white,
            ),
          );
          return false; // Do not exit the app yet
        } else {
          // Second press within the timer duration, exit the app
          _timer.cancel(); // Cancel the timer
          return true; // Allow the app to exit
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
            OrderView(),
            const ChatView(),
            const ProfileView(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(35, 0, 0, 0),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomAppBar(
              shape: CircularNotchedRectangle(),
              color: Colors.white,
              notchMargin: 10,
              elevation: 0,
              height: 70,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
    return ZoomTapAnimation(
      onTap: () => controller.goToPage(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: controller.currentPage.value == page
                  ? Color(0xFF1E2857)
                  : Colors.grey,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: controller.currentPage.value == page
                    ? Color(0xFF1E2857)
                    : Colors.grey,
                fontSize: 13,
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
