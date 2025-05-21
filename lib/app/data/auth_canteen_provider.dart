// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:dikantin_app_rebuild/app/routes/app_pages.dart';
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

  void loginCanteen({
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

  void logoutCanteen() async {
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

  
  void clear() {
    _resMessage = "";
    statusCode == null;

    notifyListeners();
  }
}
