import 'menu.dart';

class CartItem {
  final Menu menu;
  final int quantity;
  final String? note;

  CartItem({
    required this.menu,
    required this.quantity,
    this.note,
  });

  int get totalPrice => menu.sellingCost * quantity;

  CartItem copyWith({
    Menu? menu,
    int? quantity,
    String? note,
  }) {
    return CartItem(
      menu: menu ?? this.menu,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note, 
    );
  }
}