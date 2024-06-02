import 'package:android_intent_plus/android_intent.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:dikantin/app/data/models/pesanan_kirim_model.dart';
import 'package:dikantin/app/data/providers/services.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:dikantin/app/modules/utils/widgets/status_pesanan_kurir.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/detail_pesanan_kurir_controller.dart';

class DetailPesananKurirView extends GetView<DetailPesananKurirController> {
  const DetailPesananKurirView({super.key});
  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    const baseColorHex = 0xFFE0E0E0;
    const highlightColorHex = 0xFFC0C0C0;
    final mediaHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final orderId = Get.arguments as String?;
    final DetailPesananKurirController controller =
        Get.put(DetailPesananKurirController());

    controller.fecthPesanan(orderId.toString());

    return Obx(() {
      if (controller.isLoading.value) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaler:
                    TextScaler.linear(textScaleFactor.clamp(1.0, 1.15))),
            child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Detail Pesanan',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          CarbonIcons.arrow_left,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                body: Shimmer.fromColors(
                  baseColor: const Color(baseColorHex),
                  highlightColor: const Color(highlightColorHex),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: mediaHeight,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
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
                )));
      } else if (controller.pesananData.value == null) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaler:
                    TextScaler.linear(textScaleFactor.clamp(1.0, 1.15))),
            child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Detail Pesanan',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          CarbonIcons.arrow_left,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                body: SizedBox(
                  height: mediaHeight * 0.25,
                  child: Center(
                    child: Lottie.asset('assets/notList.json', repeat: true),
                  ),
                )));
      } else {
        final dataPesanan = controller.pesananData.value!;
        final pesanan = dataPesanan.transaksi!;
        final totalHarga = pesanan.totalHarga ?? 0;
        final totalBayar = pesanan.totalBayar ?? 0;
        final biayaKirim = pesanan.totalKurir ?? 0;
        final kembalian = pesanan.kembalian ?? 0;
        final totalTransaksi = totalHarga + biayaKirim;
        final alamat = pesanan.alamat.toString();
        final keterangan = pesanan.keterangan.toString();

        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaler:
                    TextScaler.linear(textScaleFactor.clamp(1.0, 1.15))),
            child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Detail Pesanan',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          CarbonIcons.arrow_left,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshData(pesanan.kodeTr.toString());
                  },
                  child: SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StatusPesananKurir(orderData: dataPesanan),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Nomor Pesanan",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Waktu Pemesanan",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '#${pesanan.kodeTr}',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  pesanan.tanggal.toString(),
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                child: Container(
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Informasi Pelanggan',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Image.asset(
                                                          'assets/logo_dikantin.png',
                                                          height: 70,
                                                          width: 70,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          pesanan.nama
                                                              .toString(),
                                                          style: GoogleFonts.poppins(
                                                              textStyle: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        ),
                                                        Text(
                                                          pesanan.noTelepon
                                                              .toString(),
                                                          style: GoogleFonts.poppins(
                                                              textStyle: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade800,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                SizedBox(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topStart,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Alamat:",
                                                          style: GoogleFonts.poppins(
                                                              textStyle: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                          .grey[
                                                                      850],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        ),
                                                        Text(
                                                          alamat.toString(),
                                                          style: GoogleFonts.poppins(
                                                              textStyle: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topStart,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Catatan Pengantaran:",
                                                          style: GoogleFonts.poppins(
                                                              textStyle: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                          .grey[
                                                                      850],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        ),
                                                        Text(
                                                          keterangan.toString(),
                                                          style: GoogleFonts.poppins(
                                                              textStyle: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                // height: MediaQuery.of(context).size.height * 0.65,
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pesanan',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: dataPesanan.transaksi!
                                              .detailTransaksi!.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final detailTransaksi = dataPesanan
                                                .transaksi!
                                                .detailTransaksi![index];
                                            final menuData =
                                                detailTransaksi.menu;
                                            final harga = menuData?.harga ?? 0;
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, bottom: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 75,
                                                        width: 75,
                                                        alignment:
                                                            Alignment.topLeft,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(Api
                                                                    .gambar +
                                                                detailTransaksi
                                                                    .menu!.foto
                                                                    .toString()),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              detailTransaksi
                                                                  .menu!.nama
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              "Kantin: ${detailTransaksi.menu!.idKantin.toString()}",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade900,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    harga
                                                                        .toRupiah(),
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      textStyle:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "* ${detailTransaksi.qTY.toString()}",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      textStyle:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Status Pesanan :",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                              Text(
                                                                detailTransaksi
                                                                        .statusKonfirm
                                                                        .toString()
                                                                        .contains(
                                                                            "null")
                                                                    ? ""
                                                                    : detailTransaksi
                                                                        .statusKonfirm
                                                                        .toString()
                                                                        .toUpperCase(),
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                    color: Colors.grey[300],
                                                    thickness: 1,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Informasi Pembayaran',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Metode Pembayaran  :',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                pesanan.modelPembayaran
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Biaya Kirim :',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                pesanan.totalKurir == null
                                                    ? 'Rp 0'
                                                    : pesanan.totalKurir!
                                                        .toRupiah(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total Pesanan :',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                totalHarga.toRupiah(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Nominal Uang Pembeli :',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                totalBayar.toRupiah(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Diskon :',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Rp 0',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Kembalian :',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                kembalian.toRupiah(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total bayar :',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                totalTransaksi.toRupiah(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: dataPesanan.status
                                          .toString()
                                          .contains('proses')
                                      ? buttonAntar(
                                          context, textScaleFactor, pesanan)
                                      : dataPesanan.status
                                              .toString()
                                              .contains('Selesai')
                                          ? textSelesai(
                                              context, textScaleFactor, pesanan)
                                          : dataPesanan.status
                                                  .toString()
                                                  .contains('Menunggu 2')
                                              ? buttonTungguKonfirmasi(context,
                                                  textScaleFactor, pesanan)
                                              : buttonScanQRCode(context,
                                                  controller, dataPesanan),
                                ),
                              ),
                            ],
                          ))),
                )));
      }
    });
  }

  ElevatedButton buttonScanQRCode(BuildContext context,
      DetailPesananKurirController controller, DataPesananKirim dataPesanan) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2579FD),
        fixedSize: Size(
          MediaQuery.of(context).size.width * 1,
          50,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        controller.scanQrCode(dataPesanan.transaksi!.kodeTr.toString());
      },
      child: Text(
        "Foto Bukti",
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Text textSelesai(
      BuildContext context, double textScaleFactor, Transaksi pesanan) {
    return Text(
      '',
      style: GoogleFonts.poppins(
        textStyle: const TextStyle(
          fontSize: 14,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ElevatedButton buttonTungguKonfirmasi(
      BuildContext context, double textScaleFactor, Transaksi pesanan) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD0E0FE),
        fixedSize: Size(
          MediaQuery.of(context).size.width * 1,
          50,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () async {
        Get.snackbar("Menunggu !!..", "Konfirmasi Admin");
      },
      child: Text(
        "Foto Bukti",
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold)),
      ),
    );
  }

  ElevatedButton buttonAntar(
      BuildContext context, double textScaleFactor, Transaksi pesanan) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2579FD),
        fixedSize: Size(
          MediaQuery.of(context).size.width * 1,
          50,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    "assets/Animation_logout.json", // Ganti dengan nama file Lottie Anda
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Apakah anda yakin?",
                      style: TextStyle(
                        color: const Color(0xff3CA2D9),
                        fontWeight: FontWeight.w700,
                        fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await controller
                            .acceptedPesanan(pesanan.kodeTr.toString());
                        Get.back();
                        await Future.delayed(
                            const Duration(milliseconds: 2000));

                        double latitude = double.parse(pesanan.latitude
                            .toString()); // Replace with the actual latitude
                        double longitude = double.parse(pesanan.longitude
                            .toString()); // Replace with the actual longitude

                        final intent = AndroidIntent(
                          action: "action_view",
                          data: Uri.encodeFull(
                              "google.navigation:q=$latitude,$longitude&avoid=tf"),
                          package: "com.google.android.apps.maps",
                        );

                        intent.launch();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Ya',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Tidak',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
            textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
