class Canteen {
  final String id;
  final String name;
  final String phoneNumber;
  final int balance;
  final String status;
  final String email;

  Canteen({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.balance,
    required this.status,
    required this.email,
  });

  factory Canteen.fromJson(Map<String, dynamic> json) {
    return Canteen(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      balance: json['balance'] ?? 0,
      status: json['status'] ?? '',
      email: json['email'] ?? '',
    );
  }
}