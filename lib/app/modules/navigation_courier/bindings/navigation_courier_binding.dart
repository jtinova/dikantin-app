import 'package:get/get.dart';

import '../../home_courier/controllers/home_courier_controller.dart';
import '../../profile_courier/controllers/courier_profile_controller.dart';
import '../controllers/navigation_courier_controller.dart';

class NavigationCourierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationCourierController>(
      () => NavigationCourierController(),
    );
    Get.lazyPut<CourierProfileController>(
      () => CourierProfileController(),
    );
    Get.lazyPut<HomeCourierController>(
      () => HomeCourierController(),
    );
  }
}
