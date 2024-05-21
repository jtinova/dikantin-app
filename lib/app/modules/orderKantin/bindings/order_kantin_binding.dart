import 'package:get/get.dart';

import '../controllers/order_kantin_controller.dart';

class OrderKantinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderKantinController>(
      () => OrderKantinController(),
    );
  }
}
