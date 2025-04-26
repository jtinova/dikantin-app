import 'building.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? detailAddress;
  final Building? building;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.detailAddress,
    this.building,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      detailAddress: json['detail_address'] ?? '',
      building: json['building'] != null ? Building.fromJson(json['building']) : null,
    );
  }
}
