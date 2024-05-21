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

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshData() async {
    /* await loadDetail(); */
  }
  Future<void> cancelProduct(String kodeTr, String kodeMenu) async {
    try {
      isLoading(true);
      await pesananProvider.value.productCancellation(kodeTr, kodeMenu);
      // Refresh data setelah pembatalan pesanan berhasil
      update();
      loadProses();
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
}
