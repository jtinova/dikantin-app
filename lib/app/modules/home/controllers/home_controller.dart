import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
import '../../../data/models/penjualan_model.dart';
import '../../../data/models/search_model.dart';
import '../../../data/providers/menu_provider.dart';
import '../../../data/providers/services.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController catatanController = TextEditingController();
  final notesMap = <int, String>{}.obs;
  late AnimationController animationController;
  late AnimationController _controller;
  late TabController tabController; // Tambahkan variabel TabController
  final searchResults = <Datasearch>[].obs;
  final menuProvider = MenuProvider().obs;
  late Penjualan penjualan = Penjualan();
  var cartList = <Datasearch>[].obs;
  var penjualanD = <Data>[].obs;
  var itemQuantities = <int, int>{}.obs;
  final isLoading = false.obs; // Tambahkan isLoading
  final isCashSelected = true.obs;
  final isPolijePaySelected = false
      .obs; // Digunakan untuk memantau apakah metode pembayaran Polije Pay dipilih

// Menghitung total harga dari semua item di keranjang, termasuk kuantitas dan diskon
  int get totalPrice {
    int total = 0;
    for (var item in cartList) {
      int itemTotal = calculatePriceAfterDiscount(item) *
          (itemQuantities[item.idMenu] ?? 1);
      total += itemTotal;
    }
    return total;
  }

  int get countc => cartList.length;

  int get count {
    return itemQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  // Calculate discount for each item
  int calculateDiscount(Datasearch item) {
    // Check for null and return 0 if discount is null
    int discount = item.diskon ?? 0;
    return (item.harga! * discount) ~/ 100;
  }

  // Calculate price after discount for each item
  int calculatePriceAfterDiscount(Datasearch item) {
    // Subtract the discount from the item's price
    return item.harga! - calculateDiscount(item);
  }

  // Get total price after all discounts have been applied
  int get totalPriceAfterDiscount =>
      cartList.fold(0, (sum, item) => sum + calculatePriceAfterDiscount(item));

  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animationController = AnimationController(
      duration: Duration(milliseconds: 500), // Sesuaikan durasi animasi
      vsync: this,
    );
    tabController = TabController(length: 4, vsync: this);
    fetchDataDiskon('');
    fetchDataPenjualan();
    refreshData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _controller.dispose();
    tabController.dispose();
    super.onClose();
  }

  void saveNoteForMenu(int idMenu, String note) {
    notesMap[idMenu] = note;
  }

  String getNoteForMenu(int idMenu) {
    return notesMap[idMenu] ?? '';
  }

  void clearNoteForMenu(int idMenu) {
    notesMap.remove(idMenu);
  }

  void addToCart(Datasearch item, String note) {
    int idMenu = item.idMenu!;
    // Cek apakah item sudah ada di keranjangz
    if (!cartList.any((element) => element.idMenu == item.idMenu)) {
      cartList.add(item);
      itemQuantities[item.idMenu!] = 1;
      saveNoteForMenu(item.idMenu!, catatanController.text);
    } else {
      addQuantity(item.idMenu!);
    }
    // Save or update the note for the item
    notesMap[idMenu] = note;

    // Refresh itemQuantities and notesMap
    itemQuantities.refresh();
    notesMap.refresh();
  }

  void removeFromCart(Datasearch item) {
    int idMenu = item.idMenu!;
    clearNoteForMenu(idMenu);
    cartList.removeWhere((element) => element.idMenu == item.idMenu);
    itemQuantities.remove(item.idMenu); // Ini akan menghapus kuantitas dari map
    itemQuantities.refresh();
    notesMap.refresh();
// Memperbarui observers agar jumlah total kuantitas diperbarui di UI
    update(); // Memanggil update untuk memicu pembaruan UI pada widget yang terkait
  }

  void startAnimation() {
    _controller.forward();
  }

  void addQuantity(int idMenu) {
    if (itemQuantities.containsKey(idMenu)) {
      itemQuantities[idMenu] = (itemQuantities[idMenu] ?? 1) + 1;
    } else {
      itemQuantities[idMenu] =
          1; // Jika item belum ada dalam map, set kuantitas ke 1
    }
    itemQuantities.refresh(); // Memperbarui UI
  }

  void subtractQuantity(int idMenu) {
    if (itemQuantities.containsKey(idMenu) && itemQuantities[idMenu]! > 1) {
      itemQuantities[idMenu] = (itemQuantities[idMenu] ?? 1) - 1;
      itemQuantities.refresh(); // Memperbarui UI
    }
  }

  void setLoading(bool value) {
    isLoading.value = value; // Metode untuk mengatur status isLoading
  }

  Future<void> fetchDataDiskon(String keyword) async {
    try {
      setLoading(
          true); // Set isLoading menjadi true saat pemanggilan API dimulai
      final results = await menuProvider.value.fetchDataDiskon(keyword);
      searchResults.assignAll(results.data ?? []);
    } catch (e) {
      print('Error during search: $e');
      searchResults.clear();
    } finally {
      setLoading(
          false); // Set isLoading menjadi false saat pemanggilan API selesai
    }
  }

  int calculateSubtotal(int idMenu) {
    final int price = calculatePriceAfterDiscount(findMenuById(idMenu));
    final int quantity = itemQuantities[idMenu] ?? 1;
    return price * quantity;
  }

  Datasearch findMenuById(int idMenu) {
    return cartList.firstWhere((menu) => menu.idMenu == idMenu,
        orElse: () => Datasearch());
  }

  Future<void> fetchDataPenjualan() async {
    try {
      isLoading(true);
      final result = await menuProvider.value.fetchDataPenjualanHariIni();
      penjualan = result;
      penjualanD.assignAll(result.data!);
      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching data: $error');
    }
  }

  Future<void> refreshData() async {
    await fetchDataDiskon('');
    await fetchDataPenjualan();
  }

  void setCartList(List<Datasearch> updatedCartList) {
    cartList.assignAll(updatedCartList);
  }

  Future<void> submitOrder() async {
    setLoading(true); // Menampilkan indikator loading
    String paymentMethod = isCashSelected.value
        ? "cash"
        : isPolijePaySelected.value
            ? "cash"
            : "Unknown Payment Method";
    Map<String, dynamic> detailOrderan = {
      "total_harga": totalPrice,
      "total_bayar": totalPrice,
      "kembalian": 0,
      "model_pembayaran": paymentMethod
    };

    try {
      final response = await menuProvider.value.postOrder(
        cartList,
        detailOrderan,
        itemQuantities,
        notesMap.toJson(), // Mengambil catatan dari notesMap
      );

      if (response.statusCode == 200) {
        // Proses order berhasil
        Get.snackbar("Success", "Order submitted successfully");
        // Reset cart dan quantities atau navigasi ke halaman berikutnya
        cartList.clear();
        itemQuantities.clear();
        notesMap.clear();
        catatanController
            .clear(); // Mengosongkan notesMap setelah order berhasil
      } else {
        // Proses order gagal
        Get.snackbar("Error", "Failed to submit order: ${response.body}");
      }
    } catch (e) {
      // Menangani kesalahan yang mungkin terjadi selama request
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      setLoading(false); // Menutup indikator loading
    }
  }

  Future<void> ngapek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id_customer = prefs.getString('id_customer');

    final response = await http.post(
      Uri.parse(Api.getToken),
      body: {
        'id_customer': id_customer, // Ganti dengan informasi unik dari pengguna
      },
    );

    if (response.statusCode == 200) {
      // Berhasil membatalkan pesanan
      final jsonResponse = jsonDecode(response.body);

      final newToken = jsonResponse['data']['token'];
      print(newToken);
      print('c');
    } else {
      // Gagal membatalkan pesanan
      print('Gagal ambil data. Status code: ${response.statusCode}');
      throw Exception('Gagal ambil data');
    }
  }
}
