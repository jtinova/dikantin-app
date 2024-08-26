import 'package:dikantin/app/modules/pesanan/controllers/pesanan_controller.dart';
import 'package:get/get.dart';

import '../../../data/models/cancel_model.dart';
import '../../../data/models/pesanan_model.dart';
import '../../../data/providers/pesanan_provider.dart';

class DetailBelumbayarController extends GetxController {
  final isLoading = true.obs; // Define RxBool for loading state
  final pesananProvider = PesananProvider().obs; // Instantiate your provider
  late ProductCancellation statusProductCancel = ProductCancellation();
  late Pesanan pesananProses = Pesanan();
  late Pesanan pesananDikirim = Pesanan();
  late Pesanan pesananDiterima = Pesanan();
  late Pesanan belumbayar = Pesanan();
  var orderProses = <DataPesanan>[].obs;
  var orderDikirim = <DataPesanan>[].obs;
  var orderDiterima = <DataPesanan>[].obs;
  var belumBayar = <DataPesanan>[].obs;
  var transaksiData = Rxn<DataPesanan>();
  var detailTransaksi = <DataPesanan>[].obs;

  Future<void> loadAllData() async {
    await loadProses();
    await loadDikirim();
    await loadDiterima();
    await loadBelumbayar();
  }

  Future<void> fecthTransaksi(String kodeTr) async {
    await loadAllData();

    // Memeriksa status konfirmasi menu dengan kodeMenu yang diberikan
    final DataPesanan? order = findOrderById(kodeTr);
    if (order != null) {
      transaksiData.value = order;
    }
  }

  Future<void> refreshData(String kodeTr) async {
    try {
      isLoading(true);
      fecthTransaksi(kodeTr);
      Get.find<PesananController>().refreshPesanan();
    } catch (error) {
      // Tampilkan pesan kesalahan kepada pengguna
      Get.snackbar("Error", "Failed to refresh data: $error");
    } finally {
      isLoading(false);
    }
  }

  DataPesanan? detailTransaksiData(String kodeTr) {
    // Cari pesanan di setiap kategori (proses, dikirim, diterima)
    try {
      // Memperoleh data pesanan terbaru
      // Memeriksa transaksi berdasarkan kode transaksi yang diberikan
      final DataPesanan? order = findOrderById(kodeTr);
      if (order != null) {
        detailTransaksi.assignAll([order]);
      } else {
        // Jika transaksi tidak ditemukan, beri feedback kepada pengguna
        Get.snackbar("Error", "Transaction not found");
      }
    } catch (error) {
      // Tampilkan pesan kesalahan kepada pengguna
      Get.snackbar("Error", "Failed to load transaction details: $error");
    }
    return null;
  }

  Future<void> cancelProduct(String kodeTr, String kodeMenu) async {
    try {
      isLoading(true);
      // Memperoleh data pesanan terbaru
      await loadAllData();

      // Memeriksa status konfirmasi menu dengan kodeMenu yang diberikan
      final DataPesanan? order = findOrderById(kodeTr);
      if (order != null) {
        final detailTransaksi = order.transaksi?.detailTransaksi
            ?.firstWhereOrNull(
                (detail) => detail.kodeMenu.toString() == kodeMenu);
        if (detailTransaksi != null) {
          if (detailTransaksi.statusKonfirm == "menunggu") {
            // Jika status konfirmasi adalah "menunggu", maka lakukan pembatalan
            final response = await pesananProvider.value
                .productCancellation(kodeTr, kodeMenu);
            if (response.kode == 1) {
              refreshData(kodeTr);
              Get.snackbar("Success", response.status.toString());
            } else {
              refreshData(kodeTr);
              Get.snackbar(
                  "Error", "Failed to submit order: ${response.status}");
            }
          } else {
            Get.snackbar(
                "Error", "Tidak dapat membatalkan menu karena sudah diproses.");
          }
        }
      }

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error saat membatalkan pesanan: $error');
    }
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
}
