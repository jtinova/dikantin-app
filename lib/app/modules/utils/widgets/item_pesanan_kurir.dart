import 'package:carbon_icons/carbon_icons.dart';
import 'package:dikantin/app/data/models/pesanan_kirim_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../formatDate.dart';

class ItemPesananKurir extends StatelessWidget {
  final DataPesananKirim orderData;
  final Function onTap;
  final Function onButtonPressed;

  const ItemPesananKurir({
    required this.orderData,
    required this.onTap,
    required this.onButtonPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final kodeTransaksi = "#${orderData.transaksi!.kodeTr.toString()}";
    final waktuTransaksi =
        formatDateTime(orderData.transaksi!.tanggal.toString());
    final statusTransaksi = orderData.status.toString().contains('null')
        ? ''
        : orderData.status.toString().contains('proses') 
        ? 'Belum diantar'
        : orderData.status.toString();
    final alamat = orderData.transaksi?.alamat ?? "";
    final jumlahMenu = orderData.transaksi!.detailTransaksi!.length.toString();
    final totalHarga = orderData.transaksi?.totalHarga ?? 0;
    final biayaKirim = orderData.transaksi?.totalKurir ?? 0;
    final totalTransaksi = totalHarga + biayaKirim;
    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Container(
            margin:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 4),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kodeTransaksi.toString(),
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Text(
                            waktuTransaksi.toString(),
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
                            statusTransaksi.toString(),
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
                  
                  SizedBox(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: AlignmentDirectional.topStart,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Alamat:",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[850],
                                    fontWeight: FontWeight.w400)),
                          ),
                          Text(
                            alamat.toString(),
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
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
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.greenAccent[100],
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 3.5),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width,
                      alignment: AlignmentDirectional.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                CarbonIcons.delivery,
                              ),
                              const SizedBox(
                                width: 5,
                                ),
                              Text(
                                "Biaya Kirim:",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[850],
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          Text(
                            biayaKirim.toRupiah(),
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            totalTransaksi.toRupiah(),
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Text(
                            "${jumlahMenu.toString()} menu",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => onButtonPressed(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text(
                            'Antar',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
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
  }
}
