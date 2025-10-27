// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dikantin_partner/app/data/db_provider.dart';
import 'package:dikantin_partner/app/models/history_canteen.dart';
import 'package:dikantin_partner/app/data/api.dart';
import 'package:intl/intl.dart';

class HomeKantinController extends GetxController {
  RxList<HistoryModel> daftarMenu = <HistoryModel>[].obs;
  var canteenName = 'Kantin'.obs;
  var totalIncomeToday = 0.obs;
  var totalIncomeMonth = 0.obs;
  var totalOrderServed = 0.obs;
  var totalOrderDone = 0.obs;
  var selectedItem = 'Tutup'.obs;

  @override
  void onInit() {
    super.onInit();
    canteenProfile();
    incomeToday();
    incomeMonth();
    orderServed();
    orderDone();
    fetchHistory();
  }

  void refreshData() {
    canteenProfile();
    incomeToday();
    incomeMonth();
    orderServed();
    orderDone();
    fetchHistory();
  }

  Future<void> canteenProfile() async {
    final token = await DatabaseProvider().getToken();

    try {
      final response = await http.get(
        Uri.parse(AppUrl.profilCanteen),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final canteenData = data['data'];
        print(data);

        canteenName.value = data['data']['name'];

        String backendStatus = canteenData['status'] ?? 'close';

        if (backendStatus == 'open') {
          selectedItem.value = 'Buka';
        } else {
          selectedItem.value = 'Tutup';
        }
      } else {
        print("Gagal ambil name: ${response.body}");
        selectedItem.value = 'Tutup';
      }
    } catch (e) {
      print("Error canteenProfile: $e");
      selectedItem.value = 'Tutup';
    }
  }

  Future<void> updateCanteenStatus(String status) async {
    final token = await DatabaseProvider().getToken();
    final url = Uri.parse(AppUrl.statusCanteen);

    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("Berhasil ubah status: ${data['message']}");
      } else {
        Get.snackbar("Error", data['message'] ?? 'Gagal ubah status');
      }
    } catch (e) {
      print("Error updateCanteenStatus: $e");
      Get.snackbar("Error", "Terjadi kesalahan");
    }
  }

  Future<void> incomeToday() async {
    final token = await DatabaseProvider().getToken();

    try {
      final response = await http.get(
        Uri.parse(AppUrl.incomeToday),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        totalIncomeToday.value = data['data']['total_income_today'];
      } else {
        print("Gagal ambil total income today: ${response.body}");
      }
    } catch (e) {
      print("Error incomeToday: $e");
    }
  }

  Future<void> incomeMonth() async {
    final token = await DatabaseProvider().getToken();

    try {
      final response = await http.get(
        Uri.parse(AppUrl.incomeMonth),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        totalIncomeMonth.value = data['data']['balance'];
      } else {
        print("Gagal ambil total income month: ${response.body}");
      }
    } catch (e) {
      print("Error incomeMonth: $e");
    }
  }

  Future<void> orderServed() async {
    final token = await DatabaseProvider().getToken();

    try {
      final response = await http.get(
        Uri.parse(AppUrl.orderServed),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        totalOrderServed.value = data['data']['total_served'];
      } else {
        print("Gagal ambil total served: ${response.body}");
      }
    } catch (e) {
      print("Error orderServed: $e");
    }
  }

  Future<void> orderDone() async {
    final token = await DatabaseProvider().getToken();

    try {
      final response = await http.get(
        Uri.parse(AppUrl.orderDone),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        totalOrderDone.value = data['data']['total_done'];
      } else {
        print("Gagal ambil total done: ${response.body}");
      }
    } catch (e) {
      print("Error orderDone: $e");
    }
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
