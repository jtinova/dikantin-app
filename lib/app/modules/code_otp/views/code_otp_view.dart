// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:async';

import 'package:dikantin_app_rebuild/app/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/code_otp_controller.dart';

class CodeOtpView extends GetView<CodeOtpController> {
  CodeOtpView({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  // Variables to track back button
  int _backButtonPressCount = 0;
  late Timer _timer;

  // Variable to store the OTP code
  String _otpCode = '';

  // Function to check if the keyboard is visible
  bool isKeyboardVisible(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.viewInsets.bottom > 0;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        Get.arguments as Map<String, dynamic>;
    final String email = arguments['email'];

    return WillPopScope(
      onWillPop: () async {
        if (_backButtonPressCount == 0) {
          // start a timer to reset the count if not pressed again
          _backButtonPressCount++;
          _timer = Timer(const Duration(seconds: 1), () {
            _backButtonPressCount = 0;
          });
          // Show a snackbar or toast indicating press again to exit
          Get.snackbar(
            "Informasi ",
            "Tekan sekali lagi untuk keluar",
            animationDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1650),
            backgroundColor: const Color.fromARGB(255, 238, 238, 238),
            borderWidth: 5.0,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(20.0),
            icon: const Icon(
              CupertinoIcons.info_circle,
            ),
          );
          return false; // Do not exit the app yet
        } else {
          // Second press within the timer duration, exit the app
          _timer.cancel(); // Cancel the timer
          return true; // Allow the app to exit
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            physics: isKeyboardVisible(context)
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo_dikantin.png',
                        width: 180,
                        height: 180,
                      ),
                    ),
                    Center(
                      child: const Text(
                        'Kode OTP',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2857),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    RichText(
                      textAlign: TextAlign.center,
                      textScaleFactor: 0.85,
                      text: TextSpan(
                        text: "Kami telah mengirimkan kode OTP ke ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                        children: [
                          TextSpan(
                            text: email,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " masukan kode tersebut untuk melanjutkan",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FormBuilder(
                      key: _formKey,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        pastedTextStyle: const TextStyle(
                          color: Color(0xFF1E2857),
                          fontWeight: FontWeight.bold,
                        ),
                        obscureText: false,
                        blinkWhenObscuring: true,
                        obscuringWidget: const Icon(
                          CupertinoIcons.lock_fill,
                          size: 20,
                          color: Color(0xFF1E2857),
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(15.0),
                          fieldHeight: 55,
                          fieldWidth: 45,
                          activeFillColor: Colors.white,
                          inactiveColor:
                              const Color.fromARGB(255, 225, 225, 225),
                          activeColor: Color(0xFF1E2857),
                          selectedColor: Color(0xFF1E2857),
                        ),
                        animationType: AnimationType.fade,
                        animationDuration: const Duration(milliseconds: 300),
                        keyboardType: TextInputType.number,
                        textStyle: TextStyle(
                          fontSize: 20,
                          height: 1.6,
                        ),
                        onCompleted: (value) {
                          _otpCode = value;

                          Provider.of<AuthenticationProvider>(context,
                                  listen: false)
                              .verifyCodeOTP(
                            email: email.toString().trim(),
                            otp: _otpCode.toString().trim(),
                            context: context,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 35),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Consumer<AuthenticationProvider>(
                          builder: (context, auth, child) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            if (auth.resMessage != '') {
                              Get.snackbar(
                                "Informasi",
                                auth.resMessage,
                                animationDuration:
                                    const Duration(milliseconds: 200),
                                duration: const Duration(milliseconds: 1650),
                                backgroundColor: auth.statusCode == 200
                                    ? Colors.green
                                    : Colors.red,
                                colorText: Colors.white,
                                borderWidth: 5.0,
                                snackPosition: SnackPosition.TOP,
                                margin: const EdgeInsets.all(20.0),
                                icon: const Icon(
                                  CupertinoIcons.info_circle,
                                  color: Colors.white,
                                ),
                              );
                            }

                            auth.clear();
                          },
                        );

                        return ElevatedButton(
                          onPressed: auth.isLoading
                              ? null
                              : () {
                                  if (_otpCode != '') {
                                    auth.verifyCodeOTP(
                                      email: email.toString().trim(),
                                      otp: _otpCode.toString().trim(),
                                      context: context,
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Informasi",
                                      "Kode OTP belum diisi",
                                      animationDuration:
                                          const Duration(milliseconds: 200),
                                      duration:
                                          const Duration(milliseconds: 1650),
                                      backgroundColor: Color(0xFF1E2857),
                                      colorText: Colors.white,
                                      borderWidth: 5.0,
                                      snackPosition: SnackPosition.TOP,
                                      margin: const EdgeInsets.all(20.0),
                                      icon: const Icon(
                                        CupertinoIcons.info_circle,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (auth.isLoading) {
                                  return Colors.grey;
                                }
                                return const Color(0xFF1E2857);
                              },
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          child: auth.isLoading
                              ? Text(
                                  "Loading ...",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  "Verifikasi Kode",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Center(
                      child: Obx(
                        () => GestureDetector(
                          onTap: controller.canResendEmail.value
                              ? () {
                                  controller.resendEmail();

                                  Provider.of<AuthenticationProvider>(context,
                                          listen: false)
                                      .resendEmailOTP(
                                          email: email.toString().trim());
                                }
                              : null,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Belum menerima email?",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF1E2857),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    controller.canResendEmail.value
                                        ? "Kirim Ulang"
                                        : "0.${controller.resendCountDown.value}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E2857),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Get.offAllNamed(Routes.SIGN_IN),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Ingat password akun?",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1E2857),
                            ),
                          ),
                          const Text(
                            " Masuk",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2857),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
