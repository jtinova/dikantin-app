class MenuRating {
  final String id;
  final String menuId;
  final String customerId;
  final String customerName;
  final int rating;
  final String? comment;
  final String createdAt;

  MenuRating({
    required this.id,
    required this.menuId,
    required this.customerId,
    required this.customerName,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory MenuRating.fromJson(Map<String, dynamic> json) {
    return MenuRating(
      id: json['id'],
      menuId: json['menu_id'],
      customerId: json['customer_id'],
      customerName: json['customer_name'] ?? 'Anonim',
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }
}