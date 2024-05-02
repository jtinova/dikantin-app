import 'package:flutter/material.dart';
import 'package:dikantin/app/modules/navigation/views/navigation_view.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import '../../../data/providers/services.dart';
import '../../home/controllers/home_controller.dart';
import '../../maps/controllers/maps_controller.dart';
import '../../maps/views/maps_view.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/order_controller.dart';

import 'package:get/get.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderView extends GetView<OrderController> {
  OrderView({Key? key}) : super(key: key);

  final HomeController homeController = Get.find<HomeController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final OrderController orderController = Get.put(OrderController());
  final MapsController controllerMaps = Get.put(MapsController());
  BigInt _nominalUserBayar = BigInt.zero;

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final biayakirim = orderController.biayaData.value.data ?? 0;
    final mediaHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Delivery Address",
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 5,
                        ),
                        Obx(
                          () => Text(
                              "Alamat : ${profileController.profile.value.data?.alamat ?? 'Isi dulu alamat'}",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Obx(
                          () => Text(
                              "Keterangan : ${profileController.profile.value.data?.ket ?? 'Isi dulu keterangannya'}",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            //addressBottomsheet(context);
                            Get.to(MapsView(
                              selectedBuilding: profileController
                                      .profile.value.data?.alamat ??
                                  '',
                              keterangan:
                                  profileController.profile.value.data?.ket ??
                                      '',
                              initialSelectedValue: orderController
                                      .unit.value.data?.first.namaGedung ??
                                  'pilih Gedung',
                            ));
                          },
                          child: FittedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.all(4),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    CarbonIcons.request_quote,
                                    size: 14.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Edit Address",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                            'Total',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Biaya kirim',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          Text(
                            '+ ${biayakirim.toRupiah()}',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
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
                            homeController.totalPriceWithKurir.toRupiah(),
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
                                            ? ' Cash '
                                            : ' Qris ',
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
                            MediaQuery.of(context).size.width * 0.70,
                            50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          // Menampilkan dialog saat tombol pesan ditekan
                          /*  */
                          await EasyLoading.show(
                            status: 'loading...',
                            maskType: EasyLoadingMaskType.black,
                          );
                          if (homeController.cartList.isNotEmpty) {
                            // Pengecekan apakah alamat sudah diisi atau tidak
                            if (profileController
                                    .profile.value.data?.alamat?.isEmpty ??
                                true) {
                              // Menampilkan snackbar jika alamat kosong
                              EasyLoading.dismiss();
                              print('EasyLoading dismiss');
                              Get.snackbar('Error', 'Isi dulu alamat Anda');
                            } else {
                              await orderController.getAccurateLocation();
                              // Mendapatkan latitude dan longitude dari lokasi terkini
                              double markerLatitude = double.parse(
                                orderController.myPosition.value.latitude
                                    .toString(),
                              );
                              double markerLongitude = double.parse(
                                orderController.myPosition.value.longitude
                                    .toString(),
                              );
                              // Mencetak latitude dan longitude
                              bool insideCampus = controllerMaps.isInsideCampus(
                                LatLng(markerLatitude, markerLongitude),
                              );
                              if (insideCampus) {
                                EasyLoading.dismiss();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                      'Nominal uang yang akan dibayarkan',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    content: TextFormField(
                                      controller: homeController.nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nominal',
                                        hintText: 'Masukkan nominal uang',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        try {
                                          _nominalUserBayar = BigInt.parse(
                                              value.replaceAll(',', ''));
// Remove commas and prefix
                                        } catch (e) {
                                          // Handle potential parsing errors (e.g., invalid input)
                                          print('Error parsing input: $e');
                                          _nominalUserBayar = 0;
                                          homeController.nameController.text =
                                              ''; // Clear the text field
                                        }

                                        // Update the displayed formatted value
                                        homeController.nameController
                                          ..text = _nominalUserBayar.toRupiah();
                                      },
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (homeController.nominalUserBayar <=
                                              0) {
                                            Get.snackbar('Error',
                                                'Nominal bayar harus lebih dari 0');
                                            return;
                                          }
                                          Navigator.of(context).pop();
                                          await homeController.submitOrder();
                                          Get.snackbar(
                                            'Pesanan berhasil',
                                            'Harap cek pada menu pesanan diproses serta lakukan pembayaran di kurir',
                                            backgroundColor: Colors.blue,
                                            colorText: Colors.white,
                                          );
                                          EasyLoading.dismiss();
                                          print('EasyLoading dismiss');
                                          Future.delayed(
                                              const Duration(seconds: 3), () {
                                            Get.off(NavigationView());
                                          });
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                                // Gunakan keterangan
                              } else {
                                EasyLoading.dismiss();
                                print('EasyLoading dismiss');
                                // Jika di luar kampus, tampilkan snackbar
                                Get.snackbar(
                                  'Gagal Menyimpan',
                                  'Lokasi diluar kampus, Mohon pesan didalam kampus',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          } else {
                            EasyLoading.dismiss();
                            print('EasyLoading dismiss');
                            Get.snackbar('Error', 'Keranjang kosong');
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
              data: orderController.qrData.value.data.toString(),
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
                                  : Colors.grey),
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
