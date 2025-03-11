// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/api.dart';
import '../../../providers/db_provider.dart';
import '../../../models/building.dart';
import '../../../models/canteen.dart';
import '../../../models/category.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var currentIndex = 0.obs;

  var selectedCanteen = "Semua".obs;
  var selectedLocation = 'Pilih Lokasi'.obs;

  var buildings = <Building>[].obs;
  var categories = <Category>[].obs;
  var canteens = <Canteen>[].obs;

  List<String> bannerList = [
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
  ];

  @override
  void onInit() {
    super.onInit();
    getLocation();
    getCategories();
    getCanteen();
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

  Future<void> getCategories() async {
    isLoading.value = true;

    String url = "${AppUrl.baseURL}/category";
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
        List<dynamic> categoryData = data["data"];

        categories.value =
            categoryData.map((item) => Category.fromJson(item)).toList();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCanteen() async {
    isLoading.value = true;

    String url = "${AppUrl.baseURL}/canteen";
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
        
        if (data["data"] is List) {
          List<Canteen> sortedCanteens = (data["data"] as List)
              .map((item) => Canteen.fromJson(item))
              .toList();

          sortedCanteens.sort((a, b) {
            int numA = extractNumber(a.name);
            int numB = extractNumber(b.name);
            return numA.compareTo(numB);
          });

          canteens.value = [
            Canteen(
              id: "",
              name: "Semua",
              phoneNumber: "",
              balance: 0,
              status: "",
            ),
            ...sortedCanteens,
          ];

          if (canteens.isNotEmpty) {
            selectedCanteen.value = "Semua";
          }
        }
      } else {
        selectedCanteen.value = "Semua";
        canteens.value = [];
      }
    } catch (e) {
      print(e);
      canteens.value = [];
    } finally {
      isLoading.value = false;
    }
  }

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

  int extractNumber(String text) {
    RegExp regExp = RegExp(r'\d+');
    Match? match = regExp.firstMatch(text);
    return match != null ? int.parse(match.group(0)!) : 0;
  }

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  void selectCanteen(String canteen) {
    selectedCanteen.value = canteen;
  }
}
