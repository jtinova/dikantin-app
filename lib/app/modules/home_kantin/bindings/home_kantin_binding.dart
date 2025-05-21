import 'package:get/get.dart';
import '../controllers/home_kantin_controller.dart';

class HomeKantinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeKantinController>(
      () => HomeKantinController());
  }
}