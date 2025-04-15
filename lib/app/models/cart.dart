import 'menu.dart';

class CartItem {
  final Menu menu;
  final int quantity;

  CartItem({
    required this.menu,
    required this.quantity
  });

  int get totalPrice => menu.sellingCost * quantity;
}