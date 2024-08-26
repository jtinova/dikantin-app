import 'package:dikantin/app/modules/detailTransaksi/views/detail_transaksi_view.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dikantin/app/data/providers/services.dart';

import '../pesanan/controllers/pesanan_controller.dart';
import '../profile/controllers/profile_controller.dart';

class Kirim extends StatefulWidget {
  const Kirim({Key? key}) : super(key: key);

  @override
  State<Kirim> createState() => _KirimState();
}

class _KirimState extends State<Kirim> {
  PesananController controller = Get.find<PesananController>();
  ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
        textScaler: TextScaler.linear(query.textScaleFactor.clamp(1.0, 1.15)),
      ),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async => await controller.loadDikirim(),
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

    const baseColorHex = 0xFFE0E0E0;
    const highlightColorHex = 0xFFC0C0C0;
    final mediaHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Container(
      child: Obx(() {
        if (controller.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: const Color(baseColorHex),
            highlightColor: const Color(highlightColorHex),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: mediaHeight,
                child: ListView.builder(
                    itemCount: 5,
                    physics: const NeverScrollableScrollPhysics(),
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
        } else if (controller.pesananDikirim.data?.isEmpty ?? true) {
          return SizedBox(
              height: mediaHeight * 0.40,
              child: Center(
                child: Lottie.asset('assets/notList.json', repeat: true),
              ));
        } else {
          return ListView.builder(
            itemCount: controller.pesananDikirim.data!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final orderData = controller.pesananDikirim.data![index];
              final totalHarga = orderData.transaksi!.totalHarga ?? 0;
              final waktuPemesanan =
                  formatDateTime(orderData.transaksi!.tanggal.toString());
              /* return GestureDetector(
                onTap: () {
                  Get.to(DetailTransaksiView(),
                      arguments: orderData.transaksi?.kodeTr);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      color: Colors.white,
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
                                      : const AssetImage(
                                          "assets/logo_dikantin.png"),
                            ),
                            title: Text(
                              "#${orderData.transaksi!.kodeTr.toString()}",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            subtitle: Text(
                              orderData.transaksi!.tanggal.toString(),
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
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
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                      ),
                                      Text(
                                        "${orderData.transaksi!.detailTransaksi!.length.toString()} menu",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total",
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                      ),
                                      Text(
                                        totalHarga.toRupiah(),
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
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
                                            textStyle: const TextStyle(
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
              ); */
              return GestureDetector(
                onTap: () {
                  Get.to(() => DetailTransaksiView(),
                      arguments: orderData.transaksi?.kodeTr);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x3f000000),
                              offset: Offset(0, 2),
                              blurRadius: 3.5),
                        ],
                      ),
                      key: ValueKey(orderData.transaksi?.kodeTr),
                      // color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/logo_dikantin.png',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "#${orderData.transaksi!.kodeTr.toString()}",
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Text(
                                      waktuPemesanan,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      orderData.status
                                              .toString()
                                              .contains('null')
                                          ? 'Belum Bayar'
                                          : orderData.status.toString(),
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 13,
                                              color: Colors.orange.shade800,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      totalHarga.toRupiah(),
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Text(
                                      "${orderData.transaksi!.detailTransaksi!.length.toString()} menu",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => DetailTransaksiView(),
                                        arguments: orderData.transaksi?.kodeTr);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Lihat detail',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
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
