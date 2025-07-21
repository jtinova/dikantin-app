import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NetworkProvider extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  final RxBool isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();

    ever(isOnline, (bool isOnlineValue) {
      if (!isOnlineValue) {
        _showOfflineSnackbar();
      } else {
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();

          Get.snackbar(
            "Informasi ",
            "Koneksi Internet Tersedia",
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
              CupertinoIcons.wifi,
              color: Colors.white,
            ),
          );
        }
      }
    });

    _connectivity.checkConnectivity().then(_updateAndVerifyConnectionStatus);
    _subscription = _connectivity.onConnectivityChanged
        .listen(_updateAndVerifyConnectionStatus);
  }

  Future<bool> _hasActiveInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> _updateAndVerifyConnectionStatus(
      List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.none)) {
      isOnline.value = false;
    } else {
      final hasInternet = await _hasActiveInternetConnection();
      isOnline.value = hasInternet;
    }
  }

  void _showOfflineSnackbar() {
    Get.snackbar(
      "Informasi ",
      "Koneksi Internet Tidak Tersedia",
      isDismissible: false,
      animationDuration: const Duration(milliseconds: 200),
      duration: const Duration(days: 1),
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      borderWidth: 5.w,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      icon: const Icon(
        CupertinoIcons.wifi_slash,
        color: Colors.white,
      ),
    );
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
