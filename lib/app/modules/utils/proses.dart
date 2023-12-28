// ignore_for_file: prefer_const_declarations

import 'package:dikantin/app/modules/pesanan/controllers/pesanan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/providers/services.dart';
import '../detailTransaksi/views/detail_transaksi_view.dart';
import '../profile/controllers/profile_controller.dart';

class Proses extends StatefulWidget {
  const Proses({Key? key}) : super(key: key);

  @override
  State<Proses> createState() => _ProsesState();
}

class _ProsesState extends State<Proses> {
  PesananController controller = Get.find<PesananController>();
  ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final query = MediaQuery.of(context);
    print('textscalefactor: ${query.textScaleFactor}');
    print('devicePixelRatio: ${query.devicePixelRatio}');
    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: RefreshIndicator(
        onRefresh: () async => await controller.loadProses(),
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
        if (controller.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: Color(baseColorHex),
            highlightColor: Color(highlightColorHex),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: mediaHeight,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
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
        } else if (controller.pesananProses.data?.isEmpty ?? true) {
          return Container(
            height: mediaHeight * 0.25,
            child: Center(
              child: Lottie.asset('assets/notList.json', repeat: true),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controller.pesananProses.data!.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final orderData = controller.pesananProses.data![index];
              final totalHarga = orderData.transaksi!.totalHarga ?? 0;
              return GestureDetector(
                onTap: () {
                  Get.to(DetailTransaksiView(),
                      arguments: orderData.transaksi?.kodeTr);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 5),
                  child: Card(
                      color: Colors.white,
                      key: ValueKey(
                          orderData.transaksi?.kodeTr), // Gunakan key unik
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
                              backgroundImage:
                                  profileController.profile.value.data?.foto !=
                                          null
                                      // ignore: dead_code
                                      ? NetworkImage(
                                          Api.gambar +
                                              profileController
                                                  .profile.value.data!.foto!
                                                  .toString(),
                                        ) as ImageProvider<Object>
                                      : AssetImage("assets/logo_dikantin.png"),
                            ),
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
