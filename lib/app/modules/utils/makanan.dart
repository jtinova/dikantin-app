import 'package:dikantin/app/modules/home/controllers/home_controller.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dikantin/app/modules/home/controllers/makanan_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/providers/services.dart';

class Makanan extends StatefulWidget {
  @override
  State<Makanan> createState() => _MakananState();
}

class _MakananState extends State<Makanan> {
  @override
  Widget build(BuildContext context) {
    final MakananController controller = Get.put(MakananController());
    final HomeController homeController = Get.find<HomeController>();
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

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
          await controller.refreshData();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF969696), width: 1.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14.0),
                      )),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                          hintText: "Mau makan apa hari ini ?",
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
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.80,
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: 10,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
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
                      return Container(
                        height: mediaHeight * 0.35,
                        child: Center(
                          child:
                              Lottie.asset('assets/search.json', repeat: false),
                        ),
                      );
                    } else {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.70,
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: controller.searchResults.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final menuData = controller.searchResults[index];
                          final harga = menuData.harga ?? 0;
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            menuData.nama ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Kantin: ${menuData.idKantin ?? ''}',
                                            style: TextStyle(
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
                                                style: TextStyle(
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
                                                            ShapeDecoration(
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
                                                            ShapeDecoration(
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
