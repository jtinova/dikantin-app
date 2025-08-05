import 'package:get/get.dart';

import '../../chat/controllers/chat_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../order/controllers/order_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
  
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<OrderController>(OrderController(), permanent: true);
    Get.put<ProfileController>(ProfileController(), permanent: true);

    Get.put(ChatController()); 
  }
}
