import 'package:dikantin_partner/app/data/api.dart';

class TransactionModel {
  final String id;
  final String transactionCode;
  final String customerId;
  final String customerName;
  final String dateTime;
  final String status;
  final String orderType;
  String get orderTypeLabel {
    switch (orderType) {
      case 'dine_in':
        return 'Makan di Tempat';
      case 'deliver':
        return 'Diantar';
      case 'pick_up':
        return 'Ambil Sendiri';
      default:
        return 'Tidak Diketahui';
    }
  }

  final int deskNumber;
  final List<OrderDetail> details;
  final int totalQty;
  final int mainCost;

  TransactionModel({
    required this.id,
    required this.transactionCode,
    required this.customerId,
    required this.customerName,
    required this.dateTime,
    required this.status,
    required this.orderType,
    required this.deskNumber,
    required this.details,
    required this.totalQty,
    required this.mainCost,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'].toString(),
      transactionCode: json['transaction_code'] ?? '',
      customerId: json['customer_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      dateTime: json['date'] ?? '',
      status: json['status'] ?? '',
      orderType: json['order_type'] ?? '',
      deskNumber: int.tryParse(json['desk_number'].toString()) ?? 0,
      details: (json['details'] as List)
          .map((e) => OrderDetail.fromJson(e))
          .toList(),
      totalQty: int.tryParse(json['total_qty'].toString()) ?? 0,
      mainCost: int.tryParse(json['total_main_cost'].toString()) ?? 0,
    );
  }
}

class OrderDetail {
  final String id;
  final String menuId;
  final String name;
  final int qty;
  final int harga;
  final String status;
  final String image;

  OrderDetail({
    required this.id,
    required this.menuId,
    required this.name,
    required this.qty,
    required this.harga,
    required this.status,
    required this.image,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'].toString(),
      menuId: json['menu_id'].toString(),
      name: json['name'] ?? '',
      qty: int.tryParse(json['qty'].toString()) ?? 0,
      harga: int.tryParse(json['main_cost'].toString()) ?? 0,
      status: json['status'] ?? '',
      image: json['image'] ?? '',
    );
  }

  String get imagePath => "${AppUrl.imageMenu}$image";
}
