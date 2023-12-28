import 'package:dikantin/app/data/providers/services.dart';
import 'package:dikantin/app/modules/order/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    // final OrderController orderController = Get.find<OrderController>();
    final OrderController orderController = Get.put(OrderController());
    final mediaHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    void addressBottomsheet(BuildContext context) {
      Get.bottomSheet(Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.30,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: profileController.addressController,
                  decoration: InputDecoration(
                    hintText: 'Tolong Inputkan alamat dengan lengkap',
                    filled: true,
                    fillColor: Colors.grey[200], // Atur warna latar belakang
                    hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 12), // Atur warna teks hintText
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 30.0,
                        horizontal: 15.0), // Sesuaikan nilai vertical
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2579FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await orderController.determinePosition();
                      orderController.locationMessage.value =
                          "${orderController.myPosition.value.latitude} ${orderController.myPosition.value.longitude}";
                      orderController.getAddressFromLatLong(
                          orderController.myPosition.value);
                      profileController.addressController.text =
                          orderController.addressMessage.value;
                    },
                    child: Text(
                      'Lokasi saat ini',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2579FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      profileController.editAlamat(
                          alamat: profileController.addressController.text);
                      Get.back();
                    },
                    child: Text(
                      'Simpan',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    }

    final myAppbar = AppBar(
      centerTitle: true,
      title: Text(
        "Edit Profile",
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
              color: Colors.blue,
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
                  size: 17.0,
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
                              "assets/Animation_logout.json", // Ganti dengan nama file Lottie Anda
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
                                child: Text('Ya'),
                                onPressed: () {
                                  profileController.logout();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                child: Text('Tidak'),
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.red,
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
    print('textscalefactor: ${query.textScaleFactor}');
    print('devicePixelRatio: ${query.devicePixelRatio}');
    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        appBar: myAppbar,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 120.0,
                  height: 120.0,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(
                        () => CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              profileController.profile.value.data?.foto != null
                                  // ignore: dead_code
                                  ? NetworkImage(
                                      Api.gambar +
                                          profileController
                                              .profile.value.data!.foto!
                                              .toString(),
                                    ) as ImageProvider<Object>
                                  : AssetImage("assets/logo_dikantin.png"),
                        ),
                      ),
                      Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 16.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Panggil fungsi pickImage saat ikon edit ditekan
                            profileController.pickImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        "FULL NAME",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 25, top: 10),
                child: Obx(
                  () => TextField(
                    style: TextStyle(
                      fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                    ),
                    controller: profileController.fullNameController
                      ..text = profileController.profile.value.data?.nama ?? '',
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 126, 70, 70)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 25, top: 10),
                child: Obx(
                  () => TextField(
                    style: TextStyle(
                      fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                    ),
                    controller: profileController.emailController
                      ..text =
                          profileController.profile.value.data?.email ?? '',
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Menentukan radius untuk membuat bentuk rounded
                        borderSide: BorderSide(
                            color:
                                Colors.black), // Menentukan warna garis pinggir
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Menentukan warna garis pinggir saat fokus
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        "Phone Number",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 25, top: 10),
                child: Obx(
                  () => TextField(
                    style: TextStyle(
                      fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                    ),
                    controller: profileController.phoneNumberController
                      ..text =
                          profileController.profile.value.data?.noTelepon ?? '',
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Menentukan radius untuk membuat bentuk rounded
                        borderSide: BorderSide(
                            color:
                                Colors.black), // Menentukan warna garis pinggir
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Menentukan warna garis pinggir saat fokus
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        "Alamat",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          addressBottomsheet(context);
                        },
                        child: Icon(
                          Icons.edit,
                          size: 24.0,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 25, top: 10),
                child: Obx(
                  () => TextField(
                    style: TextStyle(
                      fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                    ),
                    controller: profileController.addressController
                      ..text =
                          profileController.profile.value.data?.alamat ?? '',
                    maxLines: null, // Memungkinkan input lebih dari satu baris
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200], // Atur warna latar belakang
                      hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 12), // Atur warna teks hintText
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 30.0,
                          horizontal: 15.0), // Sesuaikan nilai vertical
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("Save Change",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  // Call editProfile function from the controller
                  await profileController.editProfile(
                    nama: profileController.fullNameController.text,
                    email: profileController.emailController.text,
                    noTelepon: profileController.phoneNumberController.text,
                    alamat: profileController.addressController.text,
                  );
                  await profileController.getCustomerData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
