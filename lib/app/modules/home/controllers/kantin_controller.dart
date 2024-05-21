import 'package:dikantin/app/data/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dikantin/app/data/providers/menu_provider.dart';

import '../../../data/models/kantin_model.dart';

class KantinController extends GetxController {
  final menuProvider = MenuProvider().obs;
  final kantinResults = <DataKantin>[].obs;
  final menuKantinResults = <Datasearch>[].obs;
  final isLoading = false.obs; // Tambahkan isLoading
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  void setLoading(bool value) {
    isLoading.value = value; // Metode untuk mengatur status isLoading
  }

  Future<void> refreshData() async {
    try {
      setLoading(true);
      final results = await menuProvider.value.fetchKantin();
      kantinResults.assignAll(results.data ?? []);

      // Bersihkan data menu sebelum menambahkan menu baru
      menuKantinResults.clear();

      // Iterasi untuk setiap kantin dan panggil fetchMenuKantin untuk masing-masing
      for (var kantin in kantinResults) {
        final menuResults = await menuProvider.value
            .fetchMenuKantin(kantin.idKantin.toString());
        // Tambahkan menu ke daftar menu hanya jika ID kantin menu tersebut sesuai dengan ID kantin yang sedang ditampilkan
        menuKantinResults.addAll(menuResults.data
                ?.where((menu) => menu.idKantin == kantin.idKantin) ??
            []);
      }
    } catch (e) {
      print('Error during search: $e');
      kantinResults.clear();
      menuKantinResults.clear();
    } finally {
      setLoading(false);
    }
  }
}
