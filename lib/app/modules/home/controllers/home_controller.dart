// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../data/api.dart';
import '../../../data/db_provider.dart';
import '../../../models/building.dart';
import '../../../models/canteen.dart';
import '../../../models/category.dart';
import '../../../models/menu.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var currentIndex = 0.obs;

  var selectedLocation = 'Pilih Lokasi'.obs;
  var selectedCategoryId = ''.obs;
  var selectedCanteenId = 'all'.obs;

  var buildings = <Building>[].obs;
  var categories = <Category>[].obs;
  var canteens = <Canteen>[].obs;
  var menus = <Menu>[].obs;

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

    String url = AppUrl.locations;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        List<dynamic> buildingData = res["data"];

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
        final res = json.decode(req.body);
        selectedLocation.value = "Pilih Lokasi";

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.0,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCategories() async {
    isLoading.value = true;

    String url = AppUrl.categories;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        List<dynamic> categoryData = res["data"];

        categories.value =
            categoryData.map((item) => Category.fromJson(item)).toList();
      } else {
        final res = json.decode(req.body);

        print(res);

        selectedLocation.value = "Pilih Lokasi";

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.0,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCanteen() async {
    isLoading.value = true;

    String url = AppUrl.canteens;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        if (res["data"] is List) {
          List<Canteen> sortedCanteens = (res["data"] as List)
              .map((item) => Canteen.fromJson(item))
              .toList();

          sortedCanteens.sort((a, b) {
            int numA = extractNumber(a.name);
            int numB = extractNumber(b.name);
            return numA.compareTo(numB);
          });

          canteens.value = [
            Canteen(
              id: "all",
              name: "Semua",
              phoneNumber: "",
              balance: 0,
              status: "",
            ),
            ...sortedCanteens,
          ];

          getMenuByCanteen(id: "all", context: Get.context!);
        }
      } else {
        final res = json.decode(req.body);

        print(res);

        selectedCanteenId.value = "all";

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.0,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMenuByCanteen({
    required String id,
    BuildContext? context,
  }) async {
    isLoading.value = true;

    String url;

    if (id == "all") {
      url = AppUrl.menus;
    } else {
      url = "${AppUrl.menuByCanteen}/$id";
    }

    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        List<dynamic> menuData = res["data"];

        menus.value = menuData.map((item) => Menu.fromJson(item)).toList();
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.0,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMenuByCategory({
    required String id,
    BuildContext? context,
  }) async {
    isLoading.value = true;

    String url;

    if (id == "all") {
      url = AppUrl.categories;
    } else {
      url = "${AppUrl.menuByCategory}/$id";
    }

    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        List<dynamic> menuData = res["data"];

        menus.value = menuData.map((item) => Menu.fromJson(item)).toList();
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.0,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  int extractNumber(String text) {
    RegExp regExp = RegExp(r'\d+');
    Match? match = regExp.firstMatch(text);
    return match != null ? int.parse(match.group(0)!) : 0;
  }

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String formatRupiah(int price) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    return formatCurrency.format(price);
  }
}
