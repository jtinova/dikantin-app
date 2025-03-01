// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:dikantin_app_rebuild/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'db_provider.dart';

class AuthenticationProvider extends ChangeNotifier {
  final baseURL = AppUrl.baseURL;

  bool _isLoading = false;
  String _resMessage = "";
  int? _responseData;
  int? statusCode;

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  int? get responseData => _responseData;

  void loginUser({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    _isLoading = true;
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

        _isLoading = true;
        _resMessage = res["message"];

        notifyListeners();

        // Save Token Navigate To Dashboard
        final token = res["data"]["access_token"];

        DatabaseProvider().saveToken(token);

        Get.offAllNamed(Routes.NAVIGATION);
      } else {
        final res = json.decode(req.body);

        print(res);

        _isLoading = false;
        _resMessage = res["message"];

        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Koneksi Internet Tidak Tersedia";
    } catch (e) {
      _isLoading = false;
      _resMessage = "Mohon Coba Lagi";
      notifyListeners();

      print(e);
    }
  }

  void clear() {
    _isLoading = false;
    _resMessage = "";
    statusCode == null;

    notifyListeners();
  }
}
