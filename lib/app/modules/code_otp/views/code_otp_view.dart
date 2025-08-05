// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:async';

import 'package:dikantin_app_rebuild/app/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/code_otp_controller.dart';

class CodeOtpView extends GetView<CodeOtpController> {
  CodeOtpView({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  int _backButtonPressCount = 0;
  late Timer _timer;

  String _otpCode = '';

  @override
  Widget build(BuildContext context) {
    String email = "";
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      email = Get.arguments['email'] ?? "";
    }

    return WillPopScope(
      onWillPop: () async {
        if (_backButtonPressCount == 0) {
          _backButtonPressCount++;
          _timer = Timer(const Duration(seconds: 1), () {
            _backButtonPressCount = 0;
          });
          Get.snackbar(
            "Informasi ",
            "Tekan sekali lagi untuk keluar",
            animationDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1650),
            backgroundColor: const Color.fromARGB(255, 238, 238, 238),
            borderWidth: 5.w,
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 20.w,
            ),
            icon: const Icon(
              CupertinoIcons.info_circle,
            ),
          );
          return false;
        } else {
          _timer.cancel();
          return true;
        }
      },
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/logo_dikantin.png',
                          width: 180.w,
                          height: 150.h,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Kode OTP',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2857),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      RichText(
                        textAlign: TextAlign.center,
                        textScaleFactor: 0.85,
                        text: TextSpan(
                          text: "Kami telah mengirimkan kode OTP ke ",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black54,
                          ),
                          children: [
                            TextSpan(
                              text: email,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " masukan kode tersebut untuk melanjutkan",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10.sp),
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
                          obscuringWidget: Icon(
                            CupertinoIcons.lock_fill,
                            size: 18.r,
                            color: Color(0xFF1E2857),
                          ),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(15.r),
                            fieldHeight: 55.h,
                            fieldWidth: 45.w,
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
                            fontSize: 20.sp,
                            height: 2.h,
                          ),
                          onCompleted: (value) {
                            _otpCode = value;

                            Provider.of<AuthenticationProvider>(context,
                                    listen: false)
                                .verifyCodeOTP(
                              email: email.toString().trim(),
                              otp: _otpCode.toString().trim(),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        width: double.infinity,
                        height: 45.h,
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
                                  borderWidth: 5.w,
                                  snackPosition: SnackPosition.TOP,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 20.h,
                                    horizontal: 20.w,
                                  ),
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
                            onPressed: () {
                              if (_otpCode != '') {
                                auth.verifyCodeOTP(
                                  email: email.toString().trim(),
                                  otp: _otpCode.toString().trim(),
                                );
                              } else {
                                Get.snackbar(
                                  "Informasi",
                                  "Kode OTP belum diisi",
                                  animationDuration:
                                      const Duration(milliseconds: 200),
                                  duration: const Duration(milliseconds: 1650),
                                  backgroundColor: Color(0xFF1E2857),
                                  colorText: Colors.white,
                                  borderWidth: 5.w,
                                  snackPosition: SnackPosition.TOP,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 20.h,
                                    horizontal: 20.w,
                                  ),
                                  icon: const Icon(
                                    CupertinoIcons.info_circle,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1E2857),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                            ),
                            child: Text(
                              "Verifikasi Kode",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 30.h),
                      Center(
                        child: Obx(
                          () => GestureDetector(
                            onTap: controller.canResendEmail.value
                                ? () {
                                    controller.resendEmail();

                                    Provider.of<AuthenticationProvider>(context,
                                            listen: false)
                                        .resendEmailOTP(
                                      email: email.toString().trim(),
                                    );
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
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF1E2857),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Text(
                                      controller.canResendEmail.value
                                          ? "Kirim Ulang"
                                          : "0.${controller.resendCountDown.value}",
                                      style: TextStyle(
                                        fontSize: 18.sp,
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
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () => Get.offAllNamed(Routes.SIGN_IN),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ingat password akun?",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Color(0xFF1E2857),
                              ),
                            ),
                            Text(
                              " Masuk",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E2857),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
