// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dikantin/app/modules/utils/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../pesananKurir/controllers/pesananKurir_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileKurirView extends GetView<ProfileKurirController> {
  ProfileKurirView({super.key});
  final ProfileKurirController profileKurirController =
      Get.find<ProfileKurirController>();
  final PesananKurirController pesananKurirController =
      Get.find<PesananKurirController>();

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final myAppbar = AppBar(
      centerTitle: true,
      title: Text(
        "Profile",
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            width: 40.0,
            height: 40.0,
            child: Center(
              // Atau bisa juga menggunakan Align
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  size: 20.0,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset(
                              "assets/Animation_logout.json", 
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                "Anda Akan Logout ?",
                                style: TextStyle(
                                  color: Color(0xff3CA2D9),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  print("logout clicked");
                                  profileKurirController.logout();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(
                                  'Ya',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                  'Tidak',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );

    final x = mediaHeight -
        myAppbar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
          textScaler:
              TextScaler.linear(query.textScaleFactor.clamp(1.0, 1.15))),
      child: Scaffold(
        appBar: myAppbar,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes the position of the shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Obx(
                          () => Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(16),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Image.asset(
                                  'assets/logo_dikantin.png',
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profileKurirController.profileKurir.value.data?.nama ?? '',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2,),
                                  Text(
                                    profileKurirController.profileKurir.value.data?.email ?? '',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4,),
                                  Text(
                                    profileKurirController.profileKurir.value.data?.telepon ?? '',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16,horizontal: 8),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pendapatan Kurir',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Obx(
                                      () => Text(
                                        controller.today.value.toRupiah(),
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 24,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Total Pendapatan Hari ini',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_rounded,
                                  color: Colors.blue[600],
                                  size: 40,
                                ),
                                SizedBox(height: 8),
                                Obx(
                                  () => Text(
                                    pesananKurirController.orderUntukDikirim.length.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Untuk Dikirim',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.ssid_chart_rounded,
                                  color: Colors.blue[600],
                                  size: 40,
                                ),
                                SizedBox(height: 8),
                                Obx(
                                  () => Text(
                                    pesananKurirController.orderKonfirmasi.length.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Konfirmasi',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
