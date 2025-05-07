class AppUrl {
  // Change IP Address before run project
  static String baseURL = 'http://192.168.1.2:8080/api';

  // Authentication
  static String signin = '$baseURL/login';
  static String signup = '$baseURL/register';
  static String codeOTP = '$baseURL/send-reset-password';
  static String verifyOTP = "$baseURL/verify-otp";
  static String resetPassword = "$baseURL/reset-password";
  static String signout = "$baseURL/logout";

  // API Home
  static String locations = '$baseURL/building';
  static String categories = '$baseURL/category';
  static String canteens = '$baseURL/canteen';
  static String searchMenu = '$baseURL/menu/search';
  static String menus = '$baseURL/menu';
  static String menuByCanteen = '$baseURL/canteen/menu';
  static String menuByCategory = '$baseURL/category/menu';

  // API Order
  static String calculateOrder = '$baseURL/transaction/calculate-order';
  static String createOrder = '$baseURL/transaction/create';
  static String trackingProgress = '$baseURL/transaction/progress';
  static String trackingDetailProgress = '$baseURL/transaction/';
  static String trackingShipping = '$baseURL/transaction/shipping';
  static String trackingDetailShipping = '$baseURL/transaction/shipping/';
  static String trackingHistory = '$baseURL/transaction/history';
  static String cancelOrder = '$baseURL/transaction/cancel';
  static String pickUpOrder = '$baseURL/transaction/pick-up';

  // API Profile
  static String detailUserProfile = '$baseURL/user';
  static String updateUserData = '$baseURL/user/update';
}
