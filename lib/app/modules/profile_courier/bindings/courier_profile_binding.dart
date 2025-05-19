import 'package:get/get.dart';

import '../controllers/courier_profile_controller.dart';

class CourierProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourierProfileController>(
      () => CourierProfileController(),
    );
  }
}
