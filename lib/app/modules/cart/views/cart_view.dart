import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/cart.dart';
import '../../checkout/controllers/checkout_controller.dart';
import '../../checkout/views/checkout_view.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Keranjang",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            color: Colors.grey[300],
            height: 1.h,
          ),
        ),
      ),
      body: Obx(() {
        final groupedItems = homeController.groupedCartItems;

        if (groupedItems.isEmpty) {
          return Center(
            child: Text(
              "Keranjang kosong",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 10.w,
          ),
          children: groupedItems.entries.map((entry) {
            final canteenName = entry.key;
            final items = entry.value;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 5.h),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 10.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomCheckbox(
                          value: items.every((item) => controller
                              .selectedCartItemIds
                              .contains(item.menu.id)),
                          onChanged: (_) => controller.toggleCanteenSelection(
                              canteenName, groupedItems),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          canteenName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey[500],
                    ),
                    ...items.map((item) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Row(
                          children: [
                            CustomCheckbox(
                              value: controller.selectedCartItemIds
                                  .contains(item.menu.id),
                              onChanged: (_) =>
                                  controller.toggleItemSelection(item),
                            ),
                            SizedBox(width: 5.w),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                item.menu.imageUrl,
                                height: 60.h,
                                width: 60.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/logo_dikantin.png',
                                     height: 60.h,
                                width: 60.w,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 130.w,
                                    child: Text(
                                      item.menu.name,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "Rp ${controller.formatRupiah(item.menu.sellingCost)}",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  SizedBox(
                                    height: 20.h,
                                    child: TextFormField(
                                      controller: controller
                                          .getNoteForItem(item.menu.id),
                                      style: TextStyle(fontSize: 13.sp),
                                      decoration: InputDecoration(
                                        hintText: "Catatan (opsional)",
                                        hintStyle: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.grey,
                                        ),
                                        isDense: true,
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    homeController.updateCart(
                                      item.menu,
                                      isAdding: false,
                                    );
                                  },
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(
                                  width: 12.5.w,
                                ),
                                Text("${item.quantity}"),
                                SizedBox(
                                  width: 12.5.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    homeController.updateCart(
                                      item.menu,
                                      isAdding: true,
                                    );
                                  },
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }),
      bottomNavigationBar: Obx(() {
        final allItems = homeController.cartItems;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              height: 1.h,
              thickness: 0.5,
              color: Colors.grey[500],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomCheckbox(
                            value: controller.selectedCartItemIds.length ==
                                allItems.length,
                            onChanged: (_) =>
                                controller.toggleSelectAll(allItems),
                          ),
                          SizedBox(width: 3.w),
                          Text("Semua"),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Total: Rp ${controller.formatRupiah(controller.totalSelectedPrice)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.selectedCartItems.isEmpty) {
                        Get.snackbar(
                          "Oops",
                          "Silakan pilih menu terlebih dahulu",
                          animationDuration: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 1650),
                          backgroundColor:
                              const Color.fromARGB(255, 238, 238, 238),
                          borderWidth: 5.w,
                          snackPosition: SnackPosition.TOP,
                          margin: EdgeInsets.symmetric(
                            vertical: 20.h,
                            horizontal: 20.w,
                          ),
                          icon: const Icon(
                            CupertinoIcons.info_circle,
                          ),
                        );
                      } else {
                        final List<CartItem> itemsToCheckout =
                            controller.getSelectedCartItemWithCurrentNote();

                        Get.to(
                          () => CheckoutView(),
                          binding: BindingsBuilder(
                            () {
                              Get.put(CheckoutController())
                                  .initializeCheckoutData(itemsToCheckout);
                            },
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E2857),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Text(
                      "Checkout (${controller.totalSelectedItems})",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.r),
          ),
          side: BorderSide(
            color: Colors.grey[400]!,
            width: 1.w,
          ),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF1E2857);
            }
            return Colors.white;
          }),
          checkColor: WidgetStateProperty.all(
            Colors.white,
          ),
        ),
      ),
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        visualDensity: VisualDensity(
          horizontal: -4,
          vertical: -4,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
