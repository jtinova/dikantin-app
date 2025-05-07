import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    final CartController cartController = Get.put(CartController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Proses Pesanan",
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
        final data = controller.calculateResult.value;
        final user = profileController.users.value;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 10.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.MY_PROFILE);
                },
                child: Card(
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 16.w,
                        ),
                        child: Text(
                          "Alamat Pengiriman",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Divider(
                          height: 0.h,
                          thickness: 0.5,
                          color: Colors.grey[500],
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 28.r,
                        ),
                        title: Text(
                          user!.fullName,
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "(${controller.formatPhoneNumber(user.phoneNumber)})",
                              style: TextStyle(
                                fontSize: 15.sp,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Lokasi",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 2.h),
                                Text(
                                  ": ",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    user.building?.name ?? 'Nama Gedung Kosong',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Detail",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4.h),
                                Text(
                                  ": ",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    user.detailAddress ??
                                        'Detail Alamat Kosong',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
              ...controller.groupedItemsByCanteen.entries.map((entry) {
                final kantinNama = entry.key;
                final items = entry.value;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.storefront,
                              size: 21.r,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              kantinNama,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Divider(
                          height: 0.h,
                          thickness: 0.5,
                          color: Colors.grey[500],
                        ),
                      ),
                      ...items.map((item) => ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.asset(
                                'assets/images/image_carousel.png',
                                height: 50.h,
                                width: 50.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(item['nama']),
                            subtitle: Text("x ${item['qty']}"),
                            trailing: Text(
                              "Rp ${controller.formatRupiah(item['subtotal'])}",
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                          )),
                      SizedBox(height: 8.h),
                    ],
                  ),
                );
              }),
              Card(
                elevation: 3,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        CupertinoIcons.bag,
                      ),
                      title: Text(
                        "Pilih Opsi",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      trailing: Obx(
                        () => Text(
                          controller.selectedDeliveryOption.value.isEmpty
                              ? "Pilih Opsi"
                              : controller.getDeliveryOptionTitle(
                                  controller.selectedDeliveryOption.value,
                                ),
                          style: TextStyle(
                            fontSize: 15.sp,
                            color:
                                controller.selectedDeliveryOption.value.isEmpty
                                    ? Colors.grey
                                    : Colors.black,
                          ),
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.r),
                            ),
                          ),
                          builder: (_) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 50.w,
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Text(
                                    "Pilih Lokasi Pengambilan",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomRadioTile(
                                    title: "Diantar",
                                    value: "deliver",
                                    groupValue:
                                        controller.selectedDeliveryOption.value,
                                    onChanged: (value) {
                                      controller.selectedDeliveryOption.value =
                                          value!;
                                      Get.back();
                                    },
                                  ),
                                  CustomRadioTile(
                                    title: "Ditempat",
                                    value: "dine_in",
                                    groupValue:
                                        controller.selectedDeliveryOption.value,
                                    onChanged: (value) {
                                      controller.selectedDeliveryOption.value =
                                          value!;
                                      Get.back();
                                    },
                                  ),
                                  CustomRadioTile(
                                    title: "Diambil",
                                    value: "pick_up",
                                    groupValue:
                                        controller.selectedDeliveryOption.value,
                                    onChanged: (value) {
                                      controller.selectedDeliveryOption.value =
                                          value!;
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Divider(
                        height: 0.h,
                        thickness: 0.5,
                        color: Colors.grey[500],
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        CupertinoIcons.creditcard,
                      ),
                      title: Text(
                        "Tipe Pembayaran",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      trailing: Obx(
                        () => Text(
                          controller.selectedPaymentType.value.isEmpty
                              ? "Pilih Opsi"
                              : controller.getPaymentTypeTitle(
                                  controller.selectedPaymentType.value,
                                ),
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: controller.selectedPaymentType.value.isEmpty
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.r),
                            ),
                          ),
                          builder: (_) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 50.w,
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Text(
                                    "Pilih Tipe Pembayaran",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomRadioTile(
                                    title: "Cash",
                                    value: "cash",
                                    groupValue:
                                        controller.selectedPaymentType.value,
                                    onChanged: (value) {
                                      controller.selectedPaymentType.value =
                                          value!;
                                      Get.back();
                                    },
                                  ),
                                  CustomRadioTile(
                                    title: "QRIS",
                                    value: "credit_card",
                                    groupValue:
                                        controller.selectedPaymentType.value,
                                    onChanged: (value) {
                                      controller.selectedPaymentType.value =
                                          value!;
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Divider(
                        height: 0.h,
                        thickness: 0.5,
                        color: Colors.grey[500],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.delivery_dining,
                      ),
                      title: Text(
                        "Biaya Pengiriman",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      trailing: Text(
                        "Rp ${controller.formatRupiah(data?['biaya_ongkir'])}",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final data = controller.calculateResult.value;
        final user = profileController.users.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              height: 1.h,
              thickness: 0.5,
              color: Colors.grey[400],
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 12.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Pembayaran",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Rp ${controller.formatRupiah(data?['total_biaya_pembayaran'])}",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await controller.createOrder(
                        tipePesan: controller.selectedDeliveryOption.value,
                        metodePembayaran: controller.selectedPaymentType.value,
                        gedung: user?.building?.id ?? '',
                        detailLokasi: user?.detailAddress ?? '',
                        selectedItems: cartController.selectedCartItems,
                      );

                      if (success) {
                        cartController.clearCart();
                        Get.offAllNamed(Routes.NAVIGATION);
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
                      "Buat Pesanan",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
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

class CustomRadioTile extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final Function(String?) onChanged;
  final double scale;

  const CustomRadioTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.scale = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      trailing: Transform.scale(
        scale: scale,
        child: Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onTap: () => onChanged(value),
    );
  }
}
