import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MenuKantinController extends GetxController {
var daftarMenu = <Map<String, dynamic>>[
    {
      "id": "1", 
      "nama": "Nasi Lalapan Ayam Betutu", 
      "harga": "Rp 10.000",
      "status": "Tersedia", 
      "image": "assets/images/pesanan.png",
    },
    {
      "id": "2", 
      "nama": "Nasi Soto Babat", 
      "harga": "Rp 10.000",
      "status": "Habis", 
      "image": "assets/images/pesanan.png",
    },
    {
      "id": "3", 
      "nama": "Mie Instan Goreng", 
      "harga": "Rp 10.000",
      "status": "Tersedia", 
      "image": "assets/images/pesanan.png",
    },
  ].obs;

  void updateMenu(Map<String, dynamic> updatedMenuItem) {
    int index = daftarMenu.indexWhere((item) => item["id"] == updatedMenuItem["id"]);
    if (index != -1) {
      daftarMenu[index] = updatedMenuItem; 
    }
  }
}