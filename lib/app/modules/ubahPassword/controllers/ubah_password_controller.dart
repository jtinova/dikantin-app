import 'package:dikantin/app/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbahPasswordController extends GetxController {
  final count = 0.obs;
  final passwordProvider = PasswordVerificationProvider().obs;
  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();
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
    newPassword.dispose();
    confirmPassword.dispose();
  }

  void increment() => count.value++;

  bool isPasswordMatch() {
    return newPassword.text == confirmPassword.text;
  }

  void updatePassword() {
    if (isPasswordMatch()) {
      verifyNewPassword(newPassword.text, confirmPassword.text);
      print('Updating password: ${newPassword.text}');
    } else {
      Get.snackbar(
          'Error', 'Terjadi kesalahan: Password yang anda masukan salah');
    }
  }

  Future<void> verifyNewPassword(
      String password, String confirmPassword) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');

      final response = await passwordProvider.value
          .verifyNewPassword(email!, password, confirmPassword);

      if (response.statusCode == 200) {
        // Handle successful response
        print('Response Data: ${response.body}');
        await backLogin();
        Get.snackbar('Sukses', 'Password berhasil diubah');
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        // Menampilkan pesan kesalahan dari server ke pengguna jika diperlukan
        Get.snackbar('Gagal',
            'Password baru tidak boleh sama dengan password lama. Silakan coba password yang berbeda.');
      }
    } catch (error) {
      // Handle other errors (e.g., network error)
      print('Error: $error');
      // Menampilkan pesan kesalahan ke pengguna jika diperlukan
      Get.snackbar('Error', 'Terjadi kesalahan: $error');
    }
  }
}

Future<void> backLogin() async {
  // Hapus data dari SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  // Navigasi ke halaman login
  Get.offAllNamed('/login');
}
