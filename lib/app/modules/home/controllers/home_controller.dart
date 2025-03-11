// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:dikantin_app_rebuild/app/providers/db_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/building.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var currentIndex = 0.obs;
  var selectedCanteen = "Semua".obs;

  var selectedLocation = 'Pilih Lokasi'.obs;
  var buildings = <Building>[].obs;

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  Future<void> getLocation() async {
    isLoading.value = true;

    String url = "${AppUrl.baseURL}/building";
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> buildingData = data["data"];

        buildings.value = [
          Building(
            id: "",
            name: "Pilih Lokasi",
            latitude: 0,
            longitude: 0,
          ),
          ...buildingData.map((item) => Building.fromJson(item))
        ];

        if (buildings.isNotEmpty) {
          selectedLocation.value = "Pilih Lokasi";
        }
      } else {
        selectedLocation.value = "Pilih Lokasi";
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  List<String> bannerList = [
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
  ];

  List<Map<String, String>> categories = [
    {"name": "Ayam", "image": "assets/images/image_carousel.png"},
    {"name": "Lalapan", "image": "assets/images/image_carousel.png"},
    {"name": "Mie", "image": "assets/images/image_carousel.png"},
    {"name": "Jus", "image": "assets/images/image_carousel.png"},
    {"name": "Camilan", "image": "assets/images/image_carousel.png"},
    {"name": "Gorengan", "image": "assets/images/image_carousel.png"},
  ];

  List<Map<String, String>> canteens = [
    {"name": "Semua"},
    {"name": "Kantin 1"},
    {"name": "Kantin 2"},
    {"name": "Kantin 3"},
    {"name": "Kantin 4"},
    {"name": "Kantin 5"},
    {"name": "Kantin 6"},
  ];

  List<Map<String, String>> foodItems = [
    {
      "canteen": "Kantin 1",
      "name": "Nasi Uduk Spesial",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Buka"
    },
    {
      "canteen": "Kantin 2",
      "name": "Nasi Ayam Bakar",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Buka"
    },
    {
      "canteen": "Kantin 3",
      "name": "Nasi Pecel",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Tutup"
    },
    {
      "canteen": "Kantin 4",
      "name": "Nasi Rawon",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Buka"
    },
    {
      "canteen": "Kantin 5",
      "name": "Nasi Soto Spesial",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Buka"
    },
    {
      "canteen": "Kantin 6",
      "name": "Tahu Tek",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Tutup"
    },
  ];

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  void selectCanteen(String canteen) {
    selectedCanteen.value = canteen;
  }
}
