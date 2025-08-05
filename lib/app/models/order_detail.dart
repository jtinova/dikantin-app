import 'delivery.dart';
import 'order.dart';

class OrderDetail {
  final String id;
  final String transactionCode;
  final int totalQty;
  final int? totalSellingCost;
  final int deliveryFee;
  final int grandTotal;
  final String date;
  final String status;
  final String paymentType;
  final List<Order> details;
  final Delivery? delivery;
  final String ?orderType;

  OrderDetail({
    required this.id,
    required this.transactionCode,
    required this.totalQty,
    this.totalSellingCost,
    required this.deliveryFee,
    required this.grandTotal,
    required this.date,
    required this.status,
    required this.paymentType,
    required this.details,
    this.delivery,
    this.orderType
  });

  // For Detail Progress
  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id']?.toString() ?? '',
      transactionCode: json['transaction_code'] ?? '',
      totalQty: json['total_qty'] ?? 0,
      totalSellingCost: json['total_selling_cost'],
      deliveryFee: json['delivery_fee'] ?? 0,
      grandTotal: json['grand_total'] ?? 0,
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      paymentType: json['payment_method'] ?? '',
      orderType: json['order_type'] ?? '',
      details: (json['details'] as List<dynamic>?)
              ?.map((item) => Order.fromJson(item))
              .toList() ??
          [],
    );
  }

  // For Detail Shipping
  factory OrderDetail.fromJsonShipping(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id']?.toString() ?? '',
      transactionCode: json['transaction_code'] ?? '',
      totalQty: json['total_qty'] ?? 0,
      totalSellingCost: json['total_selling_cost'],
      deliveryFee: json['delivery_fee'] ?? 0,
      grandTotal: json['grand_total'] ?? 0,
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      paymentType: json['payment_method'] ?? '',
      orderType: json['order_type'] ?? '',
      details: (json['details'] as List<dynamic>?)
              ?.map((item) => Order.fromJson(item))
              .toList() ??
          [],
      delivery: Delivery.fromJson(json['delivery'] ?? {}),
    );
  }
}
