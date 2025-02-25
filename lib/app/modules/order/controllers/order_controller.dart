import 'package:get/get.dart';

class OrderController extends GetxController {
  var selectedIndex = 0.obs;
  var selectedStatus = "Status".obs;
  var selectedDate = "Semua Tanggal".obs;

  List<String> statusOptions = [
    "Status",
    "Diproses",
    "Dikirim",
    "Selesai",
    "Dibatalkan",
  ];

  List<String> dateOptions = [
    "Semua Tanggal",
    "Hari Ini",
    "Minggu Ini",
    "Bulan Ini"
  ];

  List<Map<String, String>> orderItems = [
    {
      "id_order": "#TRDKN233249",
      "datetime": "23 Maret 2024 | 12.00",
      "image": "assets/images/image_carousel.png",
      "items": "Nasi Goreng, Soto Ayam",
      "price": "Rp12.000",
      "qty": "2",
      "status": "Diproses"
    },
    {
      "id_order": "#TRDKN233249",
      "datetime": "23 Maret 2024 | 12.00",
      "image": "assets/images/image_carousel.png",
      "items": "Nasi Goreng, Soto Ayam",
      "price": "Rp12.000",
      "qty": "2",
      "status": "Dikirim"
    },
    {
      "id_order": "#TRDKN233249",
      "datetime": "23 Maret 2024 | 12.00",
      "image": "assets/images/image_carousel.png",
      "items": "Nasi Goreng, Soto Ayam",
      "price": "Rp12.000",
      "qty": "2",
      "status": "Selesai"
    },
    {
      "id_order": "#TRDKN233249",
      "datetime": "23 Maret 2024 | 12.00",
      "image": "assets/images/image_carousel.png",
      "items": "Nasi Goreng, Soto Ayam",
      "price": "Rp12.000",
      "qty": "2",
      "status": "Dibatalkan"
    },
    {
      "id_order": "#TRDKN233249",
      "datetime": "23 Maret 2024 | 12.00",
      "image": "assets/images/image_carousel.png",
      "items": "Nasi Goreng, Soto Ayam",
      "price": "Rp12.000",
      "qty": "2",
      "status": "Diproses"
    },
    {
      "id_order": "#TRDKN233249",
      "datetime": "23 Maret 2024 | 12.00",
      "image": "assets/images/image_carousel.png",
      "items": "Nasi Goreng, Soto Ayam",
      "price": "Rp12.000",
      "qty": "2",
      "status": "Dikirim"
    },
    {
      "id_order": "#TRDKN233249",
      "datetime": "23 Maret 2024 | 12.00",
      "image": "assets/images/image_carousel.png",
      "items": "Nasi Goreng, Soto Ayam",
      "price": "Rp12.000",
      "qty": "2",
      "status": "Selesai"
    },
    {
      "id_order": "#TRDKN233249",
      "datetime": "23 Maret 2024 | 12.00",
      "image": "assets/images/image_carousel.png",
      "items": "Nasi Goreng, Soto Ayam",
      "price": "Rp12.000",
      "qty": "2",
      "status": "Dibatalkan"
    },
  ];
}
