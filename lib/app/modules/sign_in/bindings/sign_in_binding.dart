import 'package:dikantin_app_rebuild/app/modules/sign_in/controllers/api_controller.dart';
import 'package:get/get.dart';

import '../controllers/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(
      () => SignInController(),
    );
    Get.lazyPut<ApiController>(
      () => ApiController(),
    );
  }
}
