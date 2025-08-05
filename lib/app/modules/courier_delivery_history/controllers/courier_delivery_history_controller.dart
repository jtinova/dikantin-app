// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dikantin_app_rebuild/app/service/api_service.dart';
import 'package:get/get.dart';

import '../../../service/api_client_service.dart';

class CourierDeliveryHistoryController extends GetxController {
  final baseURL = AppUrl.baseURLAPI;
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
      
      final response = await ApiClient.get(AppUrl.shippingHistory);

      print("Request URL: ${Uri.parse(AppUrl.shippingHistory)}");
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