import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.grey[300],
            height: 1,
          ),
        ),
      ),
      body: Obx(() {
        final groupedItems = homeController.groupedCartItems;

        if (groupedItems.isEmpty) {
          return Center(child: Text("Keranjang kosong"));
        }

        return ListView(
          padding: EdgeInsets.all(10),
          children: groupedItems.entries.map((entry) {
            final canteenName = entry.key;
            final items = entry.value;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 5),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
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
                        SizedBox(width: 5),
                        Text(
                          canteenName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
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
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            CustomCheckbox(
                              value: controller.selectedCartItemIds
                                  .contains(item.menu.id),
                              onChanged: (_) =>
                                  controller.toggleItemSelection(item),
                            ),
                            SizedBox(width: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/image_carousel.png',
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      item.menu.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Rp ${controller.formatRupiah(item.menu.sellingCost)}",
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
                                SizedBox(width: 8),
                                Text("${item.quantity}"),
                                SizedBox(width: 8),
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
              height: 1,
              thickness: 0.5,
              color: Colors.grey[500],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                          SizedBox(width: 3),
                          Text("Semua"),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Total: Rp ${controller.formatRupiah(controller.totalSelectedPrice)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
                          borderWidth: 5.0,
                          snackPosition: SnackPosition.TOP,
                          margin: const EdgeInsets.all(20.0),
                          icon: const Icon(
                            CupertinoIcons.info_circle,
                          ),
                        );
                      } else {
                        Get.to(
                          () => CheckoutView(),
                          binding: BindingsBuilder(
                            () {
                              Get.put(CheckoutController())
                                  .getCalculate(controller.selectedCartItems);
                            },
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E2857),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Checkout (${controller.totalSelectedItems})",
                      style: TextStyle(
                        fontSize: 15,
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
            borderRadius: BorderRadius.circular(3),
          ),
          side: BorderSide(
            color: Colors.grey[400]!,
            width: 1,
          ),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF1E2857);
            }
            return Colors.white;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
        ),
      ),
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
