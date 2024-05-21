import 'package:dikantin/app/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/version_model.dart';
import '../../../data/providers/authKurir_provider.dart';
import '../../../data/providers/menu_provider.dart';
import '../../../repository/ConnectivityHelper..dart';
import '../../fcm/fcm.dart';

class LoginController extends GetxController {
  final count = 0.obs;
  final loginProvider = AuthProvider().obs;
  final loginKurirProvider = AuthKurirProvider().obs;
  final menuP = MenuProvider().obs;
  Rx<Version> version = Version().obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ConnectivityHelper connectivityHelper = Get.put(ConnectivityHelper());

  @override
  Future<void> onInit() async {
    super.onInit();
    FcmService fcmService = FcmService();
    var token = await fcmService.getDeviceToken();
    // save token ketika login view di render
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('tokenFcm', token);
    print(token);
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

  // login dan juga obsecure
  final RxBool obscureText = true.obs;
  final RxBool isLoading = false.obs;

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }


  Future<void> login(String username, String password, String fcmtoken) async {
    try {
      // Periksa status koneksi sebelum melakukan login
      if (!connectivityHelper.hasConnection.value) {
        // Tampilkan Snackbar bahwa tidak ada koneksi
        Get.snackbar(
          'Koneksi Eror',
          'Cek Koneksi Internet anda',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      isLoading.value = true;
      final response =
          await loginProvider.value.login(username, password, fcmtoken);

      if (response.statusCode == 200) {
        Get.offAllNamed('/navigation');
      } else {
        // Tampilkan Snackbar dengan pesan error
        Get.snackbar(
          'Login Gagal',
          'Username atau Password salah',
          backgroundColor: Colors.red, // Warna latar belakang
          colorText: Colors.white, // Warna teks
          duration: Duration(seconds: 2), // Durasi Snackbar
          snackPosition: SnackPosition.BOTTOM, // Posisi Snackbar
        );
      }
    } catch (error) {
      // Tangani pengecualian di sini, jika diperlukan
      print('An error occurred login: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginKurir(
      String username, String password, String fcmtoken) async {
    try {
      if (!connectivityHelper.hasConnection.value) {
        // Tampilkan Snackbar bahwa tidak ada koneksi
        Get.snackbar(
          'Koneksi Eror',
          'Cek Koneksi Internet anda',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      isLoading.value = true;
      final response = await loginKurirProvider.value
          .loginKurir(username, password, fcmtoken);

      if (response.statusCode == 200) {
        Get.offAllNamed('/navigationKurir');
      } else {
        // Tampilkan Snackbar dengan pesan error
        Get.snackbar(
          'Login Gagal',
          'Username atau Password salah',
          backgroundColor: Colors.red, // Warna latar belakang
          colorText: Colors.white, // Warna teks
          duration: Duration(seconds: 2), // Durasi Snackbar
          snackPosition: SnackPosition.BOTTOM, // Posisi Snackbar
        );
      }
    } catch (error) {
      // Tangani pengecualian di sini, jika diperlukan
      print('An error occurred: $error');
    } finally {
      isLoading.value = false;
    }
  }

  void initializeLoginProvider() {
    Get.put(AuthKurirProvider());
  }
}
