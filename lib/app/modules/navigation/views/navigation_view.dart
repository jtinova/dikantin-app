import 'package:carbon_icons/carbon_icons.dart';
import 'package:dikantin/app/modules/home/views/home_view.dart';
import 'package:dikantin/app/modules/pesanan/views/pesanan_view.dart';
import 'package:dikantin/app/modules/profile/views/profile_view.dart';
import 'package:dikantin/app/modules/riwayat/views/riwayat_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../pesanan/controllers/pesanan_controller.dart';
import '../../riwayat/controllers/riwayat_controller.dart';
import '../controllers/navigation_controller.dart';

class NavigationView extends GetView<NavigationController> {
  NavigationView({Key? key}) : super(key: key);
  final PesananController pesananController = Get.put(PesananController());
  final RiwayatController riwayatController = Get.put(RiwayatController());
  final HomeController homeController = Get.put(HomeController());
  final NavigationController nav = Get.put(NavigationController());
  DateTime? currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 1)) {
        currentBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          // Perubahan di sini
          SnackBar(
            content: Text('Tekan sekali lagi untuk keluar'),
          ),
        );
        return Future.value(false);
      }
      return Future.value(true);
    }

    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.black, // Atur warna latar belakang Scaffold

          body: GetBuilder<NavigationController>(
            builder: (controller) {
              return IndexedStack(
                index: controller.tabIndex,
                children: [
                  HomeView(),
                  PesananView(),
                  RiwayatView(),
                  ProfileView()
                ],
              );
            },
          ),
          bottomNavigationBar: GetBuilder<NavigationController>(
            builder: (controller) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 0.0, // to get rid of the shadow
                backgroundColor: Colors
                    .white, // transparent, you could use 0x44aaaaff to make it slightly less transparent with a blue hue.
                currentIndex: controller.tabIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Color(0xFFD0E0FE),
                onTap: (index) {
                  if (index == 0) {
                    homeController.refreshData();
                    nav.checkToken();
                  } else if (index == 1) {
                    pesananController.refreshPesanan();
                    nav.checkToken();
                  } else if (index == 2) {
                    riwayatController.searchAll();
                    nav.checkToken();
                  } else if (index == 3) {
                    nav.checkToken();
                  }
                  controller.updateCurrentScreen(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded, size: 30),
                    label: 'Beranda',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.my_library_books, size: 30),
                    label: 'Pesanan',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history_rounded, size: 30),
                    label: 'Riwayat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CarbonIcons.user_avatar_filled, size: 30),
                    label: 'Profil',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
