import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String _token = "";
  String _role = "";

  String get token => _token;
  String get role => _role;

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

  Future<void> saveRole(String role) async {
    SharedPreferences value = await _pref;
    await value.setString("role", role);
    _role = role;

    notifyListeners();
  }

  Future<String?> getRole() async {
    SharedPreferences value = await _pref;
    _role = value.getString("role") ?? "";
    notifyListeners();

    return _role.isNotEmpty ? _role : null;
  }

  Future<void> clearAuthData() async {
    SharedPreferences value = await _pref;
    await value.remove("token");
    await value.remove("role");
    _token = "";
    _role = "";

    notifyListeners();
  }
}
