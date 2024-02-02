import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:dikantin/app/data/providers/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/version_model.dart';
import '../../../data/providers/menu_provider.dart';

class NavigationController extends GetxController {
  //TODO: Implement NavigationController
  final menuP = MenuProvider().obs;
  Rx<Version> version = Version().obs;
  final isLoading = false.obs; // Tambahkan isLoading

  var tabIndex = 0;
  @override
  void onInit() {
    super.onInit();
    checkToken();
    getVersion();
    // checkVersion();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Tambahkan metode untuk memperbarui currentScreen
  void updateCurrentScreen(int index) {
    tabIndex = index;
    update();
  }

  Future<void> getVersion() async {
    try {
      isLoading(true);

      // Call the getCustomer method from CustomerProvider
      Version result = await menuP.value.checkVersion();

      // Update the customer data
      version(result);
      int? versionNumber = result.data?.versionNumber;
      String koneksi = Api.koneksi;
      String convert = 'v${versionNumber}';
      print(convert);
      if (!koneksi.contains(convert)) {
        print(' UPDATE');
        _showLogoutDialogVersion();
      } else {
        print('Ga UPDATE');
        // _showLogoutDialogVersion();
      }

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching dataprofile: $error');
    }
  }

  // void checkVersion() async {
  //   final data = await version.value.data?.versionNumber;
  //   String convert = 'v${data}';
  //   String koneksi = Api.koneksi;

  //   if (!koneksi.contains(convert)) {
  //     // Get.defaultDialog(
  //     //   title: "Peringatan",
  //     //   content: Column(
  //     //     mainAxisSize: MainAxisSize.min,
  //     //     children: [Text('Update aplikasi anda')],
  //     //   ),
  //     //   barrierDismissible: false,
  //     //   actions: [
  //     //     ElevatedButton(
  //     //       onPressed: () async {
  //     //         // Replace the package name with your app's package name
  //     //         const String packageName = 'com.tefa.dikatin';

  //     //         final AndroidIntent intent = AndroidIntent(
  //     //           action: 'action_view',
  //     //           package: packageName,
  //     //           data:
  //     //               'https://play.google.com/store/apps/details?id=$packageName',
  //     //         );

  //     //         // Use try-catch to handle errors when launching the intent
  //     //         try {
  //     //           await intent.launch();
  //     //         } catch (e) {
  //     //           print('Error launching Play Store intent: $e');
  //     //         }
  //     //       },
  //     //       child: Text('Ok'),
  //     //     ),
  //     //   ],
  //     // );
  //     // _showLogoutDialog();
  //     print(convert);

  //     print('update');
  //   } else {
  //     print('Gausah update');
  //   }
  // }

  Future<void> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id_customer = prefs.getString('id_customer');

    try {
      final response = await http.post(
        Uri.parse(Api.getToken),
        body: {
          'id_customer':
              id_customer, // Ganti dengan informasi unik dari pengguna
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final newToken = jsonResponse['data']['token'];

        // Bandingkan token yang ada dengan newToken
        String? existingToken = prefs.getString('token');
        if (existingToken != newToken) {
          // Token tidak sesuai, tampilkan dialog untuk login ulang
          _showLogoutDialog();
        } else {
          // Token sesuai, tidak perlu tindakan tambahan
          print('Token masih valid.');
        }
      } else {
        print('Gagal ambil data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> logout() async {
    // Hapus data dari SharedPreferences
    await clearSharedPreferences();

    // Navigasi ke halaman login
    Get.offAllNamed('/login');
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys().toList();

    for (String key in keys) {
      if (key != 'tokenfcm') {
        prefs.remove(key);
      }
    }
  }

  void _showLogoutDialog() {
    // Tampilkan dialog atau notifikasi untuk login ulang
    Get.defaultDialog(
      title: 'Sesi Berakhir',
      middleText:
          'Sesi Anda telah berakhir. Mohon tekan ok untuk login kembali',
      confirm: ElevatedButton(
        onPressed: () {
          // Lakukan logout atau aksi lainnya
          logout();
          Get.offAllNamed('/login');
        },
        child: Text('OK'),
      ),
    );
  }

  void _showLogoutDialogVersion() {
    // Tampilkan dialog atau notifikasi untuk login ulang
    Get.defaultDialog(
      title: "Peringatan",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text('Ayo Update Aplikasi Kamu!')],
      ),
      barrierDismissible: false,
      actions: [
        ElevatedButton(
          onPressed: () async {
            // Replace the package name with your app's package name
            const String packageName = 'com.tefa.dikatin';

            final AndroidIntent intent = AndroidIntent(
              action: 'action_view',
              package: packageName,
              data:
                  'https://play.google.com/store/apps/details?id=$packageName',
            );
            Get.back();
            // Use try-catch to handle errors when launching the intent
            try {
              await intent.launch();
            } catch (e) {
              print('Error launching Play Store intent: $e');
            }
          },
          child: Text('Ok'),
        ),
      ],
    );
  }
}
