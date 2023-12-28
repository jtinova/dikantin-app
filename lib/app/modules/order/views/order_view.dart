import 'package:carbon_icons/carbon_icons.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../data/providers/services.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  OrderView({Key? key}) : super(key: key);
  final HomeController homeController = Get.find<HomeController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final mediaHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final query = MediaQuery.of(context);
    print('textscalefactor: ${query.textScaleFactor}');
    print('devicePixelRatio: ${query.devicePixelRatio}');
    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Order',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
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
                child: Icon(
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
              Container(
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
                        SizedBox(
                          height: 5,
                        ),
                        Obx(
                          () => Text(
                              profileController.profile.value.data?.alamat ??
                                  '',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                              )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            addressBottomsheet(context);
                          },
                          child: FittedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
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
                        )
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
                            child: Container(
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
                            physics: ScrollPhysics(),
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
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.65,
                                                      child: Text(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        menuData.nama ?? '',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
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
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "* ${quantity.toString()}",
                                                            style: TextStyle(
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
                                                      style: TextStyle(
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
              Divider(
                indent: 10,
                endIndent: 10,
                thickness: 1.0,
                color: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Obx(
                  () => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Payment',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            homeController.totalPrice.toRupiah(),
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FittedBox(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 7, right: 7, top: 2, bottom: 2),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFD0E0FE),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        homeController.isCashSelected.value
                                            ? ' Cash '
                                            : ' Polije Pay ',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  // Text(
                                  //   'Rp. 50.000',
                                  //   style: GoogleFonts.poppins(
                                  //     textStyle: TextStyle(
                                  //       fontSize: 15,
                                  //       fontWeight: FontWeight.bold,
                                  //       color: Colors.black,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFD0E0FE),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                CarbonIcons.overflow_menu_horizontal,
                                size: 24.0,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2579FD),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.70,
                              50), // Anda dapat menyesuaikan nilai ini untuk mendapatkan lebar yang diinginkan

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (homeController.cartList.isNotEmpty) {
                            homeController.submitOrder();
                            Future.delayed(Duration(seconds: 5), () {
                              Get.offAllNamed('/navigation');
                            });
                          } else {
                            Get.snackbar('Error', 'Keranjang kosong');
                          }
                        },
                        child: Text(
                          'Pesan',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
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
                padding: EdgeInsets.all(10),
                height: 60,
                decoration: BoxDecoration(
                  // color: Colors.orange,
                  border: Border.all(
                    width: 1.5,
                    color: homeController.isCashSelected.value
                        ? Colors.blue
                        : Colors.grey,
                  ),

                  borderRadius: BorderRadius.all(
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
                    SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      CarbonIcons.money,
                      size: 35,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Cash',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
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
            SizedBox(
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
                padding: EdgeInsets.all(10),
                height: 60,
                decoration: BoxDecoration(
                  // color: Colors.orange,
                  border: Border.all(
                    width: 1.5,
                    color: homeController.isPolijePaySelected.value
                        ? Colors.blue
                        : Colors.grey,
                  ),

                  borderRadius: BorderRadius.all(
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
                    SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      CarbonIcons.wallet,
                      size: 35,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Polije Pay',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
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

  void addressBottomsheet(BuildContext context) {
    Get.bottomSheet(Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.30,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: profileController.addressController,
                decoration: InputDecoration(
                  hintText: 'Tolong Inputkan alamat dengan lengkap',
                  filled: true,
                  fillColor: Colors.grey[200], // Atur warna latar belakang
                  hintStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 12), // Atur warna teks hintText
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 15.0), // Sesuaikan nilai vertical
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2579FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await orderController.determinePosition();
                    orderController.locationMessage.value =
                        "${orderController.myPosition.value.latitude} ${orderController.myPosition.value.longitude}";
                    orderController.getAddressFromLatLong(
                        orderController.myPosition.value);
                    profileController.addressController.text =
                        orderController.addressMessage.value;
                  },
                  child: Text(
                    'Lokasi saat ini',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2579FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    profileController.editAlamat(
                        alamat: profileController.addressController.text);
                    Get.back();
                  },
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
