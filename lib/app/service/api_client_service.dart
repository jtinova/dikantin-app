// lib/app/service/api_client.dart

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:dikantin_app_rebuild/app/routes/app_pages.dart';
import 'package:dikantin_app_rebuild/app/service/auth_service.dart';
import 'package:dikantin_app_rebuild/app/service/db_service.dart';

class ApiClient {
  static final Set<String> _activeRequests = {};

  static Future<http.Response> get(String url) async {
    if (_activeRequests.contains(url)) {
      return http.Response(
          json.encode({'message': 'Request in progress'}), 429);
    }

    _activeRequests.add(url);

    try {
      final token = await DatabaseProvider().getToken();
      if (!_isTokenValid(token)) {
        _triggerLogout();
        return http.Response(
            json.encode({'message': 'Token tidak valid'}), 401);
      }
      final response =
          await http.get(Uri.parse(url), headers: _getHeaders(token));
      _handleResponse(response);
      return response;
    } finally {
      _activeRequests.remove(url);
    }
  }

  static Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    if (_activeRequests.contains(url)) {
      return http.Response(
          json.encode({'message': 'Request in progress'}), 429);
    }

    _activeRequests.add(url);

    try {
      final token = await DatabaseProvider().getToken();
      if (!_isTokenValid(token)) {
        _triggerLogout();
        return http.Response(
            json.encode({'message': 'Token tidak valid'}), 401);
      }
      final response = await http.post(
        Uri.parse(url),
        headers: _getHeaders(token),
        body: json.encode(body),
      );
      _handleResponse(response);
      return response;
    } finally {
      _activeRequests.remove(url);
    }
  }

  static Future<http.Response> put(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    if (_activeRequests.contains(url)) {
      return http.Response(
          json.encode({'message': 'Request in progress'}), 429);
    }

    _activeRequests.add(url);
    try {
      final token = await DatabaseProvider().getToken();
      if (!_isTokenValid(token)) {
        _triggerLogout();
        return http.Response(
            json.encode({'message': 'Token tidak valid'}), 401);
      }
      final response = await http.put(
        Uri.parse(url),
        headers: _getHeaders(token),
        body: json.encode(body),
      );
      _handleResponse(response);
      return response;
    } finally {
      _activeRequests.remove(url);
    }
  }

  static Future<http.Response> patch(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    if (_activeRequests.contains(url)) {
      return http.Response(
          json.encode({'message': 'Request in progress'}), 429);
    }

    _activeRequests.add(url);

    try {
      final token = await DatabaseProvider().getToken();
      if (!_isTokenValid(token)) {
        _triggerLogout();
        return http.Response(
            json.encode({'message': 'Token tidak valid'}), 401);
      }
      final response = await http.patch(
        Uri.parse(url),
        headers: _getHeaders(token),
        body: json.encode(body),
      );
      _handleResponse(response);
      return response;
    } finally {
      _activeRequests.remove(url);
    }
  }

  static Future<http.Response> delete(String url) async {
    if (_activeRequests.contains(url)) {
      return http.Response(
          json.encode({'message': 'Request in progress'}), 429);
    }

    _activeRequests.add(url);

    try {
      final token = await DatabaseProvider().getToken();
      if (!_isTokenValid(token)) {
        _triggerLogout();
        return http.Response(
            json.encode({'message': 'Token tidak valid'}), 401);
      }
      final response =
          await http.delete(Uri.parse(url), headers: _getHeaders(token));
      _handleResponse(response);
      return response;
    } finally {
      _activeRequests.remove(url);
    }
  }

  static Map<String, String> _getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static bool _isTokenValid(String? token) {
    return token != null && token.isNotEmpty;
  }

  static void _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      _triggerLogout();
    }
  }

  static void _triggerLogout() {
    if (Get.currentRoute != Routes.SIGN_IN) {
      if (Get.context != null) {
        final authProvider =
            Provider.of<AuthenticationProvider>(Get.context!, listen: false);
        authProvider.logoutUser();
        Get.snackbar(
          "Sesi Berakhir",
          "Sesi Anda telah berakhir, silakan masuk kembali.",
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
    }
  }
}
