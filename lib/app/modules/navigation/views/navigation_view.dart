// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../home_kantin/views/home_kantin_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/navigation_controller.dart';
import '../../pesanan_kantin/views/pesanan_view.dart';
import '../../menu_kantin/views/menu_view.dart';
import '../../riwayat_kantin/views/riwayatkantin_view.dart';

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
            "Informasi ",
            "Tekan sekali lagi untuk keluar",
            animationDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1650),
            backgroundColor: const Color.fromARGB(255, 238, 238, 238),
            borderWidth: 5.0,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(20.0),
            icon: const Icon(
              CupertinoIcons.info_circle,
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
            HomeKantinView(),
            MenuKantinView(),
            PesananKantinView(),
            RiwayatKantinView(),
            ProfileView(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.pageController.jumpToPage(2);
          },
          backgroundColor: Color(0xFF1E2857),
          child: Icon(
            CupertinoIcons.news_solid,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              height: 74,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                        icon: CupertinoIcons.square_list_fill,
                        page: 1,
                        label: "Menu",
                      ),
                      SizedBox(width: 48), 
                      _bottomAppBarItem(
                        context,
                        icon: CupertinoIcons.doc_chart_fill,
                        page: 3,
                        label: "Riwayat",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: CupertinoIcons.person_fill,
                        page: 4, 
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
