// ignore_for_file: prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/order_detail.dart';
import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  OrderView({super.key});

  @override
  final OrderController controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Pesanan',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshAll();
          },
          child: LayoutBuilder(builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    OrderTabs(controller: controller),
                    SizedBox(height: 10.h),
                    OrderFilters(controller: controller),
                    SizedBox(height: 5.h),
                    Expanded(child: OrderContent(controller: controller)),
                  ],
                ),
              ),
            );
          }),
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
      height: 35.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tabButton("Diproses", 0, controller),
              tabButton("Diambil", 1, controller),
              tabButton("Diantar", 2, controller),
              tabButton("Riwayat", 3, controller),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            final items = controller.progressOrder;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  "Tidak ada pesanan",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(bottom: 3.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                              child: Image.asset(
                                "assets/images/logo_dikantin.png",
                                width: 85.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 13.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.transactionCode,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  controller.formatDateTime(order.date),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                          .capitalizeFirst(order.orderType!),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.circle,
                                      size: 5.r,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      controller.capitalizeFirst(order.status),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: getStatusColor(order.status),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Harga Total : Rp ${controller.formatRupiah(order.grandTotal)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Text(
                              "Total ${order.totalQty} item",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                await controller.getDetailProgress(order.id);

                                if (controller.detailOrder.isNotEmpty) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.r),
                                      ),
                                    ),
                                    builder: (context) {
                                      return OrderDetailBottom(
                                        order: controller.detailOrder.first,
                                        controller: controller,
                                      );
                                    },
                                  );
                                } else {
                                  Get.snackbar(
                                    "Informasi",
                                    "Detail pesanan tidak ditemukan",
                                    animationDuration:
                                        Duration(milliseconds: 200),
                                    duration: Duration(milliseconds: 1650),
                                    backgroundColor:
                                        Color.fromARGB(255, 238, 238, 238),
                                    borderWidth: 5.w,
                                    snackPosition: SnackPosition.TOP,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 20.h,
                                    ),
                                    icon: Icon(
                                      CupertinoIcons.info_circle,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2857),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(
                                  fontSize: 15.sp,
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
            );
          case 1:
            final items = controller.pickUpOrder;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  "Tidak ada pengambilan",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(bottom: 3.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                              child: Image.asset(
                                "assets/images/image_carousel.png",
                                width: 85.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 13.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.transactionCode,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  controller.formatDateTime(order.date),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                          .capitalizeFirst(order.orderType!),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.circle,
                                      size: 5.r,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      controller.capitalizeFirst(order.status),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: getStatusColor(order.status),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Harga Total : Rp ${controller.formatRupiah(order.grandTotal)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Text(
                              "Total ${order.totalQty} item",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2857),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
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
            );
          case 2:
            final items = controller.shippingOrder;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  "Tidak ada pengiriman",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(bottom: 3.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                              child: Image.asset(
                                "assets/images/image_carousel.png",
                                width: 85.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 13.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.transactionCode,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  controller.formatDateTime(order.date),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                          .capitalizeFirst(order.orderType!),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.circle,
                                      size: 5.r,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      controller.capitalizeFirst(order.status),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: getStatusColor(order.status),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Harga Total : Rp ${controller.formatRupiah(order.grandTotal)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Text(
                              "Total ${order.totalQty} item",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                await controller.getDetailShipping(order.id);

                                if (controller.detailShipping.isNotEmpty) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.r),
                                      ),
                                    ),
                                    builder: (context) {
                                      return OrderDetailBottom(
                                        order: controller.detailShipping.first,
                                        controller: controller,
                                      );
                                    },
                                  );
                                } else {
                                  Get.snackbar(
                                    "Informasi",
                                    "Detail pesanan tidak ditemukan",
                                    animationDuration:
                                        Duration(milliseconds: 200),
                                    duration: Duration(milliseconds: 1650),
                                    backgroundColor:
                                        Color.fromARGB(255, 238, 238, 238),
                                    borderWidth: 5.w,
                                    snackPosition: SnackPosition.TOP,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 20.h,
                                    ),
                                    icon: Icon(
                                      CupertinoIcons.info_circle,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2857),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(
                                  fontSize: 15.sp,
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
            );
          case 3:
            final items = controller.historyOrder;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  "Tidak ada riwayat pesanan",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.only(bottom: 3.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final order = items[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                              child: Image.asset(
                                "assets/images/image_carousel.png",
                                width: 85.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 13.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.transactionCode,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  controller.formatDateTime(order.date),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                          .capitalizeFirst(order.orderType!),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.circle,
                                      size: 5.r,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      controller.capitalizeFirst(order.status),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: getStatusColor(order.status),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Harga Total : Rp ${controller.formatRupiah(order.grandTotal)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Text(
                              "Total ${order.totalQty} item",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[400],
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
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
            );
          default:
            return Container();
        }
      }),
    );
  }
}

class OrderDetailBottom extends StatelessWidget {
  OrderDetailBottom({
    super.key,
    required this.order,
    required this.controller,
  });

  final OrderDetail order;
  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
          SizedBox(height: 10.h),
          Center(
            child: Text(
              "Detail Pesanan",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID Transaksi",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                order.transactionCode,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Status Pesanan",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                controller.capitalizeFirst(order.status),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: getStatusColor(order.status),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Waktu Pemesanan",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                controller.formatDateTime(order.date),
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            height: 15.h,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nama Kurir",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                order.status == "on_delivery"
                    ? order.delivery!.courierName
                    : '-',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Waktu Pengiriman",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                order.status == "on_delivery"
                    ? controller.formatDateTime(order.delivery!.deliveryDate!)
                    : '-',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gedung Tujuan",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                order.status == "on_delivery"
                    ? order.delivery!.buildingName
                    : '-',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            height: 15.h,
            color: Colors.grey,
          ),
          ...order.details.map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Tooltip(
                        message: item.name,
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "x ${item.qty}",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        controller.capitalizeFirst(item.status),
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Text(
                      "Rp ${controller.formatRupiah(item.salesSubtotal)}",
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              )),
          Divider(
            thickness: 1,
            height: 15.h,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jumlah Item",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                order.totalQty.toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Biaya Pengiriman",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
              Text(
                "Rp ${controller.formatRupiah(order.deliveryFee)}",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Biaya",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Rp ${controller.formatRupiah(order.grandTotal)}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            height: 30.h,
            child: ElevatedButton(
              onPressed: () async {
                if (order.status == "pending") {
                  await controller.cancelOrder(order.id);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    order.status == "pending" ? Colors.red : Color(0xFF1E2857),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                order.status == "pending" ? "Batalkan" : "Tutup",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget tabButton(
  String title,
  int index,
  OrderController controller,
) {
  return GestureDetector(
    onTap: () => controller.selectedIndex.value = index,
    child: Container(
      width: Get.width / 4.7.w,
      padding: EdgeInsets.symmetric(vertical: 4.7.h),
      decoration: BoxDecoration(
        color: controller.selectedIndex.value == index
            ? Colors.white
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: controller.selectedIndex.value == index
            ? [BoxShadow(color: Colors.black12, blurRadius: 4.r)]
            : [],
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: controller.selectedIndex.value == index
              ? Colors.black
              : Colors.grey,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

Widget customDropdown(
  String value,
  List<String> options,
  Function(String) onChanged,
) {
  return Container(
    width: 160.w,
    height: 30.h,
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(
        color: Colors.grey.shade500,
      ),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        menuMaxHeight: 150.h,
        borderRadius: BorderRadius.circular(10.r),
        items: options.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey.shade700,
        ),
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (newValue) => onChanged(newValue!),
      ),
    ),
  );
}

Color getStatusColor(String status) {
  switch (status) {
    case "pending":
      return Color(0xFF1E2857);
    case "cooking":
      return Colors.orange;
    case "Siap Diambil":
      return Colors.deepPurple;
    case "on_delivery":
      return Colors.blue;
    case "done":
      return Colors.green;
    case "cancel":
      return Colors.red;
    default:
      return Colors.black;
  }
}
