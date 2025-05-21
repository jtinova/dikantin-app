class AppUrl {
  // Change IP Address before run project
  static const String baseHost = 'http://192.168.43.13:8000';
  static const String baseURL = '$baseHost/api';

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

  // API Profile
  static String detailUserProfile = '$baseURL/user';
  static String updateUserData = '$baseURL/user/update';

  // Canteen
  static String signinCanteen = '$baseURL/canteen/login';
  static String menuCanteen = '$baseURL/canteen/menu';
  static String updateStock = '$baseURL/canteen/menu/update-stock';
  static String incomeToday = '$baseURL/canteen/income-today';
  static String incomeMonth = '$baseURL/canteen/income';
  static String orderServed = '$baseURL/canteen/total-served';
  static String orderDone = '$baseURL/canteen/total-done';
  static String statusCanteen = '$baseURL/canteen/canteen-status';
  static String profilCanteen = '$baseURL/canteen/profile';
  static String orderCanteen = '$baseURL/canteen/order';
  static String processCanteen = '$baseURL/canteen/order/process';
  static String completeCanteen = '$baseURL/canteen/order/complete';
  static String historyCanteen = '$baseURL/canteen/orders/completed';
  static const String imageMenu = '$baseHost/storage/menu/';
}
