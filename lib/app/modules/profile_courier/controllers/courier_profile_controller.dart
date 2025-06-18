// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dikantin_app_rebuild/app/data/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dikantin_app_rebuild/app/data/db_provider.dart';
import 'package:flutter/material.dart';

class CourierProfileController extends GetxController {
  final baseURL = AppUrl.baseURLAPI;
  
  var isLoading = true.obs;
  var courierData = {}.obs;
  var withdrawalHistory = [].obs;
  var isBalanceVisible = false.obs;
  var withdrawalAmount = 0.0.obs;
  var orderList = [].obs;
  var pendingOrders = [].obs;
  var deliveredOrders = [].obs;

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
    
    initializeData();
  }

  Future<void> refreshData() async {
    print("=== Starting refreshData ===");
    await getProfile();
    await getDeliveryStats();
    await getPendingOrders();
    await getWithdrawalHistory();
    ensureDataConsistency();
    print("=== Finished refreshData ===");
  }

  Future<void> initializeData() async {
    print("=== Starting initializeData ===");
    await getProfile();
    await getDeliveryStats();
    await getPendingOrders();
    await getWithdrawalHistory();
    ensureDataConsistency();
    print("=== Finished initializeData ===");
  }

  Future<void> getProfile() async {
    try {
      print("=== Starting getProfile ===");
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
          print("Profile data today_earnings: ${data['data']['today_earnings']}");
          print("Profile data total_balance: ${data['data']['total_balance']}");
          
          // Jika total_balance 0 tapi today_earnings ada, maka update total_balance
          var profileData = Map<String, dynamic>.from(data['data']);
          final todayEarnings = double.tryParse(data['data']['today_earnings']?.toString() ?? '0') ?? 0;
          final totalBalance = double.tryParse(data['data']['total_balance']?.toString() ?? '0') ?? 0;
          
          if (totalBalance == 0 && todayEarnings > 0) {
            profileData['total_balance'] = todayEarnings;
            print("Updating total_balance to match today_earnings: $todayEarnings");
          }
          
          courierData.value = profileData;
          print("CourierData after getProfile - today_earnings: ${courierData['today_earnings']}");
          print("CourierData after getProfile - total_balance: ${courierData['total_balance']}");
          // Jangan update pending_deliveries dan delivered_deliveries di sini
          // karena akan diupdate oleh getPendingOrders()
        }
      }
      print("=== Finished getProfile ===");
    } catch (e) {
      print("Error getting profile: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> getDeliveryStats() async {
    try {
      print("=== Starting getDeliveryStats ===");
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
          print("Delivery stats today_earnings: ${data['data']['today_earnings']}");
          print("Delivery stats total_balance: ${data['data']['total_balance']}");
          
          // Hanya update jika data tidak null dan valid
          if (data['data']['today_earnings'] != null || data['data']['total_balance'] != null) {
            var updatedData = Map<String, dynamic>.from(courierData);
            
            // Update today_earnings hanya jika tidak null
            if (data['data']['today_earnings'] != null) {
              final statsTodayEarnings = double.tryParse(data['data']['today_earnings']?.toString() ?? '0') ?? 0;
              final currentTodayEarnings = double.tryParse(courierData['today_earnings']?.toString() ?? '0') ?? 0;
              
              print("Current today_earnings: $currentTodayEarnings");
              print("Stats today_earnings: $statsTodayEarnings");
              print("Current total_balance: ${courierData['total_balance']}");
              
              if (statsTodayEarnings > 0 || currentTodayEarnings == 0) {
                updatedData['today_earnings'] = statsTodayEarnings;
                print("Updating today_earnings to: $statsTodayEarnings");
              } else {
                print("Keeping current today_earnings: $currentTodayEarnings");
              }
            }
            
            // Update total_balance hanya jika tidak null
            if (data['data']['total_balance'] != null) {
              final statsTotalBalance = double.tryParse(data['data']['total_balance']?.toString() ?? '0') ?? 0;
              final currentTotalBalance = double.tryParse(courierData['total_balance']?.toString() ?? '0') ?? 0;
              
              if (statsTotalBalance > 0 || currentTotalBalance == 0) {
                updatedData['total_balance'] = statsTotalBalance;
                print("Updating total_balance to: $statsTotalBalance");
              } else {
                print("Keeping current total_balance: $currentTotalBalance");
              }
            }
            
            courierData.value = updatedData;
            print("Final courierData today_earnings: ${courierData['today_earnings']}");
            print("Final courierData total_balance: ${courierData['total_balance']}");
          } else {
            print("Skipping update because stats data is null");
          }
        }
      }
      print("=== Finished getDeliveryStats ===");
    } catch (e) {
      print("Error getting delivery stats: $e");
    }
  }

  Future<void> getWithdrawalHistory() async {
    try {
      print("=== Starting getWithdrawalHistory ===");
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
          print("Today earnings after getWithdrawalHistory: ${courierData['today_earnings']}");
        }
      }
      print("=== Finished getWithdrawalHistory ===");
    } catch (e) {
      print("Error getting withdrawal history: $e");
    }
  }
  
  Future<void> withdrawAllBalance() async {
    try {
      isLoading(true);
      
      // Pastikan data konsisten sebelum penarikan
      ensureDataConsistency();
      
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      // Ambil total balance yang sudah diupdate
      final totalBalance = double.tryParse(courierData['total_balance']?.toString() ?? '0') ?? 0;
      print("Withdrawing total balance: $totalBalance");
      
      if (totalBalance <= 0) {
        Get.snackbar(
          'Gagal',
          'Tidak ada saldo yang dapat ditarik',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
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
          updatedData['today_earnings'] = 0; // Reset today_earnings setelah penarikan
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
      
      // Pastikan data konsisten sebelum penarikan
      ensureDataConsistency();
      
      final totalBalance = double.tryParse(courierData['total_balance']?.toString() ?? '0') ?? 0;
      print("Available total balance: $totalBalance");
      print("Requested withdrawal amount: $amount");
      
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
          
          // Update today_earnings jika penarikan sama dengan today_earnings
          final currentTodayEarnings = double.tryParse(courierData['today_earnings']?.toString() ?? '0') ?? 0;
          if (amount >= currentTodayEarnings) {
            updatedData['today_earnings'] = 0; // Reset today_earnings jika semua ditarik
          }
          
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

  Future<void> getPendingOrders() async {
    try {
      print("=== Starting getPendingOrders ===");
      String? token = await DatabaseProvider().getToken();
      
      if (token == null) {
        print("Token tidak ditemukan");
        return;
      }

      final response = await http.get(
        Uri.parse('$baseURL/api/shipping/pending'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          orderList.value = data['data'];
          
          // Memisahkan order berdasarkan status
          pendingOrders.value = orderList.where((order) => order['status'] == 'pending').toList();
          deliveredOrders.value = orderList.where((order) => order['status'] == 'delivered').toList();
          
          // Update courierData dengan jumlah pesanan yang benar, tanpa menimpa data lain
          var updatedData = Map<String, dynamic>.from(courierData);
          updatedData['pending_deliveries'] = pendingOrders.length;
          updatedData['delivered_deliveries'] = deliveredOrders.length;
          
          // Pastikan total_balance konsisten dengan today_earnings
          final currentTodayEarnings = double.tryParse(courierData['today_earnings']?.toString() ?? '0') ?? 0;
          final currentTotalBalance = double.tryParse(courierData['total_balance']?.toString() ?? '0') ?? 0;
          
          if (currentTodayEarnings > 0 && currentTotalBalance == 0) {
            updatedData['total_balance'] = currentTodayEarnings;
            print("Updating total_balance to match today_earnings in getPendingOrders: $currentTodayEarnings");
          }
          
          courierData.value = updatedData;
          
          print("Pending orders count: ${pendingOrders.length}");
          print("Delivered orders count: ${deliveredOrders.length}");
          print("Today earnings after getPendingOrders: ${courierData['today_earnings']}");
          print("Total balance after getPendingOrders: ${courierData['total_balance']}");
        }
      }
      print("=== Finished getPendingOrders ===");
    } catch (e) {
      print("Error getting orders: $e");
    }
  }

  // Method untuk memastikan konsistensi data
  void ensureDataConsistency() {
    final todayEarnings = double.tryParse(courierData['today_earnings']?.toString() ?? '0') ?? 0;
    final totalBalance = double.tryParse(courierData['total_balance']?.toString() ?? '0') ?? 0;
    
    if (todayEarnings > 0 && totalBalance == 0) {
      var updatedData = Map<String, dynamic>.from(courierData);
      updatedData['total_balance'] = todayEarnings;
      courierData.value = updatedData;
      print("Ensuring consistency: total_balance updated to $todayEarnings");
    }
  }
}
