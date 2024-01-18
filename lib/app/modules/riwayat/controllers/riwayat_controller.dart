// ignore_for_file: unused_import, unnecessary_null_comparison

import 'package:dikantin/app/data/models/search_model.dart';
import 'package:dikantin/app/data/providers/riwayat_provider.dart';
// import 'package:dikantin/app/data/models/riwayat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/penjualan_model.dart';
import '../../../data/providers/menu_provider.dart';

class RiwayatController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController _controller;
  late TabController tabController;
  late Penjualan penjualan = Penjualan();
  final count = 0.obs;
  final riwayatProvider = RiwayatProvider().obs;
  late Rx<DateTime> selectedDate = DateTime.now().obs;
  var cartList = <Datasearch>[].obs;
  var itemQuantities = <int, int>{}.obs;
  final searchResults = <Datasearch>[].obs;
  final isLoading = false.obs; // Tambahkan isLoading

  @override
  void onInit() {
    super.onInit();
    refreshData();
    searchAll();
    search('', '');
    searchDate('');
  }

  @override
  void onReady() {
    super.onReady();
  }

  void addToCart(Datasearch item) {
    // Cek apakah item sudah ada di keranjang
    if (!cartList.any((element) => element.idMenu == item.idMenu)) {
      cartList.add(item);
      itemQuantities[item.idMenu!] = 1;
      Get.snackbar(
        'berhasil',
        'menambahkan ke keranjang',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    } else {
      addQuantity(item.idMenu!);
    }
    itemQuantities.refresh();
  }

  void removeFromCart(Datasearch item) {
    cartList.removeWhere((element) => element.nama == item.nama);
    itemQuantities.remove(item.idMenu); // Ini akan menghapus kuantitas dari map
    itemQuantities
        .refresh(); // Memperbarui observers agar jumlah total kuantitas diperbarui di UI
    Get.snackbar(
      'berhasil',
      'berhasil menghapus',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
    );
    update(); // Memanggil update untuk memicu pembaruan UI pada widget yang terkait
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

  chooseDate() async {
    DateTime? pickerDate = await showDatePicker(
        context: Get.context!,
        initialDate: selectedDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
        helpText: 'Pilih Tanggal Pemesanan Anda',
        cancelText: 'Batal',
        confirmText: 'Pilih');
    if (pickerDate != null && pickerDate != selectedDate.value) {
      selectedDate.value = pickerDate;
      print(selectedDate.value);
      await refreshData();
    }
  }

  deleteDate() async {
    if (selectedDate.value != null) {
      selectedDate == null;
      update();
    }
  }

  @override
  void onClose() {
    _controller.dispose();
    tabController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
  void startAnimation() {
    _controller.forward();
  }

  void setLoading(bool value) {
    isLoading.value = value; // Metode untuk mengatur status isLoading
  }

  Future<void> refreshData() async {
    await search('', '');
    await searchDate('');
  }

  Future<void> search(String keyword, String Date) async {
    try {
      setLoading(
          true); // Set isLoading menjadi true saat pemanggilan API dimulai
      final results = await riwayatProvider.value
          .searchRiwayat(keyword, selectedDate.value.toString());
      searchResults.assignAll(results.data ?? []);
    } catch (e) {
      print('Error during search: $e');
      searchResults.clear();
    } finally {
      setLoading(
          false); // Set isLoading menjadi false saat pemanggilan API selesai
    }
  }

  Future<void> searchDate(String keyword) async {
    try {
      setLoading(
          true); // Set isLoading menjadi true saat pemanggilan API dimulai
      final results = await riwayatProvider.value
          .searchRiwayatDate(selectedDate.value.toString());
      searchResults.assignAll(results.data ?? []);
    } catch (e) {
      print('Error during search: $e');
      searchResults.clear();
    } finally {
      setLoading(
          false); // Set isLoading menjadi false saat pemanggilan API selesai
    }
  }

  Future<void> searchAll() async {
    try {
      setLoading(
          true); // Set isLoading menjadi true saat pemanggilan API dimulai
      final results = await riwayatProvider.value.searchRiwayatall();
      searchResults.assignAll(results.data ?? []);
    } catch (e) {
      print('Error during search: $e');
      searchResults.clear();
    } finally {
      setLoading(
          false); // Set isLoading menjadi false saat pemanggilan API selesai
    }
  }
}
