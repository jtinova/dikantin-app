import 'package:dikantin_partner/app/data/api.dart';

class HistoryModel {
  final String transactionId;
  final String transactionCode;
  final String customerName;
  final int totalQty;
  final int totalMainCost;
  final String paymentMethod;
  String get paymentMethodLabel {
    switch (paymentMethod) {
      case 'cash':
        return 'Cash';
      case 'qris':
        return 'QRIS';
      default:
        return 'Tidak Diketahui';
    }
  }

  final String status;
  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pesanan Masuk';
      case 'cooking':
        return 'Dimasak';
      case 'on_delivery':
        return 'Diantar';
      case 'done':
        return 'Selesai';
      default:
        return 'Tidak Diketahui';
    }
  }

  final String date;
  final List<HistoryMenuItem> menu;

  HistoryModel({
    required this.transactionId,
    required this.transactionCode,
    required this.customerName,
    required this.totalQty,
    required this.totalMainCost,
    required this.paymentMethod,
    required this.status,
    required this.date,
    required this.menu,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      transactionId: json['transaction_id'].toString(),
      transactionCode: json['transaction_code'] ?? '',
      customerName: json['customer_name'] ?? '',
      totalQty: json['total_qty'] ?? 0,
      totalMainCost: json['total_main_cost'] ?? 0,
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      menu: (json['menu'] as List)
          .map((e) => HistoryMenuItem.fromJson(e))
          .toList(),
    );
  }
}

class HistoryMenuItem {
  final String menuId;
  final String name;
  final int mainCost;
  final int qty;
  final int mainSubtotal;
  final String image;
  final String? note;

  HistoryMenuItem({
    required this.menuId,
    required this.name,
    required this.mainCost,
    required this.qty,
    required this.mainSubtotal,
    required this.image,
    this.note,
  });

  factory HistoryMenuItem.fromJson(Map<String, dynamic> json) {
    return HistoryMenuItem(
      menuId: json['menu_id'].toString(),
      name: json['name'] ?? '',
      mainCost: json['main_cost'] ?? 0,
      qty: json['qty'] ?? 0,
      mainSubtotal: json['main_subtotal'] ?? 0,
      image: json['image'],
      note: json['note'] ?? '',
    );
  }
  String get imagePath => "${AppUrl.imageMenu}$image";
}
