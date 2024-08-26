import 'package:dikantin/app/data/models/search_model.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/kantin_model.dart';
import '../../data/models/menu_model.dart';
import '../../data/providers/services.dart';
import '../home/controllers/home_controller.dart';
import '../home/controllers/kantin_controller.dart';

class Kantin extends StatefulWidget {
  const Kantin({Key? key}) : super(key: key);

  @override
  State<Kantin> createState() => _KantinState();
}

class _KantinState extends State<Kantin> {
  final KantinController controller = Get.put(KantinController());
  final HomeController homeController = Get.find<HomeController>();

  void buildBottomSheet(Datasearch menuData, String harga) {
    Get.bottomSheet(
      MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.15),
        ),
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
        textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await homeController.refreshData();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              children: [
                Obx(() {
                  if (controller.isLoading.value) {
                    return Shimmer.fromColors(
                      baseColor: const Color(baseColorHex),
                      highlightColor: const Color(highlightColorHex),
                      child: SizedBox(
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
                                            width: 100,
                                            height: 20,
                                            color: const Color(baseColorHex),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Shimmer.fromColors(
                                          baseColor: Colors.transparent,
                                          highlightColor:
                                              const Color(0x0ff67667),
                                          child: Container(
                                            width: 150,
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
                  } else if (controller.kantinResults.isEmpty) {
                    return SizedBox(
                        height: mediaHeight * 0.25,
                        child: Center(
                          child:
                              Lottie.asset('assets/search.json', repeat: true),
                        ));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: controller.kantinResults.length,
                      itemBuilder: (BuildContext context, index) {
                        final kantin = controller.kantinResults[index];
                        final menuKantin = controller.menuKantinResults
                            .where((menu) => menu.idKantin == kantin.idKantin)
                            .toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                kantin.nama.toString(),
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  280, // Ubah tinggi container sesuai kebutuhan
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: menuKantin.length,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final menu = menuKantin[index];
                                  final harga = menu.harga ?? 0;
                                  final current = harga.toRupiah();

                                  return GestureDetector(
                                    onTap: () {
                                      buildBottomSheet(menu, current);
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        side: BorderSide(
                                            color: Colors.grey.shade200),
                                      ),
                                      child: SizedBox(
                                        width: 150,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 110,
                                              alignment: Alignment.topRight,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      Api.gambar +
                                                          menu.foto.toString()),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      menu.nama ?? '',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      menu.namaKantin ?? '',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          harga.toRupiah(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Obx(() =>
                                                            homeController
                                                                    .cartList
                                                                    .contains(
                                                                        menu)
                                                                ? SizedBox(
                                                                    height: 30,
                                                                    width: 30,
                                                                    child: Ink(
                                                                      decoration:
                                                                          const ShapeDecoration(
                                                                        color: Colors
                                                                            .blue,
                                                                        shape:
                                                                            CircleBorder(),
                                                                      ),
                                                                      child: IconButton
                                                                          .filled(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        onPressed:
                                                                            () {
                                                                          homeController
                                                                              .removeFromCart(menu);
                                                                        },
                                                                        iconSize:
                                                                            18,
                                                                        icon: const Icon(
                                                                            color:
                                                                                Colors.white,
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
                                                                        color: Colors
                                                                            .blue,
                                                                        shape:
                                                                            CircleBorder(),
                                                                      ),
                                                                      child:
                                                                          IconButton(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        onPressed:
                                                                            () {
                                                                          homeController.addToCart(
                                                                              menu,
                                                                              homeController.catatanController.text);
                                                                          homeController
                                                                              .catatanController
                                                                              .clear();
                                                                        },
                                                                        iconSize:
                                                                            18,
                                                                        icon: const Icon(
                                                                            color:
                                                                                Colors.white,
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
                            ),
                          ],
                        );
                      },
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
