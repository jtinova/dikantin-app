import 'package:get/get.dart';

import '../modules/detailTransaksi/bindings/detail_transaksi_binding.dart';
import '../modules/detailTransaksi/views/detail_transaksi_view.dart';
import '../modules/forgotPassword/bindings/forgot_password_binding.dart';
import '../modules/forgotPassword/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/keranjang/bindings/keranjang_binding.dart';
import '../modules/keranjang/views/keranjang_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/maps/bindings/maps_binding.dart';
import '../modules/maps/views/maps_view.dart';
import '../modules/navigation/bindings/navigation_binding.dart';
import '../modules/navigation/views/navigation_view.dart';
import '../modules/navigationKurir/bindings/navigationKurir_binding.dart';
import '../modules/navigationKurir/views/navigationKurir_view.dart';
import '../modules/onBoarding/bindings/on_boarding_binding.dart';
import '../modules/onBoarding/views/on_boarding_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_view.dart';
import '../modules/orderKantin/bindings/order_kantin_binding.dart';
import '../modules/orderKantin/views/order_kantin_view.dart';
import '../modules/otpPage/bindings/otp_page_binding.dart';
import '../modules/otpPage/views/otp_page_view.dart';
import '../modules/pesanan/bindings/pesanan_binding.dart';
import '../modules/pesanan/views/pesanan_view.dart';
import '../modules/pesananKurir/bindings/pesananKurir_binding.dart';
import '../modules/pesananKurir/views/pesananKurir_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profileKurir/bindings/profile_binding.dart';
import '../modules/profileKurir/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/riwayat/views/riwayat_view.dart';
import '../modules/riwayatKurir/bindings/riwayat_kurir_binding.dart';
import '../modules/riwayatKurir/views/riwayat_kurir_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/ubahPassword/bindings/ubah_password_binding.dart';
import '../modules/ubahPassword/views/ubah_password_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.NAVIGATION,
      page: () => NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_KURIR,
      page: () => NavigationKurirView(),
      binding: NavigationKurirBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PESANAN,
      page: () => PesananView(),
      binding: PesananBinding(),
    ),
    GetPage(
      name: _Paths.PESANAN_KURIR,
      page: () => PesananKurirView(),
      binding: PesananKurirBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT,
      page: () => RiwayatView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_KURIR,
      page: () => ProfileKurirView(),
      binding: ProfileKurirBinding(),
    ),
    GetPage(
      name: _Paths.KERANJANG,
      page: () => KeranjangView(),
      binding: KeranjangBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_TRANSAKSI,
      page: () => DetailTransaksiView(),
      binding: DetailTransaksiBinding(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING,
      page: () => const OnBoardingView(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP_PAGE,
      page: () => const OtpPageView(),
      binding: OtpPageBinding(),
    ),
    GetPage(
      name: _Paths.UBAH_PASSWORD,
      page: () => const UbahPasswordView(),
      binding: UbahPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_KURIR,
      page: () => RiwayatKurirView(),
      binding: RiwayatKurirBinding(),
    ),
    GetPage(
      name: _Paths.MAPS,
      page: () => MapsView(
        selectedBuilding: '',
        initialSelectedValue: '',
        keterangan: '',
      ),
      binding: MapsBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_KANTIN,
      page: () =>  OrderKantinView(),
      binding: OrderKantinBinding(),
    ),
  ];
}
