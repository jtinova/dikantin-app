// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dikantin_partner/app/data/api.dart';
import 'package:dikantin_partner/app/routes/app_pages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'db_provider.dart';

class AuthCanteenProvider extends ChangeNotifier {
  String _resMessage = "";
  int? statusCode;

  String get resMessage => _resMessage;

  Future<void> loginCanteen({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    EasyLoading.show(status: 'Loading...');
    notifyListeners();

    String url = AppUrl.signinCanteen;

    final body = {
      "email": email,
      "password": password,
    };
    print(body);

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      statusCode = req.statusCode;

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(req.body);

        _resMessage = res["message"];
        final token = res["data"]["access_token"];

        await DatabaseProvider().saveToken(token);
        Get.offAllNamed(Routes.NAVIGATION);

        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          storeFCMToken(fcmToken: fcmToken, role: 'Kantin');
          print("FCM Token: $fcmToken");
        }
      } else {
        final res = json.decode(req.body);

        print(res);
        _resMessage = res["message"];
      }

      notifyListeners();
    } on SocketException catch (_) {
      statusCode = 0;
      _resMessage = "Koneksi Internet Tidak Tersedia";
    } catch (e) {
      statusCode = null;
      _resMessage = "Mohon Coba Lagi";

      print(e);
    } finally {
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> logoutCanteen() async {
    EasyLoading.show(status: 'Loading...');
    notifyListeners();

    String url = AppUrl.signout;

    try {
      String? token = await DatabaseProvider().getToken();

      if (token == null) {
        _resMessage = "Token tidak ditemukan";
        return;
      }

      http.Response req = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Store Status Code
      statusCode = req.statusCode;

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        await DatabaseProvider().clearToken();

        _resMessage = "Logout Berhasil";

        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
      }

      notifyListeners();
    } on SocketException catch (_) {
      statusCode = 0;
      _resMessage = "Koneksi Internet Tidak Tersedia";
    } catch (e) {
      statusCode = null;
      _resMessage = "Terjadi Kesalahan, Coba Lagi";

      print(e);
    } finally {
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> storeFCMToken({
    required String fcmToken,
    required String role,
  }) async {
    String url = AppUrl.storeFCMToken;

    final token = await DatabaseProvider().getToken();
    final body = {
      "fcm_token": fcmToken,
      "role": role,
    };

    print("Sending FCM Token with body: $body");

    try {
      http.Response req = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        print("FCM Token stored successfully: $res");
      } else {
        final res = json.decode(req.body);
        print("Failed to store FCM Token: $res");
      }
    } catch (e) {
      print("Error storing FCM Token: $e");
    }
  }

  void clear() {
    _resMessage = "";
    statusCode == null;

    notifyListeners();
  }
}
