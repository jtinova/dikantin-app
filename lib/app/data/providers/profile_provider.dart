import 'dart:convert';
import 'package:dikantin/app/data/providers/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  Future<void> editProfile({
    required String token,
    required String nama,
    required String email,
    required String noTelepon,
    required String alamat,
  }) async {
    final url = Uri.parse(Api.updateProfile);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'no_telepon': noTelepon,
          'alamat': alamat,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Perhatian',
          'Data Berhasil Diperbarui ',
          snackPosition: SnackPosition.TOP, // Menampilkan Snackbar dari atas
          duration: Duration(seconds: 2),
        );
      } else {
        final jsonResponse = jsonDecode(response.body);
        final errorMessage = jsonResponse['data'];
        Get.snackbar(
          'Salah Woy',
          '$errorMessage',
          snackPosition: SnackPosition.TOP, // Menampilkan Snackbar dari atas
          duration: Duration(seconds: 2),
        );
        print('Error status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
      }
    } catch (error) {
      // Tangani kesalahan jaringan atau kesalahan lainnya
      print('Error: $error');

      if (error is http.Response) {
        // Jika kesalahan adalah respons HTTP, cetak body respons
        print('Response body: ${error.body}');
      }
    }

    notifyListeners();
  }

  Future<void> editAlamat(
      {required String token,
      required String alamat,
      required String lat,
      required String long,
      required String ket}) async {
    final url = Uri.parse(Api.updateProfile);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'alamat': alamat,
          'longitude': long,
          'latitude': lat,
          'keterangan': ket
        }),
      );

      if (response.statusCode == 200) {
        print('sukses');
      } else {
        final jsonResponse = jsonDecode(response.body);
        final errorMessage = jsonResponse['data'];
        Get.snackbar(
          'Perhatian Eror',
          '$errorMessage',
          snackPosition: SnackPosition.TOP, // Menampilkan Snackbar dari atas
          duration: Duration(seconds: 2),
        );
        print('Error status code: ${response.statusCode}');
        print('Error cok response body: ${response.body}');
      }
    } catch (error) {
      // Tangani kesalahan jaringan atau kesalahan lainnya
      print('Error iki: $error');

      if (error is http.Response) {
        // Jika kesalahan adalah respons HTTP, cetak body respons
        print('Response body: ${error.body}');
      }
    }

    notifyListeners();
  }
}

class ProfileImageProvider extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> updateProfileImage(String imagePath) async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var currentTime = DateTime.now().millisecondsSinceEpoch;
      var fileName = 'profile_image_$currentTime.jpg';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Api.updateFoto),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.files.add(
        await http.MultipartFile.fromPath(
          'foto',
          imagePath,
          filename: fileName,
        ),
      );

      var response = await request.send();

      isLoading(false);
    } catch (error) {
      print('Error updating profile image: $error');
      isLoading(false);
    }
  }

  Future<void> updateProfileKurirImage(String imagePath) async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('tokenKurir');

      var currentTime = DateTime.now().millisecondsSinceEpoch;
      var fileName = 'profile_image_$currentTime.jpg';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Api.updateFotoKurir),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.files.add(
        await http.MultipartFile.fromPath(
          'foto',
          imagePath,
          filename: fileName,
        ),
      );

      var response = await request.send();

      isLoading(false);
    } catch (error) {
      print('Error updating profile image: $error');
      isLoading(false);
    }
  }
}
