import 'package:get/get.dart';

import '../controllers/detail_pesanan_kurir_controller.dart';

class DetailPesananKurirBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPesananKurirController>(
      () => DetailPesananKurirController(),
    );
  }
}
