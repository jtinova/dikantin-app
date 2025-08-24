// lib/app/modules/home/views/home_view.dart

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

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.find<HomeController>();
  final _formKey = GlobalKey<FormBuilderState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    bool isFilterActive = controller.selectedCanteenId.value != 'all' ||
        controller.selectedCategoryId.value.isNotEmpty;

    final searchField = _formKey.currentState?.fields['search'];
    bool isSearchActive =
        searchField?.value != null && (searchField?.value as String).isNotEmpty;

    if (isFilterActive || isSearchActive) {
      return;
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      controller.fetchAllMenus();
    }
  }

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
            _formKey.currentState?.fields['search']?.reset();
            await controller.refreshAll();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
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
            badgeAnimation: const badges.BadgeAnimation.slide(),
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
              color: const Color(0xFF1E2857),
              size: 23.r,
            ),
          ),
        ),
      ),
    );
  }
}
