// lib/app/modules/home/widgets/recommendation_section.dart
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

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    double childAspectRatio = () {
      double width = MediaQuery.of(context).size.width;
      if (width <= 375) {
        return 0.85;
      } else if (width <= 414) {
        return 0.96;
      } else {
        return 1.06;
      }
    }();

    double cardWidth = (MediaQuery.of(context).size.width / 2) - 15.w;
    double containerHeight = cardWidth / childAspectRatio + 15.h;

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
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              );
            }
            return Text(
              'Rekomendasi Menu',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            );
          }),
        ),
        SizedBox(
          height: containerHeight,
          child: Obx(() {
            if (controller.isLoading.value) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                padding: EdgeInsets.only(
                  left: 15.w,
                  right: 5.w,
                  bottom: 10.h,
                  top: 5.h,
                ),
                itemBuilder: (context, index) {
                  return Skeletonizer(
                    enabled: true,
                    child: SizedBox(
                      width: cardWidth,
                      child: Card(
                        elevation: 3,
                        margin: EdgeInsets.only(right: 13.w),
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
                    ),
                  );
                },
              );
            }

            if (controller.recommendedMenus.isEmpty) {
              return Center(
                child: Text(
                  'Tidak ada rekomendasi menu',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.recommendedMenus.length,
              padding: EdgeInsets.only(
                left: 15.w,
                right: 5.w,
                bottom: 10.h,
                top: 5.h,
              ),
              itemBuilder: (context, index) {
                final food = controller.recommendedMenus[index];
                bool isClosed = food.canteen.status == "close";
                bool isOutOfStock = food.stock <= 0;
                bool isUnavailable = isClosed || isOutOfStock;

                return SizedBox(
                  width: cardWidth,
                  child: GestureDetector(
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
                      margin: EdgeInsets.only(right: 13.w),
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
                                    Expanded(
                                      child: Text(
                                        food.canteen.name,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
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
                                  maxLines: 1,
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
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
