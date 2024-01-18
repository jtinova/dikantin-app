import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final LoginController c = Get.put(LoginController());
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
                Center(
                  child: Image.asset(
                    'assets/logoBaru.png', // Ganti dengan path gambar Anda
                    width: 200, // Sesuaikan dengan ukuran yang Anda inginkan
                    height: 200,
                  ),
                ),
                Text("Login",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 13,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextField(
                    style: TextStyle(
                      fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                    ),
                    controller: c.emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: 'Masukkan email anda',
                      suffixIcon: Icon(
                        CarbonIcons.user_avatar,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: TextField(
                      style: TextStyle(
                        fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                      ),
                      controller: c.passwordController,
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
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25, left: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          String? token =
                              sharedPreferences.getString('tokenFcm');
                          c.loginKurir(c.emailController.text,
                              c.passwordController.text, token!);
                        },
                        child: Text(
                          "Login sebagai kurir",
                          style: TextStyle(
                              fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed("/forgot-password");
                        },
                        child: Text(
                          "Lupa Password ?",
                          style: TextStyle(
                              fontSize: textScaleFactor <= 1.15 ? 14 : 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: SizedBox(
                    width: 350,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Color.fromARGB(255, 55, 156, 211),
                      ),
                      onPressed: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        String? token = sharedPreferences.getString('tokenFcm');
                        c.login(c.emailController.text,
                            c.passwordController.text, token!);
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: textScaleFactor <= 1.15 ? 15 : 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: 350,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Get.toNamed('/register');
                      },
                      child: Text(
                        "Register",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: textScaleFactor <= 1.15 ? 15 : 15,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 77, 83, 87),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Copyright By : ",
                  style: TextStyle(
                      fontSize: textScaleFactor <= 1.15 ? 15 : 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Center(
                  child: Image.asset(
                    'assets/jti_nova.png', // Ganti dengan path gambar Anda
                    width: 80, // Sesuaikan dengan ukuran yang Anda inginkan
                    height: 80,
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
