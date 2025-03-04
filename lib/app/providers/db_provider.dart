import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String _token = "";

  String get token => _token;

  Future<void> saveToken(String token) async {
    SharedPreferences value = await _pref;
    await value.setString("token", token);
    _token = token;

    notifyListeners();
  }

  Future<String?> getToken() async {
    SharedPreferences value = await _pref;
    _token = value.getString("token") ?? "";

    notifyListeners();

    return _token.isNotEmpty ? _token : null;
  }

  Future<void> clearToken() async {
    SharedPreferences value = await _pref;
    await value.remove("token");
    _token = "";

    notifyListeners();
  }
}
