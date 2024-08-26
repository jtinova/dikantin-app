import 'package:flutter/material.dart';
import 'package:dikantin/app/modules/navigation/views/navigation_view.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import '../../../data/providers/services.dart';
import '../../home/controllers/home_controller.dart';
import '../../maps/controllers/maps_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/order_kantin_controller.dart';

import 'package:get/get.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderKantinView extends GetView<OrderKantinController> {
  OrderKantinView({Key? key}) : super(key: key);

  final HomeController homeController = Get.find<HomeController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final MapsController controllerMaps = Get.put(MapsController());
  final OrderKantinController orderKantinController =
      Get.put(OrderKantinController());

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final mediaHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
        textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Order',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  CarbonIcons.arrow_left,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Obx(
                    () => homeController.cartList.isEmpty
                        ? Center(
                            child: SizedBox(
                              height: mediaHeight * 0.33,
                              child: Column(
                                children: [
                                  Center(
                                      child: Lottie.asset('assets/ceklist.json',
                                          repeat: true)),
                                  Column(
                                    children: [
                                      Text(
                                        "Transaksi Berhasil !!",
                                        style: TextStyle(
                                            fontSize: textScaleFactor <= 1.15
                                                ? 15
                                                : 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Ditunggu ya untuk pesanannya",
                                        style: TextStyle(
                                            fontSize: textScaleFactor <= 1.15
                                                ? 15
                                                : 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: homeController.cartList.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              final menuData = homeController.cartList[index];
                              final harga = menuData.harga ?? 0;
                              final int priceAfterDiscount = homeController
                                  .calculatePriceAfterDiscount(menuData);
                              final int quantity = homeController
                                      .itemQuantities[menuData.idMenu!] ??
                                  1;

                              return Card(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(
                                //       10.0), // Sesuaikan dengan radius yang diinginkan
                                // ),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            alignment: Alignment.topLeft,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(Api
                                                          .gambar +
                                                      menuData.foto.toString()),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.60,
                                                      child: Text(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        menuData.nama ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            priceAfterDiscount
                                                                .toRupiah(),
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "* ${quantity.toString()}",
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      homeController
                                                          .calculateSubtotal(
                                                              menuData.idMenu!)
                                                          .toRupiah(),
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ],
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
                  ),
                ),
              ),
              const Divider(
                indent: 10,
                endIndent: 10,
                thickness: 1.0,
                color: Colors.grey,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Obx(
                  () => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Payment',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            homeController.totalPrice.toRupiah(),
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          paymentMethod(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    homeController.isCashSelected.value
                                        ? CarbonIcons.money
                                        : CarbonIcons.wallet,
                                    size: 24.0,
                                    color: homeController.isCashSelected.value
                                        ? Colors.blue
                                        : Colors.blue,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  FittedBox(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 7, right: 7, top: 2, bottom: 2),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFD0E0FE),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        homeController.isCashSelected.value
                                            ? 'Cash '
                                            : 'Qris',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFD0E0FE),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(
                                CarbonIcons.overflow_menu_horizontal,
                                size: 24.0,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2579FD),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.70, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await EasyLoading.show(
                            status: 'loading...',
                            maskType: EasyLoadingMaskType.black,
                          );
                          if (homeController.cartList.isNotEmpty) {
                            // Pengecekan apakah alamat sudah diisi atau tidak
                            await homeController.submitOrderOnline();
                            EasyLoading.dismiss();
                            print('EasyLoading dismiss');
                            Get.defaultDialog(
                                barrierDismissible: false,
                                title:
                                    "Harap cek pada menu pesanan(belum bayar) untuk melakukan pembayaran di kasir dan tunjukkan QRcode",
                                titleStyle: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                content: ElevatedButton(
                                    onPressed: () async {
                                      await orderKantinController.fetchQr();
                                      dialog();
                                    },
                                    child: const Text('Ok')));

                            // Gunakan keterangan
                          } else {
                            EasyLoading.dismiss();
                            print('EasyLoading dismiss');
                            Get.snackbar(
                              'Gagal Order',
                              'Server Error',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Text(
                          'Pesan',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void dialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'Scan QR Code',
      titleStyle: GoogleFonts.poppins(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      content: Column(
        children: [
          SizedBox(
            width: 240, // Set a specific width for the QR code
            height: 240, // Set a specific height for the QR code
            child: QrImageView(
              data: orderKantinController.qrData.value.data.toString(),
              version: QrVersions.auto,
              size: 70,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              Get.off(NavigationView());
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  void paymentMethod(BuildContext context) {
    Get.bottomSheet(Container(
      height: MediaQuery.of(context).size.height * 0.30,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                // Ubah nilai variabel untuk menandai pembayaran cash
                homeController.isCashSelected.value = true;
                homeController.isPolijePaySelected.value = false;
                Get.back();
              },
              child: Container(
                //
                padding: const EdgeInsets.all(10),
                height: 60,
                decoration: BoxDecoration(
                  // color: Colors.orange,
                  border: Border.all(
                    width: 1.5,
                    color: homeController.isCashSelected.value
                        ? Colors.blue
                        : Colors.grey,
                  ),

                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      // ini container dot
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: homeController.isCashSelected.value
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          color: homeController.isCashSelected.value
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      CarbonIcons.money,
                      size: 35,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Cash',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                // Ubah nilai variabel untuk menandai pembayaran Polije Pay
                homeController.isCashSelected.value = false;
                homeController.isPolijePaySelected.value = true;
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 60,
                decoration: BoxDecoration(
                  // color: Colors.orange,
                  border: Border.all(
                    width: 1.5,
                    color: homeController.isPolijePaySelected.value
                        ? Colors.blue
                        : Colors.grey,
                  ),

                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: homeController.isPolijePaySelected.value
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          color: homeController.isPolijePaySelected.value
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      CarbonIcons.wallet,
                      size: 35,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Qris',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
