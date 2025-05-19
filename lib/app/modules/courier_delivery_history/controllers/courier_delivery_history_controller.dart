import 'dart:convert';
import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:dikantin_app_rebuild/app/providers/db_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CourierDeliveryHistoryController extends GetxController {
  final baseURL = AppUrl.baseURL;
  var isLoading = true.obs;
  var deliveryHistory = [].obs;

  @override
  void onInit() {
    super.onInit();
    getDeliveryHistory();
  }

  Future<void> getDeliveryHistory() async {
    try {
      isLoading(true);
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.get(
        Uri.parse('$baseURL/shipping/history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Request URL: ${Uri.parse('$baseURL/shipping/history')}");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          deliveryHistory.value = data['data'];
        }
      } else {
        print("Error response: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error getting delivery history: $e");
    } finally {
      isLoading(false);
    }
  }

  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
} 