import 'package:android_intent_plus/android_intent.dart';
import 'package:dikantin/app/data/models/pesanan_kirim_model.dart';
import 'package:dikantin/app/data/providers/pesanan_provider.dart';
import 'package:dikantin/app/modules/pesananKurir/controllers/pesananKurir_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

class DetailPesananKurirController extends GetxController {
  final isLoading = true.obs; // Define RxBool for loading state
  final pesananProvider = PesananProvider().obs; // Instantiate your provider
  late PesananKirim pesananUntukDikirim = PesananKirim();
  late PesananKirim pesananKonfirmasi = PesananKirim();
  late PesananKirim loadRiwayat = PesananKirim();
  var orderUntukDikirim = <DataPesananKirim>[].obs;
  var orderKonfirmasi = <DataPesananKirim>[].obs;
  var riwayatKurir = <DataPesananKirim>[].obs;
  var pesananData = Rxn<DataPesananKirim>();
  var detailPesanan = <DataPesananKirim>[].obs;
  String scannedQrCode = '';

  @override
  void onInit() {
    super.onInit();
    loadUntukDikirim();
    loadKonfirmasi();
    loadRiwayatKurir();
  }

  Future<void> loadAllData() async {
    await loadUntukDikirim();
    await loadKonfirmasi();
    await loadRiwayatKurir();
  }

  Future<void> fecthPesanan(String kodeTr) async {
    await loadAllData();

    // Memeriksa status konfirmasi menu dengan kodeMenu yang diberikan
    final DataPesananKirim? order = findOrderById(kodeTr);
    if (order != null) {
      pesananData.value = order;
      // Memeriksa apakah detail transaksi kosong
      if (pesananData.value?.transaksi?.detailTransaksi?.isEmpty ?? true) {
        Get.back();
      }
    }
  }

  Future<void> refreshData(String kodeTr) async {
    try {
      isLoading(true);
      await fecthPesanan(kodeTr);
      Get.find<PesananKurirController>().refreshPesanan();
    } catch (error) {
      // Tampilkan pesan kesalahan kepada pengguna
      Get.snackbar("Error", "Failed to refresh data: $error");
    } finally {
      isLoading(false);
    }
  }

  DataPesananKirim? detailTransaksiData(String kodeTr) {
    // Cari pesanan di setiap kategori (proses, dikirim, diterima)
    try {
      // Memperoleh data pesanan terbaru
      // Memeriksa transaksi berdasarkan kode transaksi yang diberikan
      final DataPesananKirim? order = findOrderById(kodeTr);
      if (order != null) {
        detailPesanan.assignAll([order]);
      } else {
        // Jika transaksi tidak ditemukan, beri feedback kepada pengguna
        Get.snackbar("Error", "Order not found");
      }
    } catch (error) {
      // Tampilkan pesan kesalahan kepada pengguna
      Get.snackbar("Error", "Failed to load order details: $error");
    }
    return null;
  }

  DataPesananKirim? findOrderById(String orderId) {
    // Cari pesanan di setiap kategori (proses, dikirim, diterima)

    final orderDikirimById = orderUntukDikirim
        .firstWhereOrNull((order) => order.transaksi?.kodeTr == orderId);
    if (orderDikirimById != null) {
      return orderDikirimById;
    }

    final orderDiterimaById = orderKonfirmasi
        .firstWhereOrNull((order) => order.transaksi?.kodeTr == orderId);
    if (orderDiterimaById != null) {
      return orderDiterimaById;
    }

    final riwayatKurirById = riwayatKurir
        .firstWhereOrNull((order) => order.transaksi?.kodeTr == orderId);
    if (riwayatKurirById != null) {
      return riwayatKurirById;
    }

    return null; // Return null jika pesanan tidak ditemukan
  }

  Future<void> scanQrCode(String kodeTr) async {
    try {
      // Panggil fungsi scan QR code dari paket barcode_scanner
      scannedQrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (kodeTr != scannedQrCode) {
        Get.snackbar("Scan Gagal, ", "Kode Tidak Sesuai",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }

      if (scannedQrCode == kodeTr) {
        Get.snackbar("Scan Berhasil, ", "Menunggu Konfirmasi Admin",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.green,
            colorText: Colors.white);
        await confirmKurir(kodeTr, scannedQrCode);
      }
      // Update nilai hasil scan ke dalam variabel scannedQrCode
      // scannedQrCode.value = result ?? '';
    } catch (e) {
      // Tangani error jika terjadi
      print('Error during QR code scanning: $e');
    }
  }

  Future<void> refreshPesanan() async {
    await loadUntukDikirim();
    await loadKonfirmasi();
  }

  Future<void> loadUntukDikirim() async {
    try {
      isLoading(true);
      final result = await pesananProvider.value.untukDikirim();
      pesananUntukDikirim = result;
      orderUntukDikirim.assignAll(result.data!);
      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching data: $error');
    }
  }

  Future<void> loadKonfirmasi() async {
    try {
      isLoading(true);
      final result = await pesananProvider.value.konfirmasi();
      pesananKonfirmasi = result;
      orderKonfirmasi.assignAll(result.data!);
      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching data: $error');
    }
  }

  Future<void> loadRiwayatKurir() async {
    try {
      isLoading(true);
      final result = await pesananProvider.value.riwayatKurir();
      loadRiwayat = result;
      riwayatKurir.assignAll(result.data!);
      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching data: $error');
    }
  }

  Future<void> acceptedPesanan(String kodeTr) async {
    try {
      isLoading(true);
      await pesananProvider.value.acceptPesanan(kodeTr);
      // Refresh data setelah pembatalan pesanan berhasil
      await loadUntukDikirim();
      update();
      Get.back();
      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error saat mengkonfirmasi pesanan diantar: $error');
    }
  }

  Future<void> confirmKurir(String kodeTr, String bukti) async {
    try {
      isLoading(true);
      await pesananProvider.value.konfirKurir(kodeTr, bukti);
      // Refresh data setelah pembatalan pesanan berhasil
      await loadKonfirmasi();
      update();

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error saat membatalkan pesanan: $error');
    }
  }
}
