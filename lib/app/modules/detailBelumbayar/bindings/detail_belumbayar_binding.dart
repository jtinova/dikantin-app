import 'package:get/get.dart';

import '../controllers/detail_belumbayar_controller.dart';

class DetailBelumbayarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBelumbayarController>(
      () => DetailBelumbayarController(),
    );
  }
}
