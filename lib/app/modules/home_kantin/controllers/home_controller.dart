import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin{
 var selectedItem = "Tutup".obs;
//  var selectedCategory = "Makanan".obs;
 late TabController tabController;

  var pesananMasuk = <Map<String, dynamic>>[
    {
      "id": "#TRDKN233249", 
      "datetime": "03 Mar 2024 12:36", 
      "status": "Pesanan Baru", 
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
      "status": "Pesanan Baru", 
      "pesanan": [
        {"nama": "Nasi Geprek", "jumlah": 1, "harga": 14000},
        {"nama": "Es Teh", "jumlah": 1, "harga": 3000}
      ],
      "image": "assets/images/pesanan.png",
      "catatan": "-"
    },
    {
      "id": "#TRDKN233249", 
      "datetime": "03 Mar 2024 12:36", 
      "status": "Pesanan Baru", 
      "pesanan": [
        {"nama": "Nasi Kuning", "jumlah": 1, "harga": 10000},
      ],
      "image": "assets/images/pesanan.png",
      "catatan": "-"
    },
  ].obs;
  
  var pesananDimasak = <Map<String, dynamic>>[
    {
      "id": "#TRDKN233249", 
      "datetime": "03 Mar 2024 12:36", 
      "status": "Dimasak", 
      "pesanan": [
        {"nama": "Nasi Kuning", "jumlah": 1, "harga": 12000},
        {"nama": "Es Teh", "jumlah": 1, "harga": 3000}
      ],
      "image": "assets/images/pesanan.png",
      "catatan": "-"
    },
  ].obs;

 @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // void changeCategory(String category) {
  //   selectedCategory.value = category;
  // }
}