// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dikantin_app_rebuild/app/data/db_provider.dart';
import 'package:flutter/material.dart';

class CourierProfileController extends GetxController {
  final baseURL = AppUrl.baseURL;
  
  var isLoading = true.obs;
  var courierData = {}.obs;
  var withdrawalHistory = [].obs;
  var isBalanceVisible = false.obs;
  var withdrawalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    courierData.value = {
      'full_name': '',
      'phone_number': '',
      'email': '',
      'total_balance': 0,
      'today_earnings': 0,
      'pending_deliveries': 0,
      'delivered_deliveries': 0,
    };
    
    getProfile();
    getWithdrawalHistory();
    getDeliveryStats();
  }

  Future<void> getProfile() async {
    try {
      isLoading(true);
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.get(
        Uri.parse(AppUrl.courierProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          courierData.value = data['data'];
          // Hitung jumlah pesanan 'pending' dan 'delivered' dari data yang diambil
          int pendingCount = 0;
          int deliveredCount = 0;
          if (data['data']['orders'] != null) {
            for (var order in data['data']['orders']) {
              if (order['status'] == 'pending') {
                pendingCount++;
              } else if (order['status'] == 'delivered') {
                deliveredCount++;
              }
            }
          }
          // Update nilai 'pending_deliveries' dan 'delivered_deliveries' di courierData
          courierData['pending_deliveries'] = pendingCount;
          courierData['delivered_deliveries'] = deliveredCount;
        }
      }
    } catch (e) {
      print("Error getting profile: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> getDeliveryStats() async {
    try {
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.get(
        Uri.parse(AppUrl.shippingStats),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          var updatedData = Map<String, dynamic>.from(courierData);
          updatedData['pending_deliveries'] = data['data']['pending_count'] ?? 0;
          updatedData['delivered_deliveries'] = data['data']['delivered_count'] ?? 0;
          updatedData['today_earnings'] = data['data']['today_earnings'] ?? 0;
          courierData.value = updatedData;
        }
      }
    } catch (e) {
      print("Error getting delivery stats: $e");
    }
  }

  Future<void> getWithdrawalHistory() async {
    try {
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.get(
        Uri.parse(AppUrl.withDrawlHistory),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          withdrawalHistory.value = data['data'];
        }
      }
    } catch (e) {
      print("Error getting withdrawal history: $e");
    }
  }
  
  Future<void> withdrawAllBalance() async {
    try {
      isLoading(true);
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.post(
        Uri.parse(AppUrl.withDrawlBalance),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'withdraw_all': true
        }),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        if (data['status'] == 'success') {
          // Update saldo kurir
          var updatedData = Map<String, dynamic>.from(courierData);
          updatedData['total_balance'] = data['data']['current_balance'];
          courierData.value = updatedData;
          
          // Refresh riwayat penarikan
          await getWithdrawalHistory();
          
          Get.snackbar(
            'Sukses',
            'Penarikan dana berhasil dilakukan',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Terjadi kesalahan saat menarik dana',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Error withdrawing earnings: $e");
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> withdrawPartialBalance(double amount) async {
    try {
      if (amount <= 0) {
        Get.snackbar(
          'Gagal',
          'Jumlah penarikan harus lebih dari 0',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      final totalBalance = double.tryParse(courierData['total_balance']?.toString() ?? '0') ?? 0;
      
      if (amount > totalBalance) {
        Get.snackbar(
          'Gagal',
          'Saldo tidak mencukupi untuk penarikan ini',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      isLoading(true);
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.post(
        Uri.parse(AppUrl.withDrawlBalance),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount
        }),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        if (data['status'] == 'success') {
          // Update saldo kurir
          var updatedData = Map<String, dynamic>.from(courierData);
          updatedData['total_balance'] = data['data']['current_balance'];
          courierData.value = updatedData;
          
          // Refresh riwayat penarikan
          await getWithdrawalHistory();
          
          Get.snackbar(
            'Sukses',
            'Penarikan dana berhasil dilakukan',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Terjadi kesalahan saat menarik dana',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Error withdrawing earnings: $e");
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> withdrawTodayEarnings() async {
    await withdrawAllBalance();
  }

  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
  
  double? parseCurrency(String value) {
    if (value.isEmpty) return 0;
    
    // Hapus 'Rp ', spasi, dan titik ribuan
    String cleaned = value.replaceAll('Rp ', '').replaceAll('.', '').replaceAll(' ', '');
    
    return double.tryParse(cleaned);
  }
}
