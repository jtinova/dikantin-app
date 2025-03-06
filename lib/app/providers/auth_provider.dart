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

class AuthenticationProvider extends ChangeNotifier {
  final baseURL = AppUrl.baseURL;

  String _resMessage = "";
  int? statusCode;

  String get resMessage => _resMessage;

  void registerUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    BuildContext? context,
  }) async {
    EasyLoading.show(status: 'Loading...');
    notifyListeners();

    String url = "$baseURL/register";

    final body = {
      "full_name": fullName,
      "email": email,
      "phone_number": phoneNumber,
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
        notifyListeners();

        EasyLoading.dismiss();

        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        final res = json.decode(req.body);
        print(res);

        if (res.containsKey("errors")) {
          Map<String, dynamic> errors = res["errors"];
          String errorMessage = "";
          if (errors.containsKey("email")) {
            errorMessage += "${errors["email"][0]}\n";
          }
          if (errors.containsKey("phone_number")) {
            errorMessage += "${errors["phone_number"][0]}\n";
          }
          _resMessage = errorMessage.trim();
          notifyListeners();
        } else {
          _resMessage = res["message"];
          notifyListeners();
        }

        EasyLoading.dismiss();
      }
    } on SocketException catch (_) {
      statusCode = 0;
      _resMessage = "Koneksi Internet Tidak Tersedia";
      EasyLoading.dismiss();
    } catch (e) {
      statusCode = null;
      _resMessage = "Mohon Coba Lagi";
      notifyListeners();
      EasyLoading.dismiss();

      print(e);
    }
  }

  void loginUser({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    EasyLoading.show(status: 'Loading...');
    notifyListeners();

    String url = "$baseURL/login";

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

      // Store Status Code
      statusCode = req.statusCode;

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(req.body);

        _resMessage = res["message"];
        notifyListeners();

        // Save Token Navigate To Dashboard
        final token = res["data"]["access_token"];

        await DatabaseProvider().saveToken(token);

        EasyLoading.dismiss();

        Get.offAllNamed(Routes.NAVIGATION);
      } else {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
        notifyListeners();

        EasyLoading.dismiss();
      }
    } on SocketException catch (_) {
      statusCode = 0;
      _resMessage = "Koneksi Internet Tidak Tersedia";
      EasyLoading.dismiss();
    } catch (e) {
      statusCode = null;
      _resMessage = "Mohon Coba Lagi";
      notifyListeners();
      EasyLoading.dismiss();

      print(e);
    }
  }

  void sendEmailOTP({
    required String email,
    BuildContext? context,
  }) async {
    EasyLoading.show(status: 'Loading...');
    notifyListeners();

    String url = "$baseURL/send-reset-password";

    final body = {
      "email": email,
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

      // Store Status Code
      statusCode = req.statusCode;

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
        notifyListeners();

        EasyLoading.dismiss();

        Get.offAllNamed(Routes.CODE_OTP, arguments: {'email': email});
      } else {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
        notifyListeners();

        EasyLoading.dismiss();
      }
    } on SocketException catch (_) {
      statusCode = 0;
      _resMessage = "Koneksi Internet Tidak Tersedia";
      EasyLoading.dismiss();
    } catch (e) {
      statusCode = null;
      _resMessage = "Mohon Coba Lagi";
      notifyListeners();
      EasyLoading.dismiss();

      print(e);
    }
  }

  void verifyCodeOTP({
    required String email,
    required String otp,
    BuildContext? context,
  }) async {
    EasyLoading.show(status: 'Loading...');
    notifyListeners();

    String url = "$baseURL/verify-otp";

    final body = {
      "email": email,
      "kode_otp": otp,
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

      // Store Status Code
      statusCode = req.statusCode;

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
        notifyListeners();

        EasyLoading.dismiss();

        Get.offAllNamed(Routes.RESET_PASSWORD, arguments: {'email': email});
      } else {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
        notifyListeners();

        EasyLoading.dismiss();
      }
    } on SocketException catch (_) {
      statusCode = 0;
      _resMessage = "Koneksi Internet Tidak Tersedia";
      EasyLoading.dismiss();
    } catch (e) {
      statusCode = null;
      _resMessage = "Mohon Coba Lagi";
      notifyListeners();
      EasyLoading.dismiss();

      print(e);
    }
  }

  void resendEmailOTP({
    required String email,
    BuildContext? context,
  }) async {
    EasyLoading.show(status: 'Loading...');
    notifyListeners();

    String url = "$baseURL/send-reset-password";

    final body = {
      "email": email,
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

      // Store Status Code
      statusCode = req.statusCode;

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
        notifyListeners();

        EasyLoading.dismiss();
      } else {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
        notifyListeners();

        EasyLoading.dismiss();
      }
    } on SocketException catch (_) {
      statusCode = 0;
      _resMessage = "Koneksi Internet Tidak Tersedia";
      EasyLoading.dismiss();
    } catch (e) {
      statusCode = null;
      _resMessage = "Mohon Coba Lagi";
      notifyListeners();
      EasyLoading.dismiss();

      print(e);
    }
  }

  void resetPassword({
    required String email,
    required String newPassword,
    BuildContext? context,
  }) async {
    EasyLoading.show(status: 'Loading...');
    notifyListeners();

    String url = "$baseURL/reset-password";

    final body = {
      "email": email,
      "new_password": newPassword,
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

      // Store Status Code
      statusCode = req.statusCode;

      if (req.statusCode == 200) {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
        notifyListeners();

        EasyLoading.dismiss();

        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
        notifyListeners();

        EasyLoading.dismiss();
      }
    } on SocketException catch (_) {
      statusCode = 0;
      _resMessage = "Koneksi Internet Tidak Tersedia";
      EasyLoading.dismiss();
    } catch (e) {
      statusCode = null;
      _resMessage = "Mohon Coba Lagi";
      notifyListeners();
      EasyLoading.dismiss();

      print(e);
    }
  }

  void logoutUser() async {
    EasyLoading.show(status: 'Loading...');
    notifyListeners();

    String url = "$baseURL/logout";

    try {
      String? token = await DatabaseProvider().getToken();

      if (token == null) {
        _resMessage = "Token tidak ditemukan";
        notifyListeners();

        EasyLoading.dismiss();
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
        notifyListeners();

        EasyLoading.dismiss();

        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        final res = json.decode(req.body);

        print(res);

        _resMessage = res["message"];
        notifyListeners();

        EasyLoading.dismiss();
      }
    } on SocketException catch (_) {
      statusCode = 0;
      _resMessage = "Koneksi Internet Tidak Tersedia";
      EasyLoading.dismiss();
    } catch (e) {
      statusCode = null;
      _resMessage = "Terjadi Kesalahan, Coba Lagi";
      notifyListeners();
      EasyLoading.dismiss();

      print(e);
    }
  }

  void clear() {
    _resMessage = "";
    statusCode == null;

    notifyListeners();
  }
}
