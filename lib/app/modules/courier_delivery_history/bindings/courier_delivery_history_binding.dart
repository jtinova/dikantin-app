import 'package:get/get.dart';
import '../controllers/courier_delivery_history_controller.dart';

class CourierDeliveryHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourierDeliveryHistoryController>(
      () => CourierDeliveryHistoryController(),
    );
  }
} 