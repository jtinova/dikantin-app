import 'package:get/get.dart';

class ApiConfigService extends GetxService {
  final RxString baseURL = 'https://dikantin-staging.jtinova.com'.obs;

  void updateBaseUrl(String newUrl) {
    baseURL.value = newUrl;
  }
}

class AppUrl {
  static final ApiConfigService _apiConfig = Get.find<ApiConfigService>();

  static String get _baseURL => _apiConfig.baseURL.value;

  static String get baseURLAPI => '$_baseURL/api';
  static String get baseImageURL => '$_baseURL/';

  // Authentication User
  static String get signin => '$baseURLAPI/login';
  static String get signup => '$baseURLAPI/register';
  static String get codeOTP => '$baseURLAPI/send-reset-password';
  static String get verifyOTP => "$baseURLAPI/verify-otp";
  static String get resetPassword => "$baseURLAPI/reset-password";
  static String get signout => "$baseURLAPI/logout";
  static String get courierLogin => "$baseURLAPI/courier/login";

  // API Home User
  static String get locations => '$baseURLAPI/building';
  static String get categories => '$baseURLAPI/category';
  static String get canteens => '$baseURLAPI/canteen';
  static String get searchMenu => '$baseURLAPI/menu/search';
  static String get menus => '$baseURLAPI/menu';
  static String get reviewMenu => '$baseURLAPI/menu/review/';
  static String get menuFavorit => '$baseURLAPI/menu/favorite';
  static String get menuFavoritAdd => '$baseURLAPI/menu/favorite/add';
  static String get menuFavoritRemove => '$baseURLAPI/menu/favorite/remove/';

  // API Order User
  static String get calculateOrder => '$baseURLAPI/transaction/calculate-order';
  static String get createOrder => '$baseURLAPI/transaction/create';
  static String get trackingProgress => '$baseURLAPI/transaction/progress';
  static String get trackingDetailProgress => '$baseURLAPI/transaction/';
  static String get trackingShipping => '$baseURLAPI/transaction/shipping';
  static String get trackingDetailShipping =>
      '$baseURLAPI/transaction/shipping/';
  static String get trackingHistory => '$baseURLAPI/transaction/history';
  static String get cancelOrder => '$baseURLAPI/transaction/cancel';
  static String get pickUpOrder => '$baseURLAPI/transaction/pick-up';
  static String get dineInOrder => '$baseURLAPI/transaction/dine-in';

  // API Profile User
  static String get detailUserProfile => '$baseURLAPI/user';
  static String get updateUserData => '$baseURLAPI/user/update';

  // API Auth Courier
  static String get courierSignIn => '$baseURLAPI/courier/login';
  static String get courierProfile => '$baseURLAPI/courier/profile';

  // API Order Courier
  static String get pendingOrders => '$baseURLAPI/shipping/pending';
  static String get detailOrder => '$baseURLAPI/shipping';
  static String get deliveryOrder => '$baseURLAPI/shipping/deliver';
  static String get completeOrder => '$baseURLAPI/shipping/delivered';
  static String get shippingHistory => '$baseURLAPI/shipping/history';
  static String get shippingStats => '$baseURLAPI/shipping/stats';

  // API WithDraw Courier
  static String get withDrawlBalance => '$baseURLAPI/courier/withdraw-balance';
  static String get withDrawlHistory => '$baseURLAPI/courier-withdrawals';

  // API fcm
  static String get notification => '$baseURLAPI/fcm/notification';
}
