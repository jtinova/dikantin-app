import 'package:dikantin/app/modules/utils/Konfirmasi.dart';
import 'package:dikantin/app/modules/utils/kirim.dart';
import 'package:dikantin/app/modules/utils/proses.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;

import '../../utils/belumbayar.dart';
import '../controllers/pesanan_controller.dart';

class PesananView extends GetView<PesananController> {
  PesananView({Key? key}) : super(key: key);
  PesananController pesananController = Get.find<PesananController>();

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final mediaHeight = MediaQuery.of(context).size.height;
    final myAppbar = AppBar(
      elevation: 5, // Menghilangkan shadow di bawah AppBar
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Pesanan Saya ",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
      title: Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
        child: Image.asset(
          'assets/logo_dikantin.png',
          height: 90, // Sesuaikan dengan tinggi yang Anda inginkan
          width: 90, // Sesuaikan dengan lebar yang Anda inginkan
          fit: BoxFit.cover,
        ),
      ),
      bottom: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          controller: pesananController.tabController,
          tabs: [
            Tab(child: Obx(() {
              final pesananProses = controller.pesananProses.data ?? [];
              final jumlahTransaksi = pesananProses
                  .where((pesanan) =>
                      pesanan.transaksi!.detailTransaksi!.isNotEmpty)
                  .length;
              final showBadge = pesananController.orderProses.isNotEmpty &&
                  jumlahTransaksi != 0;

              return badges.Badge(
                showBadge: showBadge,
                badgeAnimation: const badges.BadgeAnimation.slide(),
                badgeContent: Text(
                  jumlahTransaksi.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: -10, end: -15),
                badgeStyle: const badges.BadgeStyle(
                  shape: badges.BadgeShape.circle,
                  badgeColor: Colors.orange,
                ),
                child: const Text(
                  "Diproses",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              );
            })),
            Tab(child: Obx(() {
              return badges.Badge(
                showBadge: (pesananController.orderDikirim.isNotEmpty ?? true),
                badgeAnimation: const badges.BadgeAnimation.slide(),
                badgeContent: Text(
                  (pesananController.orderDikirim.length ?? 0).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: -10, end: -15),
                badgeStyle: const badges.BadgeStyle(
                  shape: badges.BadgeShape.circle,
                  badgeColor: Colors.orange,
                ),
                child: const Text(
                  "Dikirim",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              );
            })),
            Tab(child: Obx(() {
              final pesananBelumBayar = controller.belumbayar.data ?? [];
              final jumlahTransaksi = pesananBelumBayar
                  .where((pesanan) =>
                      pesanan.transaksi!.detailTransaksi!.isNotEmpty)
                  .length;
              final showBadge = pesananController.belumBayar.isNotEmpty &&
                  jumlahTransaksi != 0;

              return badges.Badge(
                showBadge: showBadge,
                badgeAnimation: const badges.BadgeAnimation.slide(),
                badgeContent: Text(
                  jumlahTransaksi.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: -10, end: -15),
                badgeStyle: const badges.BadgeStyle(
                  shape: badges.BadgeShape.circle,
                  badgeColor: Colors.orange,
                ),
                child: const Text(
                  "Belum bayar",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              );
            })),
          ],
          labelStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold, // Font Weight untuk yang terpilih
            ),
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.normal, // Font Weight untuk yang tidak terpilih
            ),
          )),
    );
    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
          textScaler:
              TextScaler.linear(query.textScaleFactor.clamp(1.0, 1.15))),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: myAppbar,
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TabBarView(
                  controller: pesananController.tabController,
                  children: const [Proses(), Kirim(), belumbayar()]),
            )),
      ),
    );
  }
}
