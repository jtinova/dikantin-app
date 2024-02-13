import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final RegisterController c = Get.put(RegisterController());
    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/bg.png'), // Ganti dengan path gambar latar belakang Anda
              fit: BoxFit.cover, // Sesuaikan sesuai kebutuhan Anda
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text("Register",
                      style: TextStyle(
                          fontSize: textScaleFactor <= 1.15 ? 40 : 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: TextField(
                    style: TextStyle(
                      fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                    ),
                    keyboardType: TextInputType.name,
                    controller: c.nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: 'Masukkan nama anda',
                      suffixIcon: Icon(
                        CarbonIcons.user_avatar,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: TextField(
                    style: TextStyle(
                      fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                    ),
                    keyboardType: TextInputType.name,
                    controller: c.emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: 'Masukkan Polije anda',
                      suffixIcon: Icon(
                        CarbonIcons.mail_all,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: TextField(
                    style: TextStyle(
                      fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                    ),
                    controller: c
                        .phoneController, // Anda dapat mengganti controller sesuai kebutuhan
                    keyboardType: TextInputType
                        .phone, // Menentukan jenis keyboard untuk nomor telepon
                    maxLength: 13,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText:
                          'Masukkan nomor telepon anda', // Ubah teks petunjuk
                      suffixIcon: Icon(
                        Icons.phone, // Mengganti ikon ke ikon telepon
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                //   child: TextField(
                //     style: TextStyle(
                //       fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                //     ),
                //     controller: c.addressController,
                //     keyboardType: TextInputType
                //         .streetAddress, // Menentukan jenis keyboard untuk teks
                //     decoration: InputDecoration(
                //       filled: true,
                //       fillColor: Colors.white,
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(20.0),
                //         borderSide: BorderSide(color: Colors.black),
                //       ),
                //       hintText:
                //           'Masukkan alamat lengkap anda', // Ubah teks petunjuk
                //       suffixIcon: Icon(
                //         Icons.location_on, // Mengganti ikon ke ikon alamat
                //       ),
                //     ),
                //   ),
                // ),
                Obx(() {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: TextField(
                      style: TextStyle(
                        fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                      ),
                      controller: c.passwordController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Masukkan password anda',
                        suffixIcon: IconButton(
                          icon: Icon(
                            c.obscureText.value
                                ? CarbonIcons.view_off
                                : CarbonIcons.view,
                          ),
                          onPressed: () {
                            c.toggleObscureText();
                          },
                        ),
                      ),
                      obscureText: c.obscureText.value,
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Color.fromARGB(255, 55, 156, 211),
                      ),
                      onPressed: () async {
                        // Ambil data dari controller
                        final name = controller.nameController.text;
                        final email = controller.emailController.text;
                        final phone = controller.phoneController.text;
                        final password = controller.passwordController.text;
                        await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        // Periksa apakah email mengandung "@student.polije.ac.id"
                        // if (!email.contains("@student.polije.ac.id") &&
                        //     !email.contains("@polije.ac.id")) {
                        //   // Tampilkan pesan kesalahan jika alamat email tidak valid
                        //   Get.snackbar(
                        //       "Error", "Harus menggunakan email Polije");
                        //   EasyLoading.dismiss();
                        //   print('EasyLoading dismiss');
                        //   return;
                        // }

                        // Panggil metode register dari RegisterProvider
                        try {
                          await controller.registerProvider
                              .register(name, email, phone, password);
                          EasyLoading.dismiss();
                          print('EasyLoading dismiss');
                        } catch (e) {
                          // Penanganan kesalahan saat pendaftaran gagal
                          EasyLoading.dismiss();
                          print('EasyLoading dismiss');
                          print('Pendaftaran gagal: $e');
                        }
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        controller.nameController.clear();
                        controller.emailController.clear();
                        controller.phoneController.clear();
                        controller.passwordController.clear();
                        Get.toNamed('/login');
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                        ),
                      ),
                    ),
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
