import '../../../data/models/pesananProses.dart';
import '../controllers/detail_belumbayar_controller.dart';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../data/providers/services.dart';
import '../../pesanan/controllers/pesanan_controller.dart';

class DetailBelumbayarView extends GetView<DetailBelumbayarController> {
  const DetailBelumbayarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final orderId = Get.arguments as String?;
    final orderData =
        Get.find<PesananController>().findOrderById(orderId ?? '');

    if (orderData == null) {
      return const Scaffold(
        body: Center(
          child: Text('Pesanan tidak ditemukan'),
        ),
      );
    }
    final DetailBelumbayarController controller =
        Get.put(DetailBelumbayarController());
    final transaksi = orderData.transaksi;
    final totalHarga = transaksi!.totalHarga ?? 0;
    final totalBayar = transaksi.totalBayar ?? 0;
    final kembalian = transaksi.kembalian ?? 0;
    final detailTransaksiList = transaksi.detailTransaksi ?? [];
    final query = MediaQuery.of(context);
    return MediaQuery(
      data: query.copyWith(
          textScaler:
              TextScaler.linear(query.textScaleFactor.clamp(1.0, 1.15))),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Detail Pesanan Saya',
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Nomor Pesanan",
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Waktu Pemesanan",
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '#${transaksi.kodeTr}',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    transaksi.tanggal.toString(),
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              itemCount: detailTransaksiList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final detailTransaksi =
                                    detailTransaksiList[index];
                                final menuData = detailTransaksi.menu;
                                final harga = menuData?.harga ?? 0;
                                /* if (detailTransaksi) {
                                  
                                } else {
                                  
                                } */
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 75,
                                            width: 75,
                                            alignment: Alignment.topLeft,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(Api.gambar +
                                                    detailTransaksi.menu!.foto
                                                        .toString()),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  detailTransaksi.menu!.nama
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  "Kantin: ${detailTransaksi.menu!.idKantin.toString()}",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Colors.grey.shade900,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        harga.toRupiah(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "* ${detailTransaksi.qTY.toString()}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
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
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Status Pesanan :",
                                                    style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    detailTransaksi
                                                            .statusKonfirm
                                                            .toString()
                                                            .contains("null")
                                                        ? ""
                                                        : detailTransaksi
                                                            .statusKonfirm
                                                            .toString()
                                                            .toUpperCase(),
                                                    style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (detailTransaksi.statusKonfirm ==
                                              "menunggu")
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Konfirmasi",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      content: const Text(
                                                        "Apakah Anda yakin ingin membatalkan produk ini?",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            "Tidak",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            // Lakukan aksi pembatalan produk di sini
                                                            await EasyLoading
                                                                .show(
                                                              status:
                                                                  'loading...',
                                                              maskType:
                                                                  EasyLoadingMaskType
                                                                      .black,
                                                            );
                                                            controller.cancelProduct(
                                                                transaksi.kodeTr
                                                                    .toString(),
                                                                detailTransaksi
                                                                    .kodeMenu
                                                                    .toString());
                                                            EasyLoading
                                                                .dismiss();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            "Ya",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              child: Text(
                                                'Batalkan',
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
                                      Divider(
                                        color: Colors.grey[300],
                                        thickness: 1,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              // color: Colors.amber,
                              padding: const EdgeInsets.all(2),
                              height: MediaQuery.of(context).size.height * 0.09,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  QrImageView(
                                    data: transaksi.kodeTr.toString(),
                                    version: QrVersions.auto,
                                    size: 75,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Note :',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Tunjukkan kode barcode di sebelah \nkepada kurir jika makanan sampai ',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 10,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  transaksi.modelPembayaran.toString(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ongkir :',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  transaksi.totalKurir == null
                                      ? 'Rp 0'
                                      : transaksi.totalKurir!.toRupiah(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total :',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  totalHarga.toRupiah(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
