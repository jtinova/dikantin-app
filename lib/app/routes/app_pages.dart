import 'package:get/get.dart';

import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/code_otp/bindings/code_otp_binding.dart';
import '../modules/code_otp/views/code_otp_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/navigation/bindings/navigation_binding.dart';
import '../modules/navigation/views/navigation_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/widgets/about_app_section.dart';
import '../modules/profile/widgets/favorite_menu_section.dart';
import '../modules/profile/widgets/history_order_section.dart';
import '../modules/profile/widgets/my_profile_section.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/send_email/bindings/send_email_binding.dart';
import '../modules/send_email/views/send_email_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/home_courier/bindings/home_courier_binding.dart';
import '../modules/home_courier/views/home_courier_view.dart';
import '../modules/navigation_courier/bindings/navigation_courier_binding.dart';
import '../modules/navigation_courier/views/navigation_courier_view.dart';
import '../modules/courier_delivery_history/bindings/courier_delivery_history_binding.dart';
import '../modules/courier_delivery_history/views/courier_delivery_history_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIGN_IN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.CODE_OTP,
      page: () => CodeOtpView(),
      binding: CodeOtpBinding(),
    ),
    GetPage(
      name: _Paths.SEND_EMAIL,
      page: () => SendEmailView(),
      binding: SendEmailBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION,
      page: () => NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_COURIER,
      page: () => NavigationCourierView(),
      binding: NavigationCourierBinding(),
    ),
    GetPage(
      name: _Paths.HOME_COURIER,
      page: () => HomeCourierView(),
      binding: HomeCourierBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: Routes.COURIER_DELIVERY_HISTORY,
      page: () => const CourierDeliveryHistoryView(),
      binding: CourierDeliveryHistoryBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_APP,
      page: () => const AboutApp(),
    ),
    GetPage(
      name: _Paths.MY_PROFILE,
      page: () => MyProfile(),
    ),
    GetPage(
      name: _Paths.HISTORY_ORDER,
      page: () => HistoryOrder(),
    ),
    GetPage(
      name: _Paths.FAVORITE_MENU,
      page: () => FavoriteMenu(),
    )
  ];
}
