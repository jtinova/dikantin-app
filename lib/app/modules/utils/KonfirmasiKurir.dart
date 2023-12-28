import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/providers/services.dart';
import '../pesananKurir/controllers/pesananKurir_controller.dart';

class Konfirmasikurir extends StatefulWidget {
  const Konfirmasikurir({Key? key}) : super(key: key);

  @override
  State<Konfirmasikurir> createState() => _KonfirmasikurirState();
}

class _KonfirmasikurirState extends State<Konfirmasikurir> {
  PesananKurirController controller = Get.find<PesananKurirController>();

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    print('textscalefactor: ${query.textScaleFactor}');
    print('devicePixelRatio: ${query.devicePixelRatio}');
    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async => await controller.loadKonfirmasi(),
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
        } else if (controller.pesananKonfirmasi.data?.isEmpty ?? true) {
          return Container(
              height: mediaHeight * 0.40,
              child: Center(
                child: Lottie.asset('assets/notList.json', repeat: true),
              ));
        } else {
          return ListView.builder(
            itemCount: controller.pesananKonfirmasi.data!.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final orderData = controller.pesananKonfirmasi.data![index];
              final totalHarga = orderData.transaksi!.totalHarga ?? 0;
              bool isStatusSelesai =
                  orderData.status.toString().contains('Selesai');

              // Jika status 'Selesai', maka item tidak ditampilkan
              if (isStatusSelesai) {
                return Container(); // Container kosong untuk item yang disembunyikan
              }
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Nama",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                      ),
                                      Text(
                                        orderData.transaksi!.nama ?? '',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
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
                                        "No. Telepon",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                      ),
                                      Text(
                                        orderData.transaksi!.noTelepon ?? '',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
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
                                            : orderData.status
                                                    .toString()
                                                    .contains('Menunggu 2')
                                                ? "Menunggu"
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
                                      orderData.status
                                              .toString()
                                              .contains('Selesai')
                                          ? Text(
                                              '', // Teks kosong jika orderData.status mengandung 'Selesai'
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : orderData.status
                                                  .toString()
                                                  .contains('Menunggu 2')
                                              ? ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFFD0E0FE),
                                                    shape:
                                                        ContinuousRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    Get.snackbar(
                                                        "Menunggu !!..",
                                                        "Konfirmasi Admin");
                                                  },
                                                  child: Text(
                                                    "Foto Bukti",
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFF2579FD),
                                                    shape:
                                                        ContinuousRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    // fungsi membuka kamera untuk scan qr code dan mengambil value nya
                                                    controller.scanQrCode(
                                                        orderData
                                                            .transaksi!.kodeTr
                                                            .toString());
                                                  },
                                                  child: Text(
                                                    "Foto Bukti",
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
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
