// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/api.dart';
import '../../../models/user.dart';
import '../../../data/db_provider.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  var users = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    getDetailUser();
  }

  Future<void> getDetailUser() async {
    isLoading.value = true;

    String url = AppUrl.detailUserProfile;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        users.value = User.fromJson(res["data"]);
      } else {
        final res = json.decode(req.body);

        print(res);

        Get.snackbar(
          "Informasi ",
          "Terjadi Kesalahan",
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          borderWidth: 5.0,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserData({
    required String fullName,
    required String phoneNumber,
    required String buildingId,
    required String detailAddress,
    BuildContext? context,
  }) async {
    isLoading.value = true;

    String url = AppUrl.updateUserData;
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;

      Get.snackbar(
        "Informasi ",
        "Token Tidak Ditemukan",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      return;
    }

    final body = {
      "full_name": fullName,
      "phone_number": phoneNumber,
      "building_id": buildingId,
      "detail_address": detailAddress,
    };
    print(body);

    try {
      http.Response req = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        users.value = User.fromJson(res["data"]);

        Get.snackbar(
          "Informasi",
          res["message"],
          animationDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderWidth: 5.0,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(
            CupertinoIcons.info_circle,
            color: Colors.white,
          ),
        );
      } else {
        final res = json.decode(req.body);

        print(res);

        if (res["errors"] != null) {
          String errorMessage = "";

          res["errors"].forEach((key, value) {
            errorMessage += "${value.join("\n")}\n";
          });

          Get.snackbar(
            "Informasi",
            errorMessage.trim(),
            animationDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1650),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderWidth: 5.0,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(20.0),
            icon: const Icon(
              CupertinoIcons.info_circle,
              color: Colors.white,
            ),
          );
        }
      }
    } on SocketException catch (_) {
      Get.snackbar(
        "Informasi ",
        "Koneksi Internet Tidak Tersedia",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.0,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
