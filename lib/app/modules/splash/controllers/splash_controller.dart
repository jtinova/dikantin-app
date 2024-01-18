import 'package:dikantin/app/modules/fcm/fcm.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;
  @override
  void onInit() {
    print('dsd0');
    super.onInit();
    FcmService fcmService = new FcmService();
    fcmService.requestNotificationPermission();
    fcmService.forgroundMessage();
    fcmService.firebaseInit(Get.context!);
    fcmService.setupInteractMessage(Get.context!);
    fcmService.isTokenRefresh();

    fcmService.getDeviceToken().then((value) {
      print("token fcm service" + value);
    });
  }

  @override
  Future<void> onReady() async {
    print('onr0');
    super.onReady();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? tokenKurir = prefs.getString('tokenKurir');
    print("Iki token wiawi:: $token");
    print(tokenKurir);
    // Jika kedua token bernilai null, pergi ke halaman login
    if (token == null && tokenKurir == null) {
      _navigateToLogin();
    } else if (token == null && tokenKurir != null) {
      _navigateToNavigationKurir();
    } else if (token != null && tokenKurir == null) {
      _navigateToNavigation();
    } else if (token != null && tokenKurir != null) {
      await prefs.remove('tokenKurir');
      _navigateToNavigation();
    }
    // Jika token tidak null dan tokenKurir null, per gi ke halaman navigation
  }

  void _navigateToLogin() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offAllNamed('/login');
    });
  }

  void _navigateToNavigation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 3), () {
      // Periksa apakah token tidak null sebelum navigasi
      if (prefs.getString('token') != null) {
        Get.offAllNamed('/navigation');
        _determinePosition();
      } else {
        _navigateToLogin(); // Pergi ke halaman login jika token bernilai null
      }
    });
  }

  void _navigateToNavigationKurir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Future.delayed(Duration(seconds: 3), () {
      // Periksa apakah tokenKurir tidak null sebelum navigasi
      if (prefs.getString('tokenKurir') != null) {
        Get.offAllNamed('/navigationKurir');
      } else {
        _navigateToLogin(); // Pergi ke halaman login jika tokenKurir bernilai null
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service belum aktif');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission ditolak, gagal request permission');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
