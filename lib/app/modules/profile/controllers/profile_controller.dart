// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/api.dart';
import '../../../models/user.dart';
import '../../../providers/db_provider.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  var users = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    getDetailUser();
  }

  Future<void> getDetailUser() async {
    isLoading.value = true;

    String url = "${AppUrl.baseURL}/user";
    String? token = await DatabaseProvider().getToken();

    if (token == null) {
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        users.value = User.fromJson(data["data"]);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
