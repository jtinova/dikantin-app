import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  static const Color primaryColor = Color(0xFF1E2857);

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController c = Get.put(ForgotPasswordController());
    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Image.asset(
                    'assets/logo_dikantin.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                Text(
                  "Lupa Password",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  "Masukkan email Anda yang terdaftar",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                // TextField Email
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: c.emailController,
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline, color: Colors.grey[400], size: 20),
                      hintText: 'Masukkan email',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol Reset Password
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await EasyLoading.show(
                        status: 'loading...',
                        maskType: EasyLoadingMaskType.black,
                      );
                      await c.forgotPassword(
                        email: c.emailController.text,
                      );
                      EasyLoading.dismiss();
                    },
                    child: Text(
                      "Reset Password",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Text dan Tombol Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ingat password akun? ",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        c.emailController.clear();
                        Get.toNamed('/login');
                      },
                      child: Text(
                        "Masuk",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}