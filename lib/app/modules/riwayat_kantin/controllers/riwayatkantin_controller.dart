import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RiwayatKantinController extends GetxController {
  var selectedItem = "Semua".obs;
  var selectedDate = "Pilih Tanggal".obs;
  var riwayatPesanan = <Map<String, dynamic>>[
    {
      "id": "#TRDKN233249", 
      "datetime": "03 Mar 2024 12:36", 
      "status": "Selesai", 
      "pesanan": [
        {"nama": "Nasi Kuning", "jumlah": 2, "harga": 12000},
        {"nama": "Es Jeruk", "jumlah": 1, "harga": 4000}
      ],
      "image": "assets/images/pesanan.png",
      "catatan": "Tidak pake sambal dan timun"
    },
    {
      "id": "#TRDKN233249", 
      "datetime": "03 Mar 2024 12:36", 
      "status": "Dibatalkan", 
      "pesanan": [
        {"nama": "Nasi Geprek", "jumlah": 1, "harga": 14000},
        {"nama": "Es Teh", "jumlah": 1, "harga": 3000}
      ],
      "image": "assets/images/pesanan.png",
      "catatan": "-"
    },
  ].obs;

  int get totalPendapatan => riwayatPesanan
    .expand((order) => order["pesanan"] as List<dynamic>) 
    .map((menu) => ((menu["jumlah"] ?? 0) * (menu["harga"] ?? 0)).toInt()) 
    .reduce((sum, price) => sum + price);

}