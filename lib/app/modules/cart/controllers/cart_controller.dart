import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/cart.dart';
import '../../home/controllers/home_controller.dart';

class CartController extends GetxController {
  final selectedCartItemIds = <String>[].obs;
  int get totalSelectedItems => selectedCartItemIds.length;

  List<CartItem> get selectedCartItems {
    final allItems = Get.find<HomeController>().cartItems;
    return allItems
        .where((item) => selectedCartItemIds.contains(item.menu.id))
        .toList();
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

  Future<void> clearCart() async {
    selectedCartItemIds.clear();
  }

  int get totalSelectedPrice {
    return selectedCartItems.fold(
        0, (sum, item) => sum + (item.menu.sellingCost * item.quantity));
  }

  String formatRupiah(int price) {
    final formatCurrency = NumberFormat("#,##0", "id_ID");
    return formatCurrency.format(price);
  }
}
