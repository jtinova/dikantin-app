class Order {
  final String id;
  final String transactionCode;
  final String name;
  final int qty;
  final int sellingCost;
  final int salesSubtotal;
  final int totalQty;
  final int grandTotal;
  final String date;
  final String status;
  final String? orderType;
  final String? note;

  Order({
    required this.id,
    required this.transactionCode,
    required this.name,
    required this.qty,
    required this.sellingCost,
    required this.salesSubtotal,
    required this.totalQty,
    required this.grandTotal,
    required this.date,
    required this.status,
    this.orderType,
    this.note,
  });

  // For detail response
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      transactionCode: '',
      name: json['name'],
      qty: json['qty'],
      sellingCost: json['selling_cost'],
      salesSubtotal: json['sales_subtotal'],
      totalQty: 0,
      grandTotal: 0,
      date: '',
      status: json['status'],
      note: json['note'] ?? '',
      orderType: json['order_type'],
    );
  }

  // For response
  factory Order.fromJsonProgress(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      transactionCode: json['transaction_code'],
      name: '',
      qty: 0,
      sellingCost: 0,
      salesSubtotal: 0,
      totalQty: json['total_qty'],
      grandTotal: json['grand_total'],
      date: json['date'],
      status: json['status'],
      orderType: json['order_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_code': transactionCode,
      'name': name,
      'qty': qty,
      'selling_cost': sellingCost,
      'sales_subtotal': sellingCost,
      'total_qty': totalQty,
      'grand_total': grandTotal,
      'date': date,
      'status': status,
    };
  }
}
