// ignore_for_file: unused_field, deprecated_member_use, must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dikantin_app_rebuild/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../models/menu.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  @override
  final HomeController controller = Get.put(HomeController());

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
    );
  }
}

class Header extends StatelessWidget {
  Header({super.key, required this.formKey, required this.controller});

  final HomeController controller;
  final profileController = Get.find<ProfileController>();

  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 97.5.h,
          color: const Color(0xFF1E2857),
        ),
        Positioned(
          top: 15.h,
          right: 20.w,
          child: IconButton(
            onPressed: () {
              Get.toNamed(Routes.CART);
            },
            icon: Obx(() => badges.Badge(
                  position: badges.BadgePosition.topEnd(
                    top: -10,
                    end: -10,
                  ),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.white,
                  ),
                  badgeAnimation: badges.BadgeAnimation.rotation(),
                  badgeContent: Text(
                    "${controller.cartCount}",
                    style: TextStyle(
                      color: const Color(0xFF1E2857),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.cart_fill,
                    color: Colors.white,
                    size: 28.r,
                  ),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Text(
                'Antar ke :',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    color: Colors.white,
                    size: 20.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Skeletonizer(
                          child: Container(
                            margin: EdgeInsets.only(right: 90.w),
                            height: 23.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.MY_PROFILE);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 90.w),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          height: 23.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  profileController
                                          .users.value?.building?.name ??
                                      'Pilih Lokasi',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Icon(
                                CupertinoIcons.chevron_down,
                                color: Colors.grey,
                                size: 18.r,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 13.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: FormBuilder(
                    key: formKey,
                    child: FormBuilderTextField(
                      name: "search",
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          size: 22.r,
                          color: Colors.black87,
                        ),
                        hintText: "Cari Seleramu",
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black54,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 10.w,
                        ),
                      ),
                      onChanged: (value) {
                        if (value!.isNotEmpty) {
                          controller.getSearchMenu(query: value);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
                      controller.getMenuByCategory(id: category.id);

                      // Highlight this category
                      controller.selectedCategoryId.value = category.id;

                      // Reset canteen to "Semua"
                      controller.selectedCanteenId.value = "all";
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/image_carousel.png'),
                          radius: 30.r,
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

class FoodGrids extends StatelessWidget {
  const FoodGrids({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.h,
        horizontal: 10.w,
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.w,
              mainAxisSpacing: 5.w,
              childAspectRatio: () {
                double width = MediaQuery.of(context).size.width;
                if (width <= 375) {
                  return 0.85;
                } else if (width <= 414) {
                  return 0.96;
                } else {
                  return 1.14;
                }
              }(),
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Skeletonizer(
                enabled: true,
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 15,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 15,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 15,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (controller.menus.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Center(
              child: Text(
                "Tidak ada menu tersedia",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.w,
            mainAxisSpacing: 5.w,
            childAspectRatio: () {
              double width = MediaQuery.of(context).size.width;
              if (width <= 375) {
                return 0.83;
              } else if (width <= 414) {
                return 0.94;
              } else {
                return 1.13;
              }
            }(),
          ),
          itemCount: controller.menus.length,
          itemBuilder: (context, index) {
            final food = controller.menus[index];
            bool isClosed = food.canteen.status == "close";

            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15.r),
                    ),
                  ),
                  builder: (context) {
                    return MenuDetailBottom(
                      food: food,
                      controller: controller,
                    );
                  },
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10.r)),
                      child: ColorFiltered(
                        colorFilter: isClosed
                            ? ColorFilter.mode(
                                Colors.grey,
                                BlendMode.saturation,
                              )
                            : ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.saturation,
                              ),
                        child: Image.network(
                          food.imageUrl,
                          width: double.infinity,
                          height: 90.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 10.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                food.canteen.name,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              Text(
                                controller.capitalizeFirst(food.canteen.status),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isClosed ? Colors.red : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.5.h),
                          Text(
                            food.name,
                            style: TextStyle(
                              fontSize: 15.sp,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rp ${controller.formatRupiah(food.sellingCost)}",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Obx(
                                () {
                                  int quantity = controller.getQuantity(food);
                                  return quantity > 0
                                      ? Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                controller.updateCart(
                                                  food,
                                                  isAdding: false,
                                                );
                                              },
                                              child: Container(
                                                height: 18.h,
                                                width: 20.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                ),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 15.r,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12.5.w),
                                            Text(
                                              "$quantity",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 12.5.w),
                                            GestureDetector(
                                              onTap: () {
                                                controller.updateCart(
                                                  food,
                                                  isAdding: true,
                                                );
                                              },
                                              child: Container(
                                                height: 18.h,
                                                width: 20.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF1E2857),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 15.r,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (!isClosed) {
                                              controller.addToCart(food, 1);
                                            } else {
                                              Get.snackbar(
                                                "Kantin Tutup",
                                                "Tidak dapat menambahkan menu ke keranjang",
                                                animationDuration:
                                                    Duration(milliseconds: 200),
                                                duration: Duration(
                                                    milliseconds: 1650),
                                                backgroundColor: Colors.red,
                                                borderWidth: 5.w,
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                colorText: Colors.white,
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 20.h,
                                                  horizontal: 20.w,
                                                ),
                                                icon: Icon(
                                                  CupertinoIcons.info_circle,
                                                  color: Colors.white,
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 18.h,
                                            width: 20.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF1E2857),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 15.r,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class MenuDetailBottom extends StatelessWidget {
  const MenuDetailBottom(
      {super.key, required this.food, required this.controller});

  final Menu food;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    bool isClosed = food.canteen.status == "close";

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 5.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Center(
            child: Text(
              food.name,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2857),
              ),
            ),
          ),
          SizedBox(height: 7.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Image.network(
              food.imageUrl,
              width: double.infinity,
              height: 140.h,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            food.description,
            style: TextStyle(
              fontSize: 15.sp,
              color: Color(0xFF1E2857),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                "Kantin: ",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E2857),
                ),
              ),
              Text(
                controller.capitalizeFirst(food.canteen.status),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: isClosed ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Text(
                "Harga: Rp ${controller.formatRupiah(food.sellingCost)}",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E2857),
                ),
              ),
              Spacer(),
              Obx(() {
                int quantity = controller.getQuantity(food);
                return quantity > 0
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.updateCart(
                                food,
                                isAdding: false,
                              );
                            },
                            child: Container(
                              height: 18.h,
                              width: 20.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 15.r,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            "$quantity",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          GestureDetector(
                            onTap: () {
                              controller.updateCart(
                                food,
                                isAdding: true,
                              );
                            },
                            child: Container(
                              height: 18.h,
                              width: 20.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFF1E2857),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 15.r,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          if (!isClosed) {
                            controller.addToCart(food, 1);
                          } else {
                            Get.snackbar(
                              "Kantin Tutup",
                              "Tidak dapat menambahkan menu ke keranjang",
                              animationDuration: Duration(milliseconds: 200),
                              duration: Duration(milliseconds: 1650),
                              backgroundColor: Colors.red,
                              borderWidth: 5.w,
                              snackPosition: SnackPosition.TOP,
                              colorText: Colors.white,
                              margin: EdgeInsets.symmetric(
                                vertical: 20.h,
                                horizontal: 20.w,
                              ),
                              icon: Icon(
                                CupertinoIcons.info_circle,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 18.h,
                          width: 20.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFF1E2857),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 15.r,
                            color: Colors.white,
                          ),
                        ),
                      );
              }),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            height: 35.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E2857),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Center(
                child: Text(
                  "Tutup",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
