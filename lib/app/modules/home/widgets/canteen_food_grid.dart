import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/home_controller.dart';
import 'canteen_detail_menu.dart';

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
                  return 0.83;
                } else if (width <= 414) {
                  return 0.94;
                } else {
                  return 1.13;
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
            bool isOutOfStock = food.stock <= 0;

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
                        colorFilter: isClosed || isOutOfStock
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
                          if (isOutOfStock || isClosed)
                            Padding(
                              padding: EdgeInsets.only(top: 1.5.h),
                              child: Text(
                                "Rp ${controller.formatRupiah(food.sellingCost)}",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          else
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
                                              if (!isClosed || !isOutOfStock) {
                                                controller.addToCart(food, 1);
                                              } else {
                                                Get.snackbar(
                                                  "Kantin Tutup",
                                                  "Tidak dapat menambahkan menu ke keranjang",
                                                  animationDuration: Duration(
                                                      milliseconds: 200),
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
