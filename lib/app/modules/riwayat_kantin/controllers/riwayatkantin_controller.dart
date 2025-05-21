import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dikantin_app_rebuild/app/data/db_provider.dart';
import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:flutter/material.dart';
import 'package:dikantin_app_rebuild/app/models/history_canteen.dart';
import 'dart:convert';

class RiwayatKantinController extends GetxController {
  RxList<HistoryModel> daftarMenu = <HistoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void refreshData() {
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      final token = await DatabaseProvider().getToken();
      final response = await http.get(
        Uri.parse(AppUrl.historyCanteen),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final List data = result['data'];

        final histories = data.map((json) => HistoryModel.fromJson(json)).toList();
        daftarMenu.assignAll(histories);
      } else {
        print("Gagal mengambil riwayat transaksi: ${response.body}");
      }
    } catch (e) {
      print("Error fetchHistory: $e");
    }
  }
}