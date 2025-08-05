import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../widgets/banner_section.dart';
import '../widgets/canteen_food_grid.dart';
import '../widgets/canteen_section.dart';
import '../widgets/category_section.dart';
import '../widgets/header_section.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0xFF1E2857),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshAll();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(formKey: _formKey, controller: controller),
                BannerCarousel(controller: controller),
                Categories(controller: controller),
                Canteens(controller: controller),
                FoodGrids(controller: controller),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.CART);
        },
        backgroundColor: Colors.white,
        child: Obx(
          () => badges.Badge(
            showBadge: Get.find<HomeController>().cartCount > 0,
            position: badges.BadgePosition.topEnd(
              top: -8.h,
              end: -8.h,
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red,
            ),
            badgeAnimation: badges.BadgeAnimation.slide(),
            badgeContent: Text(
              "${controller.cartCount}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Icon(
              CupertinoIcons.cart_fill,
              color: Color(0xFF1E2857),
              size: 23.r,
            ),
          ),
        ),
      ),
    );
  }
}