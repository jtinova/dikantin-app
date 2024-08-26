import 'package:dikantin/app/data/models/pesanan_kirim_model.dart';
import 'package:dikantin/app/modules/pesanan/controllers/pesanan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusPesananKurir extends StatelessWidget {
  final DataPesananKirim orderData;
  const StatusPesananKurir({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final statusTransaksi = orderData.status;
    final transaksi = orderData.transaksi;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: statusTransaksi.toString().contains('proses')
                            ? const Icon(
                                Icons.delivery_dining,
                                size: 20,
                                color: Colors.white,
                              )
                            : statusTransaksi.toString().contains('Selesai')
                                ? const Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : statusTransaksi
                                        .toString()
                                        .contains('Menunggu 2')
                                    ? const Icon(
                                        Icons.domain_verification,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.delivery_dining,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Diantar",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            statusTransaksi.toString().contains('proses')
                                ? "Konfirmasi pengantaran"
                                : statusTransaksi.toString().contains('Selesai')
                                    ? "Selesai"
                                    : statusTransaksi
                                            .toString()
                                            .contains('Menunggu 2')
                                        ? "Proses konfirmasi admin"
                                        : "Pengantaran",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: statusTransaksi
                                        .toString()
                                        .contains('Selesai')
                                    ? Colors.green.shade800
                                    : Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
