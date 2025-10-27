// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:dikantin_partner/app/models/menu_kantin.dart';
import 'dart:convert';

import 'package:dikantin_partner/app/data/db_provider.dart';
import 'package:dikantin_partner/app/data/api.dart';
import 'package:intl/intl.dart';

class MenuKantinController extends GetxController {
  RxList<MenuModel> daftarMenu = <MenuModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenus();
  }

  void refreshData() {
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    final token = await DatabaseProvider().getToken();
    final url = Uri.parse(AppUrl.menuCanteen);

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
        final List<dynamic> data = jsonData['data'];

        daftarMenu.value =
            data.map((item) => MenuModel.fromJson(item)).toList();
      } else {
        print("Gagal ambil menu: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetchMenus: $e");
    }
  }

  Future<void> updateMenuStock(String id, int newStock) async {
    final token = await DatabaseProvider().getToken();
    final url = Uri.parse(AppUrl.updateStock);

    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'menu_id': id,
          'stock': newStock.toString(),
        },
      );

      if (response.statusCode == 200) {
        final index = daftarMenu.indexWhere((menu) => menu.id == id);

        if (index != -1) {
          final updatedMenu = daftarMenu[index];
          updatedMenu.stock = newStock;
          daftarMenu[index] = updatedMenu;
          daftarMenu.refresh();

          Get.snackbar(
            "Berhasil Update Stok",
            "Stok menu ${updatedMenu.name} berhasil diubah menjadi $newStock.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(milliseconds: 2500),
            margin: EdgeInsets.all(10),
            borderRadius: 10,
          );
        }
      } else {
        print("Gagal update stock: ${response.body}");
      }
    } catch (e) {
      print("Error updateMenuStock: $e");
    }
  }

  String formatRupiah(int price) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    return formatCurrency.format(price);
  }
}
