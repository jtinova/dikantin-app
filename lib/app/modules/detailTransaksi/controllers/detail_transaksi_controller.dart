import 'package:get/get.dart';

import '../../../data/models/cancel_model.dart';
import '../../../data/models/pesanan_model.dart';
import '../../../data/providers/pesanan_provider.dart';

class DetailTransaksiController extends GetxController {
  //TODO: Implement DetailTransaksiController
  final isLoading = true.obs; // Define RxBool for loading state
  final pesananProvider = PesananProvider().obs; // Instantiate your provider
  late ProductCancellation statusProductCancel = ProductCancellation();
  var detailOrder = <DetailTransaksi>[].obs;

  @override
  void onInit() {
    super.onInit();
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

      // loadDikirim();
      // loadDiterima();
      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error saat membatalkan pesanan: $error');
    }
  }

}
