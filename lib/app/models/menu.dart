import '../data/api.dart';
import 'canteen.dart';

class Menu {
  final String id;
  final String name;
  final String image;
  final int sellingCost;
  final int mainCost;
  final int stock;
  final String description;
  final Canteen canteen;

  Menu({
    required this.id,
    required this.name,
    required this.image,
    required this.sellingCost,
    required this.mainCost,
    required this.stock,
    required this.description,
    required this.canteen,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      sellingCost: json['selling_cost'],
      mainCost: json['main_cost'],
      stock: json['stock'],
      description: json['description'],
      canteen: Canteen.fromJson(json['canteen']),
    );
  }

  String get imageUrl => '${AppUrl.baseImageURL}$image';
}
