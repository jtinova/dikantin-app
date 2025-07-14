import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/menu.dart';
import '../controllers/home_controller.dart';

class MenuDetailBottom extends StatelessWidget {
  const MenuDetailBottom(
      {super.key, required this.food, required this.controller});

  final Menu food;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    bool isClosed = food.canteen.status == "close";
    bool isOutOfStock = food.stock <= 0;

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
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/logo_dikantin.png',
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            food.description ?? "Tidak ada deskripsi",
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
          if (isOutOfStock || isClosed)
            Text(
              "Harga: Rp ${controller.formatRupiah(food.sellingCost)}",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E2857),
              ),
            )
          else
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
