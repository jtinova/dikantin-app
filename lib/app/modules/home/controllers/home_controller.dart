import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var selectedCanteen = "Semua".obs; 

   List<String> bannerList = [
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
    'assets/images/image_carousel.png',
  ];

  List<Map<String, String>> categories = [
    {"name": "Ayam", "image": "assets/images/image_carousel.png"},
    {"name": "Lalapan", "image": "assets/images/image_carousel.png"},
    {"name": "Mie", "image": "assets/images/image_carousel.png"},
    {"name": "Jus", "image": "assets/images/image_carousel.png"},
    {"name": "Camilan", "image": "assets/images/image_carousel.png"},
    {"name": "Gorengan", "image": "assets/images/image_carousel.png"},
  ];

  List<Map<String, String>> canteens = [
    {"name": "Semua"},
    {"name": "Kantin 1"},
    {"name": "Kantin 2"},
    {"name": "Kantin 3"},
    {"name": "Kantin 4"},
    {"name": "Kantin 5"},
    {"name": "Kantin 6"},
  ];

  List<Map<String, String>> foodItems = [
    {
      "canteen": "Kantin 1",
      "name": "Nasi Uduk Spesial",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Buka"
    },
    {
      "canteen": "Kantin 2",
      "name": "Nasi Ayam Bakar",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Buka"
    },
    {
      "canteen": "Kantin 3",
      "name": "Nasi Pecel",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Tutup"
    },
    {
      "canteen": "Kantin 4",
      "name": "Nasi Rawon",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Buka"
    },
    {
      "canteen": "Kantin 5",
      "name": "Nasi Soto Spesial",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Buka"
    },
    {
      "canteen": "Kantin 6",
      "name": "Tahu Tek",
      "image": "assets/images/image_carousel.png",
      "price": "Rp 12.000",
      "status": "Tutup"
    },
  ];

  void updateIndex(int index) {
    currentIndex.value = index; 
  }

  void selectCanteen(String canteen) {
    selectedCanteen.value = canteen;
  }
}
