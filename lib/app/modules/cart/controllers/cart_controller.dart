import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/cart.dart';
import '../../home/controllers/home_controller.dart';

class CartController extends GetxController {
  final HomeController homeController = Get.find();

  final selectedCartItemIds = <String>[].obs;
  var noteController = <String, TextEditingController>{}.obs;

  int get totalSelectedItems => selectedCartItemIds.length;

  @override
  void onInit() {
    super.onInit();
    _synchonizeNote();
    ever(homeController.cartItems, (_) => _synchonizeNote());
  }

  void _synchonizeNote() {
    final Set<String> currentMenuIdInCart =
        homeController.cartItems.map((item) => item.menu.id).toSet();

    // Hapus untuk item yang tidak lagi ada dikeranjang
    noteController.keys.toList().forEach((menuId) {
      if (!currentMenuIdInCart.contains(menuId)) {
        noteController[menuId]?.dispose();
        noteController.remove(menuId);
      }
    });

    // Tambah atau pastikan ada untuk setiap item dikeranjang
    for (var item in homeController.cartItems) {
      if (!noteController.containsKey(item.menu.id)) {
        noteController[item.menu.id] =
            TextEditingController(text: item.note ?? '');
      }
    }
    noteController.refresh();
  }

  TextEditingController getNoteForItem(String menuId) {
    // Pastikan noteController sudah terisi untuk menuId
    if (!noteController.containsKey(menuId)) {
      final cartItem = homeController.cartItems
          .firstWhereOrNull((item) => item.menu.id == menuId);
      noteController[menuId] =
          TextEditingController(text: cartItem?.note ?? '');
    }
    return noteController[menuId]!;
  }

  List<CartItem> get selectedCartItems {
    return homeController.cartItems
        .where((item) => selectedCartItemIds.contains(item.menu.id))
        .toList();
  }

  List<CartItem> getSelectedCartItemWithCurrentNote() {
    return selectedCartItems.map((cartItem) {
      String? currentNote = noteController[cartItem.menu.id]?.text.trim();
      return cartItem.copyWith(
        note: currentNote?.isNotEmpty == true ? currentNote : null,
      );
    }).toList();
  }

  Future<void> toggleItemSelection(CartItem item) async {
    final id = item.menu.id;
    if (selectedCartItemIds.contains(id)) {
      selectedCartItemIds.remove(id);
    } else {
      selectedCartItemIds.add(id);
    }
  }

  Future<void> toggleCanteenSelection(
      String canteenName, Map<String, List<CartItem>> groupedItems) async {
    final items = groupedItems[canteenName]!;
    final isAllSelected =
        items.every((item) => selectedCartItemIds.contains(item.menu.id));

    if (isAllSelected) {
      selectedCartItemIds
          .removeWhere((id) => items.any((item) => item.menu.id == id));
    } else {
      for (var item in items) {
        if (!selectedCartItemIds.contains(item.menu.id)) {
          selectedCartItemIds.add(item.menu.id);
        }
      }
    }
  }

  Future<void> toggleSelectAll(List<CartItem> allItems) async {
    if (selectedCartItemIds.length == allItems.length) {
      selectedCartItemIds.clear();
    } else {
      selectedCartItemIds.assignAll(allItems.map((item) => item.menu.id));
    }
  }

  Future<void> clearCartSelectionsAndNote() async {
    selectedCartItemIds.clear();
    noteController.forEach((key, ctrl) {
      ctrl.clear();
    });
  }

  int get totalSelectedPrice {
    return selectedCartItems.fold(
        0, (sum, item) => sum + (item.menu.sellingCost * item.quantity));
  }

  String formatRupiah(int price) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    return formatCurrency.format(price);
  }

  @override
  void onClose() {
    noteController.forEach((_, controller) => controller.dispose());
    noteController.clear();
    super.onClose();
  }
}
