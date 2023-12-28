import 'package:android_intent_plus/android_intent.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/providers/services.dart';
import '../pesananKurir/controllers/pesananKurir_controller.dart';

class KirimKurir extends StatefulWidget {
  const KirimKurir({Key? key}) : super(key: key);

  @override
  State<KirimKurir> createState() => _KirimKurirState();
}

class _KirimKurirState extends State<KirimKurir> {
  PesananKurirController controllerc = Get.find<PesananKurirController>();
  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final query = MediaQuery.of(context);
    print('textscalefactor: ${query.textScaleFactor}');
    print('devicePixelRatio: ${query.devicePixelRatio}');
    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async => await controllerc.loadUntukDikirim(),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  content(context),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final baseColorHex = 0xFFE0E0E0;
    final highlightColorHex = 0xFFC0C0C0;
    final mediaHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Container(
      child: Obx(() {
        if (controllerc.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: Color(baseColorHex),
            highlightColor: Color(highlightColorHex),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: mediaHeight,
                child: ListView.builder(
                    itemCount: 5,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: mediaHeight * 0.25,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          );
        } else if (controllerc.pesananUntukDikirim.data?.isEmpty ?? true) {
          return Container(
              height: mediaHeight * 0.40,
              child: Center(
                child: Lottie.asset('assets/notList.json', repeat: true),
              ));
        } else {
          return ListView.builder(
            itemCount: controllerc.pesananUntukDikirim.data!.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final orderData = controllerc.pesananUntukDikirim.data![index];
              final alamat = orderData.transaksi!.alamat;
              final totalHarga = orderData.transaksi!.totalHarga ?? 0;
              return GestureDetector(
                onTap: () {
                  // Get.to(DetailTransaksiView(),
                  //     arguments: orderData.transaksi?.kodeTr);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Sesuaikan dengan radius yang diinginkan
                      ),
                      elevation: 5,
                      // color: Colors.red,
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                                backgroundImage: orderData.transaksi!.foto !=
                                        null
                                    ? NetworkImage(
                                        Api.gambar +
                                            orderData.transaksi!.foto
                                                .toString(),
                                      ) as ImageProvider<Object>
                                    : AssetImage("assets/logo_dikantin.png")),
                            title: Text(
                              "#${orderData.transaksi!.kodeTr.toString()}",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            subtitle: Text(
                              orderData.transaksi!.tanggal.toString(),
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            // color: Colors.blue,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Menu",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                      ),
                                      Text(
                                        "${orderData.transaksi!.detailTransaksi!.length.toString()} menu",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                      ),
                                      Text(
                                        totalHarga.toRupiah(),
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Status",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                        orderData.status
                                                .toString()
                                                .contains('null')
                                            ? ''
                                            : orderData.status.toString(),
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF2579FD),
                                          shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          // await controller.batalkanPesanan(
                                          //     orderData.transaksi!.kodeTr
                                          //         .toString());
                                          // print(orderData
                                          //     .transaksi!.statusKonfirm
                                          //     .toString());
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Lottie.asset(
                                                      "assets/Animation_logout.json", // Ganti dengan nama file Lottie Anda
                                                      width: 100.0,
                                                      height: 100.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    SizedBox(height: 20),
                                                    Center(
                                                      child: Text(
                                                        "Apakah anda yakin?",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff3CA2D9),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize:
                                                              textScaleFactor <=
                                                                      1.15
                                                                  ? 14
                                                                  : 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                        child: Text('Ya'),
                                                        onPressed: () async {
                                                          await controllerc
                                                              .acceptedPesanan(
                                                                  orderData
                                                                      .transaksi!
                                                                      .kodeTr
                                                                      .toString());
                                                          Get.back();
                                                          await Future.delayed(
                                                              Duration(
                                                                  milliseconds:
                                                                      4100));

                                                          final intent = AndroidIntent(
                                                              action:
                                                                  "action_view",
                                                              data: Uri.encodeFull(
                                                                  "google.navigation:q=$alamat&avoid=tf"),
                                                              package:
                                                                  "com.google.android.apps.maps");
                                                          intent.launch();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      ElevatedButton(
                                                        child: Text('Tidak'),
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          "Antar",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          )
                        ],
                      )),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
