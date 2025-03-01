import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String _token = "";

  String get token => _token;

  void saveToken(String token) async {
    SharedPreferences value = await _pref;

    value.setString("token", token);
  }

  Future<String> getToken() async {
    SharedPreferences value = await _pref;

    if (value.containsKey("token")) {
      String data = value.getString("token")!;
      _token = data;

      notifyListeners();
      return "";
    } else {
      _token = "";

      notifyListeners();
      return "";
    }
  }

  void logout() async {
    final value = await _pref;

    value.clear();
  }
}
