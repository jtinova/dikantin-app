import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../order/controllers/order_controller.dart';

class NavigationController extends GetxController {
  late PageController pageController;

  RxInt currentPage = 0.obs;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    final arguments = Get.arguments;
    if (arguments is Map<String, dynamic> &&
        arguments.containsKey('target_page')) {
      final int targetPage = arguments['target_page'];
      goToPage(targetPage);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (targetPage == 1) {
          if (Get.isRegistered<OrderController>()) {
            final orderController = Get.find<OrderController>();
            orderController.handleNotificationArguments(arguments);
          }
        } else if (targetPage == 3) {
          if (arguments.containsKey('go_to') &&
              arguments['go_to'] == Routes.HISTORY_ORDER) {
            Get.toNamed(Routes.HISTORY_ORDER, arguments: arguments);
          }
        }
      });
    }
  }

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

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
