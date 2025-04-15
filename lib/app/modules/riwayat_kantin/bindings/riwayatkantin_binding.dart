import 'package:get/get.dart';
import '../controllers/riwayatkantin_controller.dart';

class RiwayatKantinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatKantinController>(
      () => RiwayatKantinController());
  }
}
