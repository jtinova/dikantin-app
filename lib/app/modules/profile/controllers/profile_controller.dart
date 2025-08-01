// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/api.dart';
import '../../../models/user.dart';
import '../../../data/db_provider.dart';

import 'package:dikantin_partner/app/models/canteen.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  var users = Rxn<Canteen>();

  @override
  void onInit() {
    super.onInit();
    // getDetailUser();
    getCanteenProfile();
  }

  Future<void> getCanteenProfile() async {
    isLoading.value = true;

    final token = await DatabaseProvider().getToken();
    final url = Uri.parse(AppUrl.profilCanteen);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'];

        users.value = Canteen.fromJson(data);
      } else {
        print("Gagal ambil profil kantin: ${response.statusCode}");
      }
    } catch (e) {
      print("Error getCanteenProfile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
