// ignore_for_file: avoid_print

import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      final rawAPI = customUrlController.text.trim();
      await prefs.setString('api_custom_url', rawAPI);
      customUrl.value = rawAPI;
    }
    updateBaseUrl();
    Get.back();

    Get.snackbar(
      'Sukses',
      'URL API berhasil diubah ke ${selectedEnv.value}',
      animationDuration: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 1650),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderWidth: 5.w,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 20.w,
      ),
      icon: const Icon(
        CupertinoIcons.info_circle,
        color: Colors.white,
      ),
    );
  }

  void updateBaseUrl() {
    if (selectedEnv.value == 'Custom') {
      AppUrl.baseURL = 'http://${customUrl.value}';
    } else {
      AppUrl.baseURL = apiEnvironments[selectedEnv.value]!;
    }

    AppUrl.baseURLAPI = '${AppUrl.baseURL}/api';
    print("🚀 API URL changed to: ${AppUrl.baseURL}");
  }

  @override
  void onClose() {
    customUrlController.dispose();
    super.onClose();
  }
}
