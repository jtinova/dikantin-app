class Canteen {
  final String id;
  final String name;
  final String phoneNumber;
  final int balance;
  final String status;

  Canteen({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.balance,
    required this.status,
  });

  factory Canteen.fromJson(Map<String, dynamic> json) {
    return Canteen(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      balance: json['balance'],
      status: json['status'],
    );
  }
}