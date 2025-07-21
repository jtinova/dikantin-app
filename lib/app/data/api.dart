class AppUrl {
  // Change IP Address before run project
  static String baseURL = 'https://dikantin-staging.jtinova.com';
  static String baseURLLocal = 'http://192.168.1.13:8000';
  static String baseURLAPI = '$baseURLLocal/api';
  static String baseImageURL = '$baseURLLocal/storage/menu/';

  // Authentication User
  static String signin = '$baseURLAPI/login';
  static String signup = '$baseURLAPI/register';
  static String codeOTP = '$baseURLAPI/send-reset-password';
  static String verifyOTP = "$baseURLAPI/verify-otp";
  static String resetPassword = "$baseURLAPI/reset-password";
  static String signout = "$baseURLAPI/logout";
  static String courierLogin = "$baseURLAPI/courier/login";

  // API Home User
  static String locations = '$baseURLAPI/building';
  static String categories = '$baseURLAPI/category';
  static String canteens = '$baseURLAPI/canteen';
  static String searchMenu = '$baseURLAPI/menu/search';
  static String menus = '$baseURLAPI/menu';
  static String reviewMenu = '$baseURLAPI/menu/review/';
  static String menuFavorit = '$baseURLAPI/menu/favorite';
  static String menuFavoritAdd = '$baseURLAPI/menu/favorite/add';
  static String menuFavoritRemove = '$baseURLAPI/menu/favorite/remove/';

  // API Order User
  static String calculateOrder = '$baseURLAPI/transaction/calculate-order';
  static String createOrder = '$baseURLAPI/transaction/create';
  static String trackingProgress = '$baseURLAPI/transaction/progress';
  static String trackingDetailProgress = '$baseURLAPI/transaction/';
  static String trackingShipping = '$baseURLAPI/transaction/shipping';
  static String trackingDetailShipping = '$baseURLAPI/transaction/shipping/';
  static String trackingHistory = '$baseURLAPI/transaction/history';
  static String cancelOrder = '$baseURLAPI/transaction/cancel';
  static String pickUpOrder = '$baseURLAPI/transaction/pick-up';
  static String dineInOrder = '$baseURLAPI/transaction/dine-in';

  // API Profile User
  static String detailUserProfile = '$baseURLAPI/user';
  static String updateUserData = '$baseURLAPI/user/update';

  // API Auth Courier
  static String courierSignIn = '$baseURLAPI/courier/login';
  static String courierProfile = '$baseURLAPI/courier/profile';

  // API Order Courier
  static String pendingOrders = '$baseURLAPI/shipping/pending';
  static String detailOrder = '$baseURLAPI/shipping';
  
  static String deliveryOrder = '$baseURLAPI/shipping/deliver';
  static String completeOrder = '$baseURLAPI/shipping/delivered';
  static String shippingHistory = '$baseURLAPI/shipping/history';
  static String shippingStats = '$baseURLAPI/shipping/stats';

  // API WithDraw Courier
  static String withDrawlBalance = '$baseURLAPI/courier/withdraw-balance';
  static String withDrawlHistory = '$baseURLAPI/courier-withdrawals';
}
