import 'package:dikantin/app/modules/utils/belumbayar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../data/models/belumbayar_model.dart';
import '../../../data/models/pesanan_model.dart';
import '../../../data/providers/pesanan_provider.dart';

class PesananController extends GetxController
    with GetTickerProviderStateMixin {
  //TODO: Implement PesananController
  late AnimationController _controller;
  late TabController tabController; // Tambahkan variabel TabController
  final count = 0.obs;
  final isLoading = true.obs; // Define RxBool for loading state
  final pesananProvider = PesananProvider().obs; // Instantiate your provider
  late Pesanan pesananProses = Pesanan();
  late Pesanan pesananDikirim = Pesanan();
  late Pesanan pesananDiterima = Pesanan();
  late Pesanan belumbayar = Pesanan();
  var orderProses = <DataPesanan>[].obs;
  var orderDikirim = <DataPesanan>[].obs;
  var orderDiterima = <DataPesanan>[].obs;
  var belumBayar = <DataPesanan>[].obs;
  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabSelection);

    loadProses();
    loadDikirim();
    loadDiterima();
    loadBelumbayar();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _controller.dispose();
    tabController.dispose(); // Hapus TabController saat controller ditutup

    super.onClose();
  }

  Future<void> refreshPesanan() async {
    await loadProses();
    await loadDikirim();
    await loadDiterima();
    await loadBelumbayar();
  }

  void _handleTabSelection() async {
    // Handle perubahan tab di sini
    switch (tabController.index) {
      case 0:
        loadProses();
        break;
      case 1:
        loadDikirim();
        break;
      case 2:
        loadDiterima();
        break;
      case 3:
        loadBelumbayar();
        break;
    }
  }

  void increment() => count.value++;
  void startAnimation() {
    _controller.forward();
  }

  DataPesanan? findOrderById(String orderId) {
    // Cari pesanan di setiap kategori (proses, dikirim, diterima)
    final orderProsesById = orderProses
        .firstWhereOrNull((order) => order.transaksi?.kodeTr == orderId);
    if (orderProsesById != null) {
      return orderProsesById;
    }

    final orderDikirimById = orderDikirim
        .firstWhereOrNull((order) => order.transaksi?.kodeTr == orderId);
    if (orderDikirimById != null) {
      return orderDikirimById;
    }

    final orderDiterimaById = orderDiterima
        .firstWhereOrNull((order) => order.transaksi?.kodeTr == orderId);
    if (orderDiterimaById != null) {
      return orderDiterimaById;
    }
    final belumbayarById = belumBayar
        .firstWhereOrNull((order) => order.transaksi?.kodeTr == orderId);
    if (belumbayarById != null) {
      return belumbayarById;
    }
    return null; // Return null jika pesanan tidak ditemukan
  }


  Future<void> loadProses() async {
    try {
      isLoading(true);
      final result = await pesananProvider.value.proses();
      pesananProses = result;
      orderProses.assignAll(result.data!);
      update(); // Memanggil update() untuk memperbarui widget

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching data: $error');
    }
  }

  Future<void> loadDikirim() async {
    try {
      isLoading(true);
      final result = await pesananProvider.value.dikirim();
      pesananDikirim = result;
      orderDikirim.assignAll(result.data!);
      update(); // Memanggil update() untuk memperbarui widget
      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching data: $error');
    }
  }

  Future<void> loadDiterima() async {
    try {
      isLoading(true);
      final result = await pesananProvider.value.diterima();
      pesananDiterima = result;
      orderDiterima.assignAll(result.data!);
      update(); // Memanggil update() untuk memperbarui widget

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching data: $error');
    }
  }

  Future<void> loadBelumbayar() async {
    try {
      isLoading(true);
      final result = await pesananProvider.value.belumbayar();
      belumbayar = result;
      belumBayar.assignAll(result.data!);
      update(); // Memanggil update() untuk memperbarui widget

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching data: $error');
    }
  }

  Future<void> batalkanPesanan(String kodeTr) async {
    try {
      isLoading(true);
      await pesananProvider.value.batalkanPesanan(kodeTr);
      // Refresh data setelah pembatalan pesanan berhasil
      await loadProses();
      update();

      // loadDikirim();
      // loadDiterima();
      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error saat membatalkan pesanan: $error');
    }
  }
}
