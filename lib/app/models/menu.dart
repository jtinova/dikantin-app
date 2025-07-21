import '../data/api.dart';
import 'canteen.dart';
import 'category.dart';

class Menu {
  final String id;
  final String name;
  final String? image;
  final int sellingCost;
  final int mainCost;
  final int stock;
  final String? description;
  final double? rating;
  final int? ratingCount;
  final Canteen canteen;
  final Category? category;
  bool isFavorite;

  Menu({
    required this.id,
    required this.name,
    this.image,
    required this.sellingCost,
    required this.mainCost,
    required this.stock,
    this.description,
    this.rating,
    this.ratingCount,
    required this.canteen,
    this.category,
    this.isFavorite = false,
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
      rating: (json['rating'] as num?)?.toDouble(),
      ratingCount: json['rating_count'],
      canteen: Canteen.fromJson(json['canteen']),
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }

  String get imageUrl => '${AppUrl.baseImageURL}$image';
}
