import 'package:get/get.dart';

import '../modules/navigation/bindings/navigation_binding.dart';
import '../modules/navigation/views/navigation_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/about_app.dart';
import '../modules/profile/views/my_profile.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/riwayat_kantin/views/riwayatkantin_view.dart';
import '../modules/riwayat_kantin/bindings/riwayatkantin_binding.dart';
import '../modules/home_kantin/bindings/home_kantin_binding.dart';
import '../modules/home_kantin/views/home_kantin_view.dart';
import '../modules/pesanan_kantin/bindings/pesanan_binding.dart';
import '../modules/pesanan_kantin/views/pesanan_view.dart';
import '../modules/menu_kantin/bindings/menu_binding.dart';
import '../modules/menu_kantin/views/menu_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIGN_IN;

  static final routes = [
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION,
      page: () => NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
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
      name: _Paths.HOME_KANTIN,
      page: () => HomeKantinView(),
      binding: HomeKantinBinding(),
    ),
    GetPage(
      name: _Paths.MENU_KANTIN,
      page: () => MenuKantinView(),
      binding: MenuKantinBinding(),
    ),
    GetPage(
      name: _Paths.PESANAN_KANTIN,
      page: () => PesananKantinView(),
      binding: PesananKantinBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_KANTIN,
      page: () => RiwayatKantinView(),
      binding: RiwayatKantinBinding(),
    ),
  ];
}
