// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../service/api_client_service.dart';
import '../../../service/api_service.dart';
import '../../../models/user.dart';

class ProfileController extends GetxController {
  var users = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    EasyLoading.show(status: 'Loading...');

    try {
      await Future.wait([
        getDetailUser(),
      ]);
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> refreshAll() async {
    await loadInitialData();
  }

  Future<void> getDetailUser() async {
    String url = AppUrl.detailUserProfile;

    try {
      final req = await ApiClient.get(url);

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
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          icon: const Icon(
            CupertinoIcons.info_circle,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserData({
    required String fullName,
    required String phoneNumber,
    required String buildingId,
    required String detailAddress,
    BuildContext? context,
  }) async {
    EasyLoading.show(status: 'Loading...');

    String url = AppUrl.updateUserData;

    final body = {
      "full_name": fullName,
      "phone_number": phoneNumber,
      "building_id": buildingId,
      "detail_address": detailAddress,
    };
    print(body);

    try {
      final req = await ApiClient.put(url, body: body);

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
          borderWidth: 5.w,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
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
            borderWidth: 5.w,
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 20.h,
            ),
            icon: const Icon(
              CupertinoIcons.info_circle,
              color: Colors.white,
            ),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Informasi ",
        "Mohon Coba Lagi",
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        borderWidth: 5.w,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        icon: const Icon(
          CupertinoIcons.info_circle,
        ),
      );

      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
