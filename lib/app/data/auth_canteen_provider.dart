// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:dikantin_app_rebuild/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../data/db_provider.dart';

class AuthCanteenProvider extends ChangeNotifier {
  final baseURL = AppUrl.baseURL;

  bool _isLoading = false;
  String _resMessage = "";
  int? statusCode;

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  // Fungsi login khusus canteen
  void loginCanteen({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    _isLoading = true;
    notifyListeners();

    String url = "$baseURL/canteen/login";

    final body = {
      "email": email,
      "password": password,
    };
    print("Login body: $body");

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      statusCode = req.statusCode;

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        print("Login Response: ${req.body}");

        _isLoading = false;
        _resMessage = res["message"];

        notifyListeners();

        final token = res["data"]["access_token"];
        await DatabaseProvider().saveToken(token);

        Get.offAllNamed(Routes.NAVIGATION);
      } else {
        final res = json.decode(req.body);
        print("Login Failed: $res");

        _isLoading = false;
        _resMessage = res["message"] ?? "Terjadi kesalahan. Coba lagi.";

        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Koneksi Internet Tidak Tersedia";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Terjadi Kesalahan. Coba Lagi";
      notifyListeners();

      print("Exception: $e");
    }
  }

  // Fungsi logout untuk canteen
  void logoutCanteen() async {
    _isLoading = true;
    notifyListeners();

    String url = "$baseURL/canteen/logout";

    try {
      String? token = await DatabaseProvider().getToken();

      if (token == null) {
        _isLoading = false;
        _resMessage = "Token tidak ditemukan";
        notifyListeners();
        return;
      }

      http.Response req = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      statusCode = req.statusCode;

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        print("Logout Berhasil: $res");

        await DatabaseProvider().clearToken();

        _isLoading = false;
        _resMessage = "Logout Berhasil";

        notifyListeners();

        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        final res = json.decode(req.body);
        print("Logout Gagal: $res");

        _isLoading = false;
        _resMessage = res["message"] ?? "Gagal Logout";

        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Koneksi Internet Tidak Tersedia";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Terjadi Kesalahan. Coba Lagi";
      notifyListeners();

      print("Exception: $e");
    }
  }

  void clear() {
    _isLoading = false;
    _resMessage = "";
    statusCode = null;
    notifyListeners();
  }
}
