// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  OrderView({super.key});

  @override
  final OrderController controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Pesanan',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            OrderTabs(controller: controller),
            SizedBox(height: 10),
            OrderFilters(controller: controller),
            Expanded(child: OrderContent(controller: controller)),
          ],
        ),
      ),
    );
  }
}

class OrderTabs extends StatelessWidget {
  const OrderTabs({super.key, required this.controller});

  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tabButton("Proses", 0, controller),
              tabButton("Pengiriman", 1, controller),
              tabButton("Riwayat", 2, controller),
            ],
          )),
    );
  }
}

class OrderFilters extends StatelessWidget {
  const OrderFilters({super.key, required this.controller});

  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(() => customDropdown(
              controller.selectedStatus.value,
              controller.statusOptions,
              (newValue) => controller.selectedStatus.value = newValue,
            )),
        Obx(() => customDropdown(
              controller.selectedDate.value,
              controller.dateOptions,
              (newValue) => controller.selectedDate.value = newValue,
            )),
      ],
    );
  }
}

class OrderContent extends StatelessWidget {
  const OrderContent({super.key, required this.controller});
  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.selectedIndex.value) {
        case 0:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1.75,
              ),
              itemCount: controller.orderItems.length,
              itemBuilder: (context, index) {
                final food = controller.orderItems[index];

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.transparent,
                                  BlendMode.saturation,
                                ),
                                child: Image.asset(
                                  food["image"]!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  food["id_order"]!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      food["datetime"]!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.circle,
                                      size: 5,
                                      color: getStatusColor(food["status"]!),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      food["status"]!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              getStatusColor(food["status"]!)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Text(
                                  food["items"]!,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  food["price"]!,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${food["qty"]!} Menu",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2857),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        case 1:
          return Center(
            child: Text("Pengiriman"),
          );
        case 2:
          return Center(
            child: Text("Riwayat"),
          );
        default:
          return Container();
      }
    });
  }
}

Widget tabButton(String title, int index, OrderController controller) {
  return GestureDetector(
    onTap: () => controller.selectedIndex.value = index,
    child: Container(
      width: Get.width / 3.5,
      padding: const EdgeInsets.symmetric(vertical: 4.5),
      decoration: BoxDecoration(
        color: controller.selectedIndex.value == index
            ? Colors.white
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: controller.selectedIndex.value == index
            ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
            : [],
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: controller.selectedIndex.value == index
              ? Colors.black
              : Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

Widget customDropdown(
    String value, List<String> options, Function(String) onChanged) {
  return Container(
    width: 155,
    height: 30,
    padding: EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.grey.shade500,
      ),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        menuMaxHeight: 150,
        borderRadius: BorderRadius.circular(10),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey.shade700,
        ),
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (newValue) => onChanged(newValue!),
        items: options.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    ),
  );
}

Color getStatusColor(String status) {
  switch (status) {
    case "Diproses":
      return Colors.orange;
    case "Dikirim":
      return Colors.blue;
    case "Selesai":
      return Colors.green;
    case "Dibatalkan":
      return Colors.red;
    default:
      return Colors.black;
  }
}
