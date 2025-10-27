class AppUrl {
  // Change IP Address before run project
  static String baseHost = 'https://dikantin-staging.jtinova.com';
  static String baseURL = '$baseHost/api';
  static String imageMenu = '$baseHost/';

  // Authentication
  static String signin = '$baseURL/login';
  static String signout = "$baseURL/logout";

  // FCM Token
  static String storeFCMToken = '$baseURL/fcm';

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
  static String orderDetailCanteen = '$baseURL/canteen/order/';
  static String processCanteen = '$baseURL/canteen/order/process';
  static String completeCanteen = '$baseURL/canteen/order/complete';
  static String historyCanteen = '$baseURL/canteen/orders/completed';
}
