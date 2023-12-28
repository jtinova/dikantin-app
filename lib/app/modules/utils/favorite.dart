import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/services.dart';
import '../home/controllers/home_controller.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final baseColorHex = 0xFFE0E0E0;
    final highlightColorHex = 0xFFC0C0C0;
    final mediaHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final query = MediaQuery.of(context);
    print('textscalefactor: ${query.textScaleFactor}');
    print('devicePixelRatio: ${query.devicePixelRatio}');
    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: RefreshIndicator(
        onRefresh: () async {
          await homeController.refreshData();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Penuh Diskon",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (homeController.isLoading.value) {
                    return Shimmer.fromColors(
                      baseColor: Color(baseColorHex),
                      highlightColor: Color(highlightColorHex),
                      child: Container(
                        height: mediaHeight * 0.40,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(baseColorHex),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: Colors.transparent,
                                          highlightColor:
                                              Color(highlightColorHex),
                                          child: Container(
                                            width: 100,
                                            height: 20,
                                            color: Color(baseColorHex),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Shimmer.fromColors(
                                          baseColor: Colors.transparent,
                                          highlightColor:
                                              const Color(0xFF67667),
                                          child: Container(
                                            width: 150,
                                            height: 20,
                                            color: Color(baseColorHex),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (homeController.searchResults.isEmpty) {
                    return Container(
                        height: mediaHeight * 0.25,
                        child: Center(
                          child:
                              Lottie.asset('assets/search.json', repeat: true),
                        ));
                  } else {
                    return Container(
                      height: mediaHeight * 0.40,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: homeController.searchResults.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, index) {
                          final menuData = homeController.searchResults[index];
                          final harga = menuData.harga ?? 0;
                          return GestureDetector(
                            onTap: () {
                              homeController.addToCart(
                                  homeController.searchResults[index],
                                  homeController.catatanController.text);
                              homeController.catatanController.clear();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Image.network(
                                      Api.gambar + menuData.foto.toString(),
                                      height: 300,
                                      width: 450,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black
                                        ],
                                        stops: [0.7, 1.0],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 30,
                                    left: 15,
                                    right: 10,
                                    child: Text(
                                      menuData.nama ?? '',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 15,
                                    right: 10,
                                    child: Text(
                                      harga.toRupiah(),
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Pembelian Hari ini",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (homeController.isLoading.value) {
                    return Shimmer.fromColors(
                      baseColor: Color(baseColorHex),
                      highlightColor: Color(highlightColorHex),
                      child: Container(
                        height: mediaHeight * 0.20,
                        child: ListView.builder(
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(baseColorHex),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: Colors.transparent,
                                          highlightColor:
                                              Color(highlightColorHex),
                                          child: Container(
                                            width: 200,
                                            height: 20,
                                            color: Color(baseColorHex),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Shimmer.fromColors(
                                          baseColor: Colors.transparent,
                                          highlightColor:
                                              Color(highlightColorHex),
                                          child: Container(
                                            width: 100,
                                            height: 20,
                                            color: Color(baseColorHex),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (homeController.penjualan.data?.isEmpty ?? true) {
                    return Container(
                        height: mediaHeight * 0.25,
                        child: Center(
                          child:
                              Lottie.asset('assets/search.json', repeat: true),
                        ));
                  } else {
                    return Container(
                      height: mediaHeight * 0.20,
                      child: ListView.builder(
                        itemCount: homeController.penjualan.data?.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, index) {
                          final dataPenjualan =
                              homeController.penjualan.data![index];
                          String kategori =
                              (dataPenjualan.kategori ?? '').toLowerCase();
                          String kategoriPesan =
                              kategori == 'makanan' ? 'Porsi' : 'Pcs';
                          return Container(
                            padding: const EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Image.network(
                                    Api.gambar + dataPenjualan.foto.toString(),
                                    height: 300,
                                    width: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black
                                      ],
                                      stops: [0.4, 1.0],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 30,
                                  left: 15,
                                  right: 10,
                                  child: Text(
                                    '${dataPenjualan.nama ?? ''} Kantin ${dataPenjualan.idKantin}',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 15,
                                  right: 10,
                                  child: Text(
                                    '${dataPenjualan.penjualanHariIni ?? ''} $kategoriPesan',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
