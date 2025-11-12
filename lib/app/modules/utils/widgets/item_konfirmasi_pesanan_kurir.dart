import 'dart:convert';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:dikantin/app/data/models/pesanan_kirim_model.dart';
import 'package:dikantin/app/data/providers/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../formatDate.dart';
import '../../chat/detail_chat_page_kurir.dart';

class ItemKonfirmasiPesananKurir extends StatelessWidget {
  final DataPesananKirim orderData;
  final Function onTap;
  final Function onButtonPressed;

  const ItemKonfirmasiPesananKurir({
    required this.orderData,
    required this.onTap,
    required this.onButtonPressed,
    super.key,
  });

  Future<int?> fetchMessagesKurir(String idTransaksi, String idKurir) async {
    final url = Uri.parse(Api.getIdKurir);

    // Membuat body request
    final body = {
      "id_transaksi": idTransaksi,
      "id_kurir": idKurir,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json", // Set header content type
        },
        body: jsonEncode(body), // Mengubah body ke format JSON
      );

      // Memeriksa status code
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Mengembalikan id_chat jika respons sukses
        return responseData['id'];
      } else {
        // Menangani jika status code tidak 200
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      // Menangani kesalahan lainnya
      print('Error occurred: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final kodeTransaksi = "#${orderData.transaksi!.kodeTr.toString()}";
    final waktuTransaksi =
        formatDateTime(orderData.transaksi!.tanggal.toString());
    final statusTransaksi = orderData.status.toString().contains('null')
        ? ''
        : orderData.status.toString().contains('Menunggu 2')
            ? "Menunggu"
            : orderData.status.toString();
    final alamat = orderData.transaksi?.alamat ?? "";
    final idKurir = orderData.transaksi?.idKurir ?? "";
    final namaPelanggan = orderData.transaksi?.nama ?? "";
    final noTelpPelanggan = orderData.transaksi?.noTelepon ?? "";
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
                                    color: statusTransaksi
                                            .toString()
                                            .contains('Selesai')
                                        ? Colors.green.shade800
                                        : Colors.orange.shade800,
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
                            "Nama Pelanggan:",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[850],
                                    fontWeight: FontWeight.w400)),
                          ),
                          Text(
                            namaPelanggan.toString(),
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
                  SizedBox(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: AlignmentDirectional.topStart,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nomor Telepon:",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[850],
                                    fontWeight: FontWeight.w400)),
                          ),
                          Text(
                            noTelpPelanggan.toString(),
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
                      orderData.status.toString().contains('Selesai')
                          ? Text(
                              '',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : orderData.status.toString().contains('Menunggu 2')
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD0E0FE),
                                    shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    Get.snackbar(
                                        "Menunggu !!..", "Konfirmasi Admin");
                                  },
                                  child: Text(
                                    "Foto Bukti",
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2579FD),
                                    shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () => onButtonPressed(),
                                  child: Text(
                                    "Foto Bukti",
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                      ElevatedButton(
                        onPressed: () async {
                          final idchat = await fetchMessagesKurir(
                              orderData.transaksi!.kodeTr.toString(), idKurir);

                          if (idchat != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailChatPageKurir(
                                    conversationId: idchat, kantinnn: namaPelanggan, idkurirr: idKurir),
                              ),
                            );
                          } else {
                            print("Gagal mendapatkan id_chat.");
                          }
                        },
                        child: Text("Chat"),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
