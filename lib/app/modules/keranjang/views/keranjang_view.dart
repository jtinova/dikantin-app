// ignore_for_file: unused_local_variable

import 'package:carbon_icons/carbon_icons.dart';
import 'package:dikantin/app/modules/order/views/order_view.dart';
import 'package:dikantin/app/modules/orderKantin/views/order_kantin_view.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/search_model.dart';
import '../../../data/providers/services.dart';
import '../../home/controllers/home_controller.dart';
import '../../order/controllers/order_controller.dart';
import '../controllers/keranjang_controller.dart';

class KeranjangView extends GetView<KeranjangController> {
  KeranjangView({Key? key}) : super(key: key);
  final HomeController homeController = Get.find<HomeController>();
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Keranjang',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              homeController.catatanController.clear();
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Obx(
                  () => homeController.cartList.isEmpty
                      ? Container(
                          child: Center(
                              child: Lottie.asset('assets/notList.json',
                                  repeat: false)),
                        )
                      : ListView.builder(
                          itemCount: homeController.cartList.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final menuData = homeController.cartList[index];
                            final harga = menuData.harga ?? 0;
                            Datasearch item = homeController.cartList[index];

                            final int priceAfterDiscount = homeController
                                .calculatePriceAfterDiscount(menuData);

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(13, 10, 13, 0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Sesuaikan dengan radius yang diinginkan
                                ),
                                elevation: 5,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
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
                                                              0.55,
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
                                                    InkWell(
                                                      onTap: () {
                                                        homeController
                                                            .removeFromCart(
                                                                menuData);
                                                        homeController
                                                            .catatanController
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      priceAfterDiscount
                                                          .toRupiah(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                        harga ==
                                                                priceAfterDiscount
                                                            ? ''
                                                            : harga.toRupiah(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          color: Colors.red,
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Obx(
                                                  () => Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xFFD0E0FE),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  SharedPreferences
                                                                      prefs =
                                                                      await SharedPreferences
                                                                          .getInstance();
                                                                  String?
                                                                      catatan =
                                                                      prefs.getString(
                                                                          'catatan');
                                                                  print(
                                                                      catatan);
                                                                  homeController
                                                                      .subtractQuantity(
                                                                          menuData
                                                                              .idMenu!);
                                                                },
                                                                child: Icon(
                                                                  color: Colors
                                                                      .blue,
                                                                  Icons.remove,
                                                                  size: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                                '${homeController.itemQuantities[menuData.idMenu] ?? 1}', // Tampilkan kuantitas dari map

                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 12,
                                                                )),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  homeController
                                                                      .addQuantity(
                                                                          menuData
                                                                              .idMenu!);
                                                                  print(
                                                                      textScaleFactor);
                                                                },
                                                                child: Icon(
                                                                  color: Colors
                                                                      .white,
                                                                  Icons.add,
                                                                  size: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        homeController
                                                            .calculateSubtotal(
                                                                menuData
                                                                    .idMenu!)
                                                            .toRupiah(),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),

                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton.icon(
                                                      icon: Icon(
                                                        Icons.note_alt,
                                                        size: textScaleFactor <=
                                                                1.15
                                                            ? 18
                                                            : 18,
                                                        color: Colors.black,
                                                      ),
                                                      label: Text(
                                                        "Catatan",
                                                        style: TextStyle(
                                                            fontSize:
                                                                textScaleFactor <=
                                                                        1.15
                                                                    ? 10
                                                                    : 9,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            ContinuousRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Get.bottomSheet(
                                                          Container(
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: ListView(
                                                                children: [
                                                                  TextFormField(
                                                                    controller: homeController
                                                                        .catatanController
                                                                      ..text = homeController
                                                                          .getNoteForMenu(
                                                                              item.idMenu!),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: textScaleFactor <=
                                                                              1.15
                                                                          ? 14
                                                                          : 14,
                                                                    ), // Adjust the fontSize as needed

                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          'Contoh: Nasi setengah ya!',
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        borderSide: BorderSide(
                                                                            color:
                                                                                Colors.purple,
                                                                            width: 1),
                                                                      ),
                                                                    ),
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines:
                                                                        10,
                                                                    maxLength:
                                                                        250,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              Colors.blue,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          // Mendapatkan catatan dari controller
                                                                          String
                                                                              catatan =
                                                                              homeController.catatanController.text;

                                                                          // Menyimpan catatan untuk item menu yang sesuai
                                                                          homeController.saveNoteForMenu(
                                                                              menuData.idMenu!,
                                                                              catatan);
                                                                          Get.back();
                                                                        },
                                                                        child: Text(
                                                                            "Simpan",
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 14,
                                                                            )),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                // Obx(
                                                //   () => Text(homeController
                                                //       .getNoteForMenu(
                                                //           item.idMenu!)),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
            Divider(
              height: 2,
              color: Color(0xFFEAEAEA),
              thickness: 2,
              indent: 40, //spacing at the start of divider
              endIndent: 40,
            ),
            // height: 100.0,
            // decoration: const BoxDecoration(
            //   color: Colors.orange,
            // ),
            Obx(
              () => Container(
                padding:
                    EdgeInsets.only(bottom: 10, right: 20, left: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Jumlah : ${homeController.count}",
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(homeController.totalPrice.toRupiah(),
                            style: GoogleFonts.poppins(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (homeController.cartList.isNotEmpty) {
                              Get.defaultDialog(
                                title: "Pilih Metode Pesanan",
                                content: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Pilih kantin
                                        Get.back(); // Tutup dialog

                                        Get.to(() => OrderKantinView());
                                      },
                                      child: Text("DiKantin ?"),
                                    ),
                                    Text("Atau"),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // Pilih online
                                        Get.back(); // Tutup dialog
                                        Get.toNamed('/order');
                                        await homeController.fetchbiayakurir();
                                        await orderController.fetchbiayakurir();
                                      },
                                      child: Text("Dianter ?"),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              Get.snackbar('Error', 'Your cart is empty');
                            }
                          },
                          child: Text("Pesan Sekarang",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
