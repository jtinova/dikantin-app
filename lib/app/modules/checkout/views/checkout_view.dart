import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        title: const Text(
          "Proses Pesanan",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[300],
            height: 1,
          ),
        ),
      ),
      body: Obx(() {
        final data = controller.calculateResult.value;
        final user = profileController.users.value;

        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(10),
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              child: Text(
                                "Alamat Pengiriman",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                height: 0,
                                thickness: 0.5,
                                color: Colors.grey[500],
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 28,
                              ),
                              title: Text(
                                user!.fullName,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "(${controller.formatPhoneNumber(user.phoneNumber)})",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Lokasi",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        ": ",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          user.building?.name ??
                                              'Nama Gedung Kosong',
                                          style: const TextStyle(
                                            fontSize: 15,
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
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        ": ",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          user.detailAddress ??
                                              'Detail Alamat Kosong',
                                          style: const TextStyle(
                                            fontSize: 15,
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
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.storefront,
                                    size: 21,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    kantinNama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                height: 0,
                                thickness: 0.5,
                                color: Colors.grey[500],
                              ),
                            ),
                            ...items.map((item) => ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/images/image_carousel.png',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(item['nama']),
                                  subtitle: Text("x ${item['qty']}"),
                                  trailing: Text(
                                    "Rp ${controller.formatRupiah(item['subtotal'])}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 8),
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
                            title: const Text(
                              "Pilih Opsi",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            trailing: Obx(
                              () => Text(
                                controller.selectedDeliveryOption.value.isEmpty
                                    ? "Pilih Opsi"
                                    : controller.getDeliveryOptionTitle(
                                        controller
                                            .selectedDeliveryOption.value),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: controller
                                          .selectedDeliveryOption.value.isEmpty
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (_) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 50,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        const Text(
                                          "Pilih Lokasi Pengambilan",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomRadioTile(
                                          title: "Ditempat",
                                          value: "dine_in",
                                          groupValue: controller
                                              .selectedDeliveryOption.value,
                                          onChanged: (value) {
                                            controller.selectedDeliveryOption
                                                .value = value!;
                                            Get.back();
                                          },
                                        ),
                                        CustomRadioTile(
                                          title: "Diantar",
                                          value: "deliver",
                                          groupValue: controller
                                              .selectedDeliveryOption.value,
                                          onChanged: (value) {
                                            controller.selectedDeliveryOption
                                                .value = value!;
                                            Get.back();
                                          },
                                        ),
                                        CustomRadioTile(
                                          title: "Diambil",
                                          value: "pick_up",
                                          groupValue: controller
                                              .selectedDeliveryOption.value,
                                          onChanged: (value) {
                                            controller.selectedDeliveryOption
                                                .value = value!;
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
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(
                              height: 0,
                              thickness: 0.5,
                              color: Colors.grey[500],
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              CupertinoIcons.creditcard,
                            ),
                            title: const Text(
                              "Tipe Pembayaran",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            trailing: Obx(
                              () => Text(
                                controller.selectedPaymentType.value.isEmpty
                                    ? "Pilih Opsi"
                                    : controller.getPaymentTypeTitle(
                                        controller.selectedPaymentType.value),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: controller
                                          .selectedPaymentType.value.isEmpty
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (_) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 50,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        const Text(
                                          "Pilih Tipe Pembayaran",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomRadioTile(
                                          title: "Cash",
                                          value: "cash",
                                          groupValue: controller
                                              .selectedPaymentType.value,
                                          onChanged: (value) {
                                            controller.selectedPaymentType
                                                .value = value!;
                                            Get.back();
                                          },
                                        ),
                                        CustomRadioTile(
                                          title: "QRIS",
                                          value: "credit_card",
                                          groupValue: controller
                                              .selectedPaymentType.value,
                                          onChanged: (value) {
                                            controller.selectedPaymentType
                                                .value = value!;
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
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(
                              height: 0,
                              thickness: 0.5,
                              color: Colors.grey[500],
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.delivery_dining,
                            ),
                            title: const Text(
                              "Biaya Pengiriman",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            trailing: Text(
                              "Rp ${controller.formatRupiah(data?['biaya_ongkir'])}",
                              style: const TextStyle(
                                fontSize: 14,
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
            Divider(height: 1, thickness: 0.5, color: Colors.grey[400]),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Pembayaran",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Rp ${controller.formatRupiah(data?['total_biaya_pembayaran'])}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.createOrder(
                        tipePesan: controller.selectedDeliveryOption.value,
                        metodePembayaran: controller.selectedPaymentType.value,
                        gedung: user?.building?.id ?? '',
                        detailLokasi: user?.detailAddress ?? '',
                        selectedItems: cartController.selectedCartItems,
                      );

                      cartController.clearCart();
                      Get.offAllNamed(Routes.NAVIGATION);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2857),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Buat Pesanan",
                      style: const TextStyle(
                        fontSize: 16,
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
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onTap: () => onChanged(value),
    );
  }
}
