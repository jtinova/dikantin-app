import 'package:dikantin/app/data/models/search_model.dart';
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

  void buildBottomSheet(Datasearch menuData, String harga) {
    Get.bottomSheet(
      MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.15)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.black, size: 25),
                        onPressed: () {
                          Get.back(); // Tutup BottomSheet
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          image: NetworkImage(
                              Api.gambar + menuData.foto.toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      menuData.nama ?? '',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Harga: $harga',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {
                      // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                      homeController.addToCart(
                          menuData, homeController.catatanController.text);
                      homeController.catatanController
                          .clear(); // Tutup BottomSheet
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors
                          .blue), // Mengatur warna latar belakang menjadi biru
                    ),
                    child: Text(
                      'Masukkan Keranjang',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    const baseColorHex = 0xFFE0E0E0;
    const highlightColorHex = 0xFFC0C0C0;
    final mediaHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final query = MediaQuery.of(context);

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
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Rekomendasi Dikantin",
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
                      baseColor: const Color(baseColorHex),
                      highlightColor: const Color(highlightColorHex),
                      child: SizedBox(
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
                                    decoration: const BoxDecoration(
                                      color: Color(baseColorHex),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
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
                                              const Color(highlightColorHex),
                                          child: Container(
                                            width: 200,
                                            height: 20,
                                            color: const Color(baseColorHex),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Shimmer.fromColors(
                                          baseColor: Colors.transparent,
                                          highlightColor:
                                              const Color(highlightColorHex),
                                          child: Container(
                                            width: 100,
                                            height: 20,
                                            color: const Color(baseColorHex),
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
                    return SizedBox(
                        height: mediaHeight * 0.25,
                        child: Center(
                          child:
                              Lottie.asset('assets/search.json', repeat: true),
                        ));
                  } else {
                    return SizedBox(
                      height: 275,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeController.penjualan.data?.length ?? 0,
                        reverse: true,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final dataPenjualan =
                              homeController.penjualan.data![index];
                          final String kategori =
                              (dataPenjualan.kategori ?? '').toLowerCase();
                          final String kategoriPesan =
                              kategori == 'makanan' ? 'Porsi' : 'Pcs';
                          final int harga = dataPenjualan.harga ?? 0;
                          final String current = harga.toRupiah();
                          final menuData = Datasearch(
                            idMenu: dataPenjualan.idMenu,
                            nama: dataPenjualan.nama,
                            harga: dataPenjualan.harga,
                            foto: dataPenjualan.foto,
                            statusStok: dataPenjualan.statusStok,
                            kategori: dataPenjualan.kategori,
                            idKantin: dataPenjualan.idKantin,
                            diskon: dataPenjualan.diskon,
                            penjualanHariIni: dataPenjualan.penjualanHariIni,
                          );

                          return GestureDetector(
                            onTap: () {
                              buildBottomSheet(menuData, current);
                            },
                            child: Card(
                              /* color: Theme.of(context).colorScheme.primaryContainer, */
                              /* surfaceTintColor: Theme.of(context).colorScheme.primary, */
                              /* color: Theme.of(context).colorScheme.onPrimary, */
                              clipBehavior: Clip.antiAlias,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 110,
                                      alignment: Alignment.topRight,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(Api.gambar +
                                              menuData.foto.toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              menuData.nama ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Kantin ${menuData.idKantin}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  current,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Obx(() => homeController
                                                        .cartList
                                                        .contains(menuData)
                                                    ? SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Ink(
                                                          decoration:
                                                              const ShapeDecoration(
                                                            shape:
                                                                CircleBorder(),
                                                          ),
                                                          child:
                                                              IconButton.filled(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              homeController
                                                                  .removeFromCart(
                                                                      menuData);
                                                            },
                                                            iconSize: 18,
                                                            icon: const Icon(
                                                                color: Colors
                                                                    .white,
                                                                Icons.remove),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Ink(
                                                          decoration:
                                                              const ShapeDecoration(
                                                            color: Colors.blue,
                                                            shape:
                                                                CircleBorder(),
                                                          ),
                                                          child: IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              homeController.addToCart(
                                                                  menuData,
                                                                  homeController
                                                                      .catatanController
                                                                      .text);
                                                              homeController
                                                                  .catatanController
                                                                  .clear();
                                                            },
                                                            iconSize: 18,
                                                            icon: const Icon(
                                                                color: Colors
                                                                    .white,
                                                                Icons.add),
                                                          ),
                                                        ),
                                                      ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Terlaris Dikantin",
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
                      baseColor: const Color(baseColorHex),
                      highlightColor: const Color(highlightColorHex),
                      child: SizedBox(
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
                                    decoration: const BoxDecoration(
                                      color: Color(baseColorHex),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
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
                                              const Color(highlightColorHex),
                                          child: Container(
                                            width: 200,
                                            height: 20,
                                            color: const Color(baseColorHex),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Shimmer.fromColors(
                                          baseColor: Colors.transparent,
                                          highlightColor:
                                              const Color(highlightColorHex),
                                          child: Container(
                                            width: 100,
                                            height: 20,
                                            color: const Color(baseColorHex),
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
                    return SizedBox(
                        height: mediaHeight * 0.25,
                        child: Center(
                          child:
                              Lottie.asset('assets/search.json', repeat: true),
                        ));
                  } else {
                    return SizedBox(
                      height: 275,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeController.penjualan.data?.length ?? 0,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final dataPenjualan =
                              homeController.penjualan.data![index];
                          final String kategori =
                              (dataPenjualan.kategori ?? '').toLowerCase();
                          final String kategoriPesan =
                              kategori == 'makanan' ? 'Porsi' : 'Pcs';
                          final int harga = dataPenjualan.harga ?? 0;
                          final String current = harga.toRupiah();
                          final menuData = Datasearch(
                            idMenu: dataPenjualan.idMenu,
                            nama: dataPenjualan.nama,
                            harga: dataPenjualan.harga,
                            foto: dataPenjualan.foto,
                            statusStok: dataPenjualan.statusStok,
                            kategori: dataPenjualan.kategori,
                            idKantin: dataPenjualan.idKantin,
                            diskon: dataPenjualan.diskon,
                            penjualanHariIni: dataPenjualan.penjualanHariIni,
                          );

                          return GestureDetector(
                            onTap: () {
                              buildBottomSheet(menuData, current);
                            },
                            child: Card(
                              color: Colors.white,
                              clipBehavior: Clip.antiAlias,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 110,
                                      alignment: Alignment.topRight,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(Api.gambar +
                                              menuData.foto.toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              menuData.nama ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Kantin ${menuData.idKantin}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  current,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Obx(() => homeController
                                                        .cartList
                                                        .contains(menuData)
                                                    ? SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Ink(
                                                          decoration:
                                                              const ShapeDecoration(
                                                            color: Colors.blue,
                                                            shape:
                                                                CircleBorder(),
                                                          ),
                                                          child:
                                                              IconButton.filled(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              homeController
                                                                  .removeFromCart(
                                                                      menuData);
                                                            },
                                                            iconSize: 18,
                                                            icon: const Icon(
                                                                color: Colors
                                                                    .white,
                                                                Icons.remove),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Ink(
                                                          decoration:
                                                              const ShapeDecoration(
                                                            color: Colors.blue,
                                                            shape:
                                                                CircleBorder(),
                                                          ),
                                                          child: IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              homeController.addToCart(
                                                                  menuData,
                                                                  homeController
                                                                      .catatanController
                                                                      .text);
                                                              homeController
                                                                  .catatanController
                                                                  .clear();
                                                            },
                                                            iconSize: 18,
                                                            icon: const Icon(
                                                                color: Colors
                                                                    .white,
                                                                Icons.add),
                                                          ),
                                                        ),
                                                      ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
