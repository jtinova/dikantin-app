import 'package:dikantin_partner/app/data/api.dart';

class MenuModel {
  final String id;
  final String name;
  final String image;
  final int sellingCost;
  final int mainCost;
  int stock; 

  MenuModel({
    required this.id,
    required this.name,
    required this.image,
    required this.sellingCost,
    required this.mainCost,
    required this.stock,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      sellingCost: json['selling_cost'],
      mainCost: json['main_cost'],
      stock: json['stock'], 
    );
  }

  int get hargaFormatted => mainCost;
  String get statusLabel => stock > 0 ? "Stok: $stock" : "Habis";
  bool get isAvailable => stock > 0;
  String get imagePath => "${AppUrl.imageMenu}$image";
}