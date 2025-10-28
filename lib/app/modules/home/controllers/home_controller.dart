// lib/app/modules/home/controllers/home_controller.dart

// ignore_for_file: avoid_print, collection_methods_unrelated_type, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../service/api_client_service.dart';
import '../../../service/api_service.dart';
import '../../../models/building.dart';
import '../../../models/canteen.dart';
import '../../../models/cart.dart';
import '../../../models/category.dart';
import '../../../models/menu.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var isDataLoaded = false.obs;
  var isMenuLoading = false.obs;
  var currentIndex = 0.obs;

  var selectedLocation = 'Pilih Lokasi'.obs;
  var selectedCategoryId = ''.obs;
  var selectedCanteenId = 'all'.obs;

  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var isLoadingMore = false.obs;
  var allMenuLoaded = false.obs;

  var buildings = <Building>[].obs;
  var categories = <Category>[].obs;
  var canteens = <Canteen>[].obs;
  var cartItems = <CartItem>[].obs;

  var menus = <Menu>[].obs;
  var allMenus = <Menu>[].obs;
  var recommendedMenus = <Menu>[].obs;

  bool _isThrottled = false;
  Timer? _throttleTimer, _debounce;

  final RxList<Menu> favoriteMenus = <Menu>[].obs;
  final RxSet<String> favoriteMenuId = <String>{}.obs;

  int get cartCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  List<String> bannerList = [
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
  ];

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    if (isDataLoaded.value) return;

    isLoading.value = true;
    EasyLoading.show(status: 'Loading...');

    try {
      await Future.wait([
        getLocation(),
        getFavoriteMenuForHome(),
        getCategories(),
        getRecommendedMenus(),
        getCanteen(),
        fetchAllMenus(isRefresh: true),
      ]);
      isDataLoaded.value = true;
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> refreshAll() async {
    isLoading.value = true;
    EasyLoading.show(status: 'Loading...');

    try {
      selectedCategoryId.value = '';
      selectedCanteenId.value = 'all';

      await Future.wait([
        getLocation(),
        getFavoriteMenuForHome(),
        getCategories(),
        getRecommendedMenus(),
        getCanteen(),
        fetchAllMenus(isRefresh: true),
      ]);
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> getRecommendedMenus() async {
    isMenuLoading.value = true;
    String url = AppUrl.recommendation;

    try {
      final req = await ApiClient.get(url);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        
        List<dynamic> menuData = res["data"];
        recommendedMenus.value =
            menuData.map((item) => Menu.fromJson(item)).toList();
      } else {
        recommendedMenus.clear();

        final res = json.decode(req.body);
        print(res);
      }
    } catch (e) {
      recommendedMenus.clear();

      print(e);
    } finally {
      isMenuLoading.value = false;
    }
  }

  Future<void> fetchAllMenus({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      lastPage.value = 1;
      menus.clear();
      allMenus.clear();
      isLoadingMore.value = false;
      allMenuLoaded.value = false;
    }

    if (isLoadingMore.value || allMenuLoaded.value) return;

    if (!isRefresh) {
      isLoadingMore.value = true;
    } else {
      isMenuLoading.value = true;
    }

    String url = "${AppUrl.menus}?page=${currentPage.value}";

    try {
      final req = await ApiClient.get(url);

      if (req.statusCode == 429) {
        return;
      }

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        List<dynamic> menuData = res["data"]["menus"];
        List<Menu> fetchedMenus = menuData.map((item) {
          final menu = Menu.fromJson(item);
          menu.isFavorite = favoriteMenuId.contains(menu.id);
          return menu;
        }).toList();

        if (isRefresh) {
          menus.assignAll(fetchedMenus);
        } else {
          menus.addAll(fetchedMenus);
        }
        allMenus.addAll(fetchedMenus);

        lastPage.value = res["data"]["pagination"]["last_page"];
        if (currentPage.value >= lastPage.value) {
          allMenuLoaded.value = true;
        }
        currentPage.value++;
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Mohon Coba Lagi",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
      isMenuLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> getSearchMenu({required String query}) async {
    if (query.isEmpty) {
      refreshAll();
      return;
    }

    isMenuLoading.value = true;
    String url = "${AppUrl.searchMenu}?query=$query";

    try {
      final req = await ApiClient.get(url);

      if (req.statusCode == 429) {
        return;
      }

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        List<dynamic> menuData = res["data"];
        menus.value = menuData.map((item) => Menu.fromJson(item)).toList();
      } else {
        final res = json.decode(req.body);
        print(res);
      }
    } catch (e) {
      print(e);
    } finally {
      isMenuLoading.value = false;
    }
  }

  Future<void> getMenuByCategory(String categoryId, {bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      lastPage.value = 1;
      menus.clear();
      isLoadingMore.value = false;
      allMenuLoaded.value = false;
    }

    if (isLoadingMore.value || allMenuLoaded.value) return;

    if (!isRefresh) {
      isLoadingMore.value = true;
    } else {
      isMenuLoading.value = true;
    }

    String url = "${AppUrl.menuByCategory}/$categoryId?page=${currentPage.value}";

    try {
      final req = await ApiClient.get(url);

      if (req.statusCode == 429) {
        return;
      }

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        
        List<dynamic> menuData = res["data"]["menus"];
        List<Menu> fetchedMenus = menuData.map((item) {
          final menu = Menu.fromJson(item);
          menu.isFavorite = favoriteMenuId.contains(menu.id);
          return menu;
        }).toList();

        if (isRefresh) {
          menus.assignAll(fetchedMenus);
        } else {
          menus.addAll(fetchedMenus);
        }

        lastPage.value = res["data"]["pagination"]["last_page"];
        if (currentPage.value >= lastPage.value) {
          allMenuLoaded.value = true;
        }
        currentPage.value++;
      } else {
        final res = json.decode(req.body);
        print(res);
      }
    } catch (e) {
      print(e);
    } finally {
      isMenuLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> getMenuByCanteen(String canteenId, {bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      lastPage.value = 1;
      menus.clear();
      isLoadingMore.value = false;
      allMenuLoaded.value = false;
    }

    if (isLoadingMore.value || allMenuLoaded.value) return;

    if (!isRefresh) {
      isLoadingMore.value = true;
    } else {
      isMenuLoading.value = true;
    }

    String url = "${AppUrl.menuByCanteen}/$canteenId?page=${currentPage.value}";

    try {
      final req = await ApiClient.get(url);

      if (req.statusCode == 429) {
        return;
      }

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        List<dynamic> menuData = res["data"]["menus"];

        List<Menu> fetchedMenus = menuData.map((item) {
          final menu = Menu.fromJson(item);
          menu.isFavorite = favoriteMenuId.contains(menu.id);
          return menu;
        }).toList();

        if (isRefresh) {
          menus.assignAll(fetchedMenus);
        } else {
          menus.addAll(fetchedMenus);
        }

        lastPage.value = res["data"]["pagination"]["last_page"];
        if (currentPage.value >= lastPage.value) {
          allMenuLoaded.value = true;
        }
        currentPage.value++;
      } else {
        final res = json.decode(req.body);
        print(res);
      }
    } catch (e) {
      print(e);
    } finally {
      isMenuLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> getLocation() async {
    String url = AppUrl.locations;

    try {
      final req = await ApiClient.get(url);

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
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getFavoriteMenuForHome() async {
    String url = AppUrl.menuFavorit;

    try {
      final req = await ApiClient.get(url);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        List<dynamic> favoriteList = res["data"];

        final ids = favoriteList.map((item) => item['id'] as String).toSet();
        favoriteMenuId.assignAll(ids);
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getFavoriteMenuForProfile() async {
    isMenuLoading.value = true;
    try {
      final req = await ApiClient.get(AppUrl.menuFavorit);

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        List<dynamic> menuData = res["data"];

        favoriteMenus.value =
            menuData.map((item) => Menu.fromJson(item)).toList();
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isMenuLoading.value = false;
    }
  }

  Future<void> getCategories() async {
    String url = AppUrl.categories;

    try {
      final req = await ApiClient.get(url);

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
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCanteen() async {
    String url = AppUrl.canteens;

    try {
      final req = await ApiClient.get(url);

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
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> toggleFavoriteStatus(Menu menu) async {
    final bool isCurrentlyFavorite = favoriteMenuId.contains(menu.id);
    final String menuId = menu.id;

    if (isCurrentlyFavorite) {
      favoriteMenuId.remove(menuId);
      favoriteMenus.removeWhere((m) => m.id == menuId);
    } else {
      favoriteMenuId.add(menuId);
    }

    int index = allMenus.indexWhere((m) => m.id == menuId);
    if (index != -1) {
      allMenus[index].isFavorite = !isCurrentlyFavorite;
    }

    menus.refresh();

    try {
      if (isCurrentlyFavorite) {
        String url = "${AppUrl.menuFavoritRemove}${menu.id}";

        final req = await ApiClient.delete(url);

        if (req.statusCode == 200) {
          final res = json.decode(req.body);

          print(res);
        } else {
          final res = json.decode(req.body);

          print(res);

          favoriteMenuId.add(menuId);
          favoriteMenus.add(menu);
          if (index != -1) {
            menus[index].isFavorite = true;
          }

          Get.snackbar(
            "Informasi ",
            "Gagal Menghapus Menu Favorit",
            animationDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1650),
            backgroundColor: const Color.fromARGB(255, 238, 238, 238),
            borderWidth: 5.w,
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 20.h,
            ),
            icon: const Icon(
              CupertinoIcons.info_circle,
            ),
          );
        }
      } else {
        String url = AppUrl.menuFavoritAdd;

        final req = await ApiClient.post(
          url,
          body: {
            'menu_id': menu.id,
          },
        );

        if (req.statusCode == 201) {
          final res = json.decode(req.body);

          print(res);
        } else {
          final res = json.decode(req.body);

          print(res);

          favoriteMenuId.remove(menuId);
          favoriteMenus.removeWhere((m) => m.id == menuId);
          if (index != -1) {
            menus[index].isFavorite = false;
          }

          Get.snackbar(
            "Informasi ",
            "Gagal Menambahkan Menu Favorit",
            animationDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1650),
            backgroundColor: const Color.fromARGB(255, 238, 238, 238),
            borderWidth: 5.w,
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 20.h,
            ),
            icon: const Icon(
              CupertinoIcons.info_circle,
            ),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      if (isCurrentlyFavorite) {
        favoriteMenuId.add(menuId);
        favoriteMenus.add(menu);
        if (index != -1) {
          menus[index].isFavorite = true;
        }
      } else {
        favoriteMenuId.remove(menuId);
        favoriteMenus.removeWhere((m) => m.id == menuId);
        if (index != -1) {
          menus[index].isFavorite = false;
        }
      }

      print(e);
    } finally {
      favoriteMenus.refresh();
      menus.refresh();
    }
  }

  Future<void> trackInteraction(String interactionType, {String? menuId}) async {
    String url = AppUrl.trackingActivity;
    final body = {
      'interaction_type': interactionType,
      'menu_id': menuId,
    };

    try {
      final req = await ApiClient.post(url, body: body);

      if (req.statusCode == 200) {
        print('Interaction tracked successfully: $interactionType');
      } else {
        final res = json.decode(req.body);
        print('Failed to track interaction: $res');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> getRatingMenu(String menuId) async {
    String url = "${AppUrl.reviewMenu}$menuId";

    try {
      final req = await ApiClient.get(url);

      if (req.statusCode == 200) {
        return json.decode(req.body);
      } else {
        final res = json.decode(req.body);
        throw Exception(
            res['message'] ?? 'Terjadi kesalahan saat memuat data.');
      }
    } on SocketException {
      throw Exception(
          'Tidak ada koneksi internet. Mohon periksa jaringan Anda.');
    } catch (e) {
      print(e);
      throw Exception(
          'Terjadi kesalahan yang tidak diketahui. Mohon coba lagi.');
    }
  }

  void filterMenuByCategory(String categoryId) {
    if (_isThrottled) return;

    _isThrottled = true;
    _throttleTimer = Timer(const Duration(milliseconds: 500), () {
      _isThrottled = false;
    });

    selectedCanteenId.value = "all";
    selectedCategoryId.value = categoryId;
    getMenuByCategory(categoryId, isRefresh: true);

  }

  void filterMenuByCanteen(String canteenId) {
    if (_isThrottled) return;

    _isThrottled = true;
    _throttleTimer = Timer(const Duration(milliseconds: 500), () {
      _isThrottled = false;
    });

    selectedCategoryId.value = "";
    selectedCanteenId.value = canteenId;

    if (canteenId == "all") {
      fetchAllMenus(isRefresh: true);
    } else {
      getMenuByCanteen(canteenId, isRefresh: true);
    }
  }

  void handleSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getSearchMenu(query: query);
    });
  }

  void addToCart(Menu food, int quantity) {
    int currentQuantity = getQuantity(food);
    int totalQuantity = currentQuantity + quantity;

    if (totalQuantity > food.stock) {
      Get.snackbar(
        "Peringatan",
        "Jumlah melebihi stok persediaan!",
        animationDuration: Duration(milliseconds: 200),
        duration: Duration(milliseconds: 1650),
        backgroundColor: Colors.red,
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        margin: EdgeInsets.all(20.0),
        icon: Icon(
          CupertinoIcons.info_circle,
          color: Colors.white,
        ),
      );
      return;
    }

    // Tracking Interaction
    trackInteraction('add_to_cart', menuId: food.id);

    final existingIndex =
        cartItems.indexWhere((item) => item.menu.id == food.id);

    if (existingIndex >= 0) {
      cartItems[existingIndex] = CartItem(
        menu: food,
        quantity: cartItems[existingIndex].quantity + 1,
        note: cartItems[existingIndex].note,
      );
    } else {
      cartItems.add(CartItem(menu: food, quantity: 1, note: null));
    }
    cartItems.refresh();
  }

  void updateCart(Menu food, {required bool isAdding}) {
    if (isAdding) {
      addToCart(food, 1);
    } else {
      removeFromCart(food.id);
    }
  }

  void removeFromCart(String foodId) {
    final existingIndex =
        cartItems.indexWhere((item) => item.menu.id == foodId);

    if (existingIndex >= 0) {
      if (cartItems[existingIndex].quantity > 1) {
        cartItems[existingIndex] = CartItem(
          menu: cartItems[existingIndex].menu,
          quantity: cartItems[existingIndex].quantity - 1,
          note: cartItems[existingIndex].note,
        );
      } else {
        cartItems.removeAt(existingIndex);
      }
    }
  }

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  int getQuantity(Menu food) {
    final existingItem =
        cartItems.firstWhereOrNull((item) => item.menu.id == food.id);
    return existingItem?.quantity ?? 0;
  }

  int extractNumber(String text) {
    RegExp regExp = RegExp(r'\d+');
    Match? match = regExp.firstMatch(text);
    return match != null ? int.parse(match.group(0)!) : 0;
  }

  int get totalCartPrice {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item.menu.sellingCost * item.quantity),
    );
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String formatRupiah(int price) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    return formatCurrency.format(price);
  }

  Map<String, List<CartItem>> get groupedCartItems {
    Map<String, List<CartItem>> grouped = {};
    for (var item in cartItems) {
      final canteenName = item.menu.canteen.name;
      if (!grouped.containsKey(canteenName)) {
        grouped[canteenName] = [];
      }
      grouped[canteenName]!.add(item);
    }
    return grouped;
  }

  @override
  void onClose() {
    _debounce?.cancel();
    _throttleTimer?.cancel();
    super.onClose();
  }
}
