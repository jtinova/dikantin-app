import 'package:get/get.dart';

import '../controllers/home_courier_controller.dart';

class HomeCourierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeCourierController>(
      () => HomeCourierController(),
    );
  }
}
