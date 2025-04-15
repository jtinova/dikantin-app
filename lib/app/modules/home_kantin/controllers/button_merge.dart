import 'package:get/get.dart';

class ButtonController extends GetxController {
  var isMerged = false.obs; 

  void mergeButtons() {
    isMerged.value = true;
  }
}
