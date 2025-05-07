class Delivery {
  final String id;
  final String courierId;
  final String courierName;
  final String buildingId;
  final String buildingName;
  final String destinationDetail;
  final String? deliveryDate;
  final String? arrivalDate;
  final String status;

  Delivery({
    required this.id,
    required this.courierId,
    required this.courierName,
    required this.buildingId,
    required this.buildingName,
    required this.destinationDetail,
    this.deliveryDate,
    this.arrivalDate,
    required this.status,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'] ?? '',
      courierId: json['courier_id'] ?? '',
      courierName: json['courier_name'] ?? '',
      buildingId: json['building_id'] ?? '',
      buildingName: json['building_name'] ?? '',
      destinationDetail: json['destination_detail'] ?? '',
      deliveryDate: json['delivery_date'] ?? '',
      arrivalDate: json['arrival_date'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
