import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiController extends GetxController {
  final Map<String, String> apiEnvironments = {
    'Production': 'https://dikantin.com',
    'Staging': 'https://dikantin-staging.jtinova.com',
    'Custom': '',
  };

  final RxString selectedEnv = 'Staging'.obs;
  final RxString customUrl = ''.obs;

  late TextEditingController customUrlController;

  @override
  void onInit() {
    super.onInit();
    customUrlController = TextEditingController();
    loadApiSetting();
  }

  Future<void> loadApiSetting() async {
    final prefs = await SharedPreferences.getInstance();
    selectedEnv.value = prefs.getString('api_env') ?? 'Production';
    customUrl.value = prefs.getString('api_custom_url') ?? '';
    customUrlController.text = customUrl.value;
    updateBaseUrl();
  }

  Future<void> saveApiSetting() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_env', selectedEnv.value);
    if (selectedEnv.value == 'Custom') {
      await prefs.setString('api_custom_url', customUrlController.text);
      customUrl.value = customUrlController.text;
    }
    updateBaseUrl();
    Get.back();
    Get.snackbar(
      'Sukses',
      'URL API berhasil diubah ke ${selectedEnv.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void updateBaseUrl() {
    if (selectedEnv.value == 'Custom') {
      AppUrl.baseURL = customUrl.value;
    } else {
      AppUrl.baseURL = apiEnvironments[selectedEnv.value]!;
    }
    print("🚀 API URL changed to: ${AppUrl.baseURL}");
  }

  @override
  void onClose() {
    customUrlController.dispose();
    super.onClose();
  }
}
