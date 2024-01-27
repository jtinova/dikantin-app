import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dikantin/app/data/providers/menu_provider.dart';

import '../../../data/models/search_model.dart';

class MakananController extends GetxController {
  final menuProvider = MenuProvider().obs;
  final searchResults = <Datasearch>[].obs;
  final isLoading = false.obs; // Tambahkan isLoading
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    search('');
    refreshData();
  }

  void setLoading(bool value) {
    isLoading.value = value; // Metode untuk mengatur status isLoading
  }

  Future<void> refreshData() async {
    await search('');
  }

  Future<void> search(String keyword) async {
    try {
      setLoading(
          true); // Set isLoading menjadi true saat pemanggilan API dimulai
      final results = await menuProvider.value.searchMakanan(keyword);
      searchResults.assignAll(results.data ?? []);
    } catch (e) {
      print('Error during search: $e');
      searchResults.clear();
    } finally {
      setLoading(
          false); // Set isLoading menjadi false saat pemanggilan API selesai
    }
  }
  
}
