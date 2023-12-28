// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, curly_braces_in_flow_control_structures, duplicate_ignore

import 'package:dikantin/app/data/providers/services.dart';
import 'package:dikantin/app/modules/home/controllers/home_controller.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../pesanan/controllers/pesanan_controller.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  RiwayatView({Key? key}) : super(key: key);
  final RiwayatController riwayatController = Get.find<RiwayatController>();
  final HomeController homeController = Get.find<HomeController>();
  final TextEditingController searchController = TextEditingController();
  PesananController control = Get.find<PesananController>();

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final app = AppBar(
      elevation: 0, // Menghilangkan shadow di bawah AppBar
      backgroundColor: Colors.white, // Membuat AppBar transparan
      actions: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
          child: Image.asset(
            'assets/logo_dikantin.png',
            height: 90, // Sesuaikan dengan tinggi yang Anda inginkan
            width: 90, // Sesuaikan dengan lebar yang Anda inginkan
            fit: BoxFit.cover,
          ),
        ),
      ],
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Riwayat Pesanan",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
    final mediaBody = mediaHeight -
        app.preferredSize.height -
        MediaQuery.of(context).padding.top;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final query = MediaQuery.of(context);
    print('textscalefactor: ${query.textScaleFactor}');
    print('devicePixelRatio: ${query.devicePixelRatio}');
    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        appBar: app,
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            await riwayatController.searchAll();
          },
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25, 15, 25, 15),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFF969696), width: 1.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(14.0),
                          )),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.search,
                              color: Color(0xFF969696),
                            ),
                          ),
                          Expanded(
                              child: TextFormField(
                            controller: searchController,
                            initialValue: null,
                            onChanged: (text) {
                              controller.search(
                                  text,
                                  riwayatController.selectedDate
                                      .toString()); // Trigger the search as the user types
                            },
                            decoration: InputDecoration.collapsed(
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: "Cari Disini..",
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontFamily: 'Mulish'),
                              hoverColor: Colors.transparent,
                            ),
                            onFieldSubmitted: (value) {
                              // Get.to(() => searchBuku(keywords: search.toString()));
                            },
                          ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 25, 0),
                      child: Obx(() {
                        if (riwayatController.selectedDate.value != null) {
                          return Ink(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9)),
                            ),
                            child: IconButton.filled(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                riwayatController.chooseDate();
                              }, // Tambahkan baris ini untuk mengatur warna dasar
                              iconSize: mediaBody * 0.001,
                              icon: const Icon(
                                Icons.edit_calendar_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          );
                        } else {
                          return Ink(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9)),
                            ),
                            child: IconButton.filled(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                // riwayatController.deleteDate();
                                // homeController.removeFromCart(menuData);
                              },
                              iconSize: mediaBody * 0.001,
                              icon: const Icon(
                                Icons.close_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          );
                        }
                      })),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 30),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Pesan Lagi Yuk !! ...",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mediaBody * 0.008,
              ),
              content(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final mediaHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Expanded(
      child: Obx(() {
        if (riwayatController.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!, // Warna base untuk Shimmer
            highlightColor: Colors.grey[100]!, // Warna highlight untuk Shimmer
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.9,
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 10,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        } else if (riwayatController.searchResults.isEmpty) {
          return Container(
            height: mediaHeight * 0.25,
            child: Center(
              child: Lottie.asset('assets/notList.json', repeat: true),
            ),
          );
        } else {
          return ListView.builder(
            physics: const ScrollPhysics(),
            itemCount: riwayatController.searchResults.length,
            itemBuilder: (context, index) {
              final menuData = riwayatController.searchResults[index];
              // final dataRiwayat = homeController.searchResults[index];
              final harga = menuData.harga ?? 0;
              String? tanggal = menuData.createdAt;
              DateTime createdDate = DateTime.parse(
                  tanggal!); // Ganti ini dengan tanggal dari database dalam format datetime
              String formattedDate =
                  DateFormat('dd MMMM y').format(createdDate);
              return GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Sesuaikan dengan radius yang diinginkan
                    ),
                    elevation: 5,
                    // color: Colors.red,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(208, 205, 205, 205),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Color.fromARGB(208, 22, 103, 255),
                                    width: 1,
                                  ),
                                ),
                                alignment: AlignmentDirectional(0.00, 0.00),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      2, 2, 2, 2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(Api.gambar +
                                              menuData.foto.toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 0, 0),
                                        child: Text(
                                          menuData.nama ?? '',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                            color: Color(0xFF101518),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          )),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4, 5, 0, 0),
                                        child: Text(
                                          'Kantin: ${menuData.idKantin ?? ''}',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                            color: Color(0xFF101518),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          )),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4, 5, 0, 0),
                                        child: Text(
                                          formattedDate,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                            color: Color(0xFF101518),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          )),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 5, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4, 0, 0, 0),
                                              child: Text(
                                                harga.toRupiah(),
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                  color: Color(0xFF101518),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4, 0, 0, 0),
                                              child: Text(
                                                '* ${menuData.penjualanHariIni ?? ''}',
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                  color: Color(0xFF101518),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4, 0, 0, 0),
                                              child: Text(
                                                'Harga Awal:',
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                  color: Color(0xFF101518),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(4, 0, 0, 0),
                                              child: Text(
                                                harga.toRupiah(),
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                  color: Color(0xFF101518),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 12,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Color.fromARGB(255, 227, 226, 226),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16, 12, 16, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Harga Per 1 Menu',
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                      color: Color(0xFF101518),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 6, 0, 0),
                                    child: Text(
                                      harga.toRupiah(),
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            textScaleFactor <= 1.15 ? 13 : 13,
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => homeController.cartList.contains(menuData)
                                  ? Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 15, 0),
                                      child: TextButton(
                                        onPressed: () {
                                          print('Button pressed ...');
                                          homeController
                                              .removeFromCart(menuData);
                                          // KeranjangController()
                                          //     .addToCart(menuData.nama ?? '');
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              208, 184, 209, 255),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          side: BorderSide(
                                              color: Colors.transparent,
                                              width: 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'Batalkan',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textScaleFactor <= 1.15
                                                ? 13
                                                : 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ))
                                  : Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 15, 0),
                                      child: TextButton(
                                        onPressed: () {
                                          print(menuData);
                                          homeController.addToCart(
                                              menuData,
                                              homeController
                                                  .catatanController.text);
                                          // KeranjangController()
                                          //     .addToCart(menuData.nama ?? '');
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              208, 107, 159, 255),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          side: BorderSide(
                                              color: Colors.transparent,
                                              width: 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'Pesan Lagi',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textScaleFactor <= 1.15
                                                ? 13
                                                : 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
