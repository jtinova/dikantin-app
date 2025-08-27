// lib/app/modules/home/widgets/canteen_food_grid.dart
// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/home_controller.dart';
import 'canteen_detail_menu.dart';
import 'rating_menu_content.dart';

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
        if (controller.isMenuLoading.value ||
            (controller.isLoading.value && controller.menus.isEmpty)) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
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
                  return 1.06;
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
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.r),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 92.h,
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
                              height: 15.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Container(
                              height: 15.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              height: 15.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5.r),
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
        } else if (controller.menus.isEmpty) {
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
        } else {
          return Column(
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
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
                      return 1.06;
                    }
                  }(),
                ),
                itemCount: controller.menus.length,
                itemBuilder: (context, index) {
                  final food = controller.menus[index];
                  bool isClosed = food.canteen.status == "close";
                  bool isOutOfStock = food.stock <= 0;
                  bool isUnavailable = isClosed || isOutOfStock;

                  return GestureDetector(
                    onTap: () {
                      // Tracking Interaction
                      controller.trackInteraction(
                        'view_detail_menu',
                        menuId: food.id,
                      );

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
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10.r),
                                ),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    isUnavailable
                                        ? Colors.grey
                                        : Colors.transparent,
                                    BlendMode.saturation,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: food.imageUrl,
                                    width: double.infinity,
                                    height: 90.h,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CupertinoActivityIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/logo_dikantin.png',
                                      width: double.infinity,
                                      height: 90.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5.h,
                                right: 5.w,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RatingMenu(
                                          menuId: food.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.35),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16.r,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          food.rating!.toStringAsFixed(2),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5.h,
                                left: 5.w,
                                child: Obx(
                                  () {
                                    final isFavorited = controller
                                        .favoriteMenuId
                                        .contains(food.id);

                                    return GestureDetector(
                                      onTap: () =>
                                          controller.toggleFavoriteStatus(food),
                                      child: Container(
                                        padding: EdgeInsets.all(3.r),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.35),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isFavorited
                                              ? CupertinoIcons.heart_fill
                                              : CupertinoIcons.heart,
                                          color: isFavorited
                                              ? Colors.redAccent
                                              : Colors.white,
                                          size: 20.r,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10.h,
                              left: 10.w,
                              right: 10.w,
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
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      isClosed ? 'Tutup' : 'Buka',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: isClosed
                                            ? Colors.red
                                            : Colors.green,
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
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 7.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rp ${controller.formatRupiah(food.sellingCost)}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    if (!isUnavailable)
                                      Obx(
                                        () {
                                          int quantity =
                                              controller.getQuantity(food);
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
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            5.r,
                                                          ),
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
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                            0xFF1E2857,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            5.r,
                                                          ),
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
                                                    controller.addToCart(
                                                      food,
                                                      1,
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 18.h,
                                                    width: 20.w,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF1E2857,
                                                      ),
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
              ),
              if (controller.isLoadingMore.value)
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
            ],
          );
        }
      }),
    );
  }
}
