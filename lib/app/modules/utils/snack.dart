import 'package:dikantin/app/modules/home/controllers/snack_controller.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/search_model.dart';
import '../../data/providers/services.dart';
import '../home/controllers/home_controller.dart';

class Snack extends StatefulWidget {
  const Snack({Key? key}) : super(key: key);

  @override
  State<Snack> createState() => _SnackState();
}

class _SnackState extends State<Snack> {
  final SnackController controller = Get.put(SnackController());
  final HomeController homeController = Get.find<HomeController>();
  void buildBottomSheet(Datasearch menuData, String harga) {
    Get.bottomSheet(
      MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
                MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.15))),
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
                      menuData.namaKantin ?? '',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
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
                alignment: Alignment.topRight,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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

    final mediaHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
          textScaler:
              TextScaler.linear(query.textScaleFactor.clamp(1.0, 1.15))),
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xFF969696), width: 1.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14.0),
                      )),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search,
                          color: Color(0xFF969696),
                        ),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: controller.searchController,
                        initialValue: null,
                        onChanged: (text) {
                          controller.search(
                              text); // Trigger the search as the user types
                        },
                        decoration: InputDecoration.collapsed(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: "Mau snack apa hari ini ?",
                          hintStyle: TextStyle(
                              color: Colors.grey[500], fontFamily: 'Mulish'),
                          hoverColor: Colors.transparent,
                        ),
                        onFieldSubmitted: (value) {
                          // Get.to(() => searchBuku(keywords: search.toString()));
                        },
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.020,
                ),
                Container(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Shimmer.fromColors(
                        baseColor:
                            Colors.grey[300]!, // Warna base untuk Shimmer
                        highlightColor:
                            Colors.grey[100]!, // Warna highlight untuk Shimmer
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.80,
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: 10,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      side: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else if (controller.searchResults.isEmpty) {
                      return SizedBox(
                        height: mediaHeight * 0.35,
                        child: Center(
                          child:
                              Lottie.asset('assets/search.json', repeat: false),
                        ),
                      );
                    } else {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.70,
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: controller.searchResults.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final menuData = controller.searchResults[index];
                          final harga = menuData.harga ?? 0;
                          final current = harga.toRupiah();

                          return GestureDetector(
                            onTap: () {
                              buildBottomSheet(menuData, current);
                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 110,
                                    alignment: Alignment.topRight,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
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
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            menuData.nama ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            menuData.namaKantin ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                harga.toRupiah(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Obx(() => homeController.cartList
                                                      .contains(menuData)
                                                  ? SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: Ink(
                                                        decoration:
                                                            const ShapeDecoration(
                                                          color: Colors.blue,
                                                          shape: CircleBorder(),
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
                                                          color: Colors.blue,
                                                          shape: CircleBorder(),
                                                        ),
                                                        child:
                                                            IconButton.filled(
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
                          );
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
