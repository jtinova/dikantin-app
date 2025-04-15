import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeKantinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController());
  }
}
