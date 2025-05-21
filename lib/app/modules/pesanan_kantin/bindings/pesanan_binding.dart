import 'package:get/get.dart';
import '../controllers/pesanan_controller.dart';

class PesananKantinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PesananController>(
      () => PesananController());
  }
}
