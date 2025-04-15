import 'package:get/get.dart';
import '../controllers/menu_controller.dart';

class MenuKantinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuKantinController>(
      () => MenuKantinController());
  }
}
