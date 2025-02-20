import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
 late PageController pageController;

  RxInt currentPage = 0.obs;

  void goToPage(int page) {
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  void animateToPage(int page) {
    currentPage.value = page;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void init() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
