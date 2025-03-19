class AppUrl {
  // Change IP Address before run project
  static String baseURL = 'http://10.10.177.175:8080/api';

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
  static String menus = '$baseURL/menu';
  static String menuByCanteen = '$baseURL/canteen/menu';
  static String menuByCategory = '$baseURL/category/menu';

  // API Profile
  static String detailUserProfile = '$baseURL/user';
  static String updateUserData = '$baseURL/user/update';
}
