// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dikantin_partner/app/data/db_provider.dart';
import 'package:dikantin_partner/app/data/api.dart';
import 'package:dikantin_partner/app/models/history_canteen.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

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

        final histories =
            data.map((json) => HistoryModel.fromJson(json)).toList();
        daftarMenu.assignAll(histories);
      } else {
        print("Gagal mengambil riwayat transaksi: ${response.body}");
      }
    } catch (e) {
      print("Error fetchHistory: $e");
    }
  }

  String formatRupiah(int price) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    return formatCurrency.format(price);
  }
}
