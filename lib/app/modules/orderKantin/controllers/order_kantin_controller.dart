import 'package:get/get.dart';

import '../../../data/models/qr_model.dart';
import '../../../data/providers/customer_provider.dart';

class OrderKantinController extends GetxController {
  //TODO: Implement OrderKantinController
  RxBool isLoading = true.obs;
  Rx<Qr> qrData = Qr().obs;
  final _customerProvider = CustomerProvider().obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchQr();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  Future<void> fetchQr() async {
    try {
      isLoading(true);

      // Call the fetchqr method from CustomerProvider
      Qr result = await _customerProvider.value.fetchqr();

      // Update the qr data
      qrData(result);

      isLoading(false);
    } catch (error) {
      isLoading(false);
      print('Error fetching QR data: $error');
    }
  }
}
