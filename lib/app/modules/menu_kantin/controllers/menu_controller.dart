import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:dikantin_app_rebuild/app/models/menu_kantin.dart';
import 'dart:convert';

import 'package:dikantin_app_rebuild/app/data/db_provider.dart';
import 'package:dikantin_app_rebuild/app/data/api.dart';

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

        daftarMenu.value = data.map((item) => MenuModel.fromJson(item)).toList();
      } else {
        print("Gagal ambil menu: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetchMenus: $e");
    }
  }

  Future<void> updateMenuStock(String id, bool newStatus) async {
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
          'stock': newStatus ? '1' : '0', 
        },
      );

      if (response.statusCode == 200) {
        final index = daftarMenu.indexWhere((menu) => menu.id == id);
        if (index != -1) {
          final updatedMenu = daftarMenu[index];
          updatedMenu.isAvailable = newStatus;
          daftarMenu[index] = updatedMenu;
          // daftarMenu[index].isAvailable = newStatus;
          // daftarMenu.refresh(); 
        }
      } else {
        print("Gagal update stock: ${response.body}");
      }
    } catch (e) {
      print("Error updateMenuStock: $e");
    }
  }
}

