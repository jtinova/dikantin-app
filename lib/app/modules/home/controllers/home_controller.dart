import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var selectedCanteen = "Semua".obs; // Default selected canteen

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  void selectCanteen(String canteen) {
    selectedCanteen.value = canteen;
  }
}
