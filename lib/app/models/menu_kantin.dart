import 'package:dikantin_app_rebuild/app/data/api.dart';

class MenuModel {
  final String id;
  final String name;
  final String image;
  final int sellingCost;
  final int mainCost;
  bool isAvailable; 

  MenuModel({
    required this.id,
    required this.name,
    required this.image,
    required this.sellingCost,
    required this.mainCost,
    this.isAvailable = false, 
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      sellingCost: json['selling_cost'],
      mainCost: json['main_cost'],
      isAvailable: json['stock'] > 0, 
    );
  }

  String get hargaFormatted => "Rp $mainCost";
  String get status => isAvailable ? "Tersedia" : "Habis";
  String get imagePath => "${AppUrl.imageMenu}$image";

}
