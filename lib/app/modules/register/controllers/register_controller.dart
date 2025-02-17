import 'package:dikantin/app/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RegisterController extends GetxController {
  final RegisterProvider registerProvider = RegisterProvider();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final RxBool obscureText = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool obscureConfirmText = true.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void toggleObscureConfirmText() {
    obscureConfirmText.value = !obscureConfirmText.value;
  }

  void register() {
    if (passwordController.text != confirmPasswordController.text) {
      EasyLoading.showError('Password tidak sama');
      return;
    }

    // Proceed with registration
  }
}
