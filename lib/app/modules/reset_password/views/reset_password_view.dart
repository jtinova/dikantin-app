// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:async';

import 'package:dikantin_app_rebuild/app/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  ResetPasswordView({super.key});

  final _formKey = GlobalKey<FormBuilderState>();
  final _obscurePassword = true.obs;
  final _obscureConfPassword = true.obs;

  int _backButtonPressCount = 0;
  late Timer _timer;

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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2857),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Buat password baru untuk akun anda',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        FormBuilder(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => FormBuilderTextField(
                                  name: "password",
                                  keyboardType: TextInputType.visiblePassword,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      CupertinoIcons.lock,
                                      size: 16.sp,
                                      color: Colors.black87,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword.value
                                            ? CupertinoIcons.eye
                                            : CupertinoIcons.eye_slash,
                                        size: 16.r,
                                        color: Colors.black87,
                                      ),
                                      onPressed: () {
                                        _obscurePassword.toggle();
                                      },
                                    ),
                                    hintText: "Masukan password",
                                    hintStyle: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black54,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.r),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.black87),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.r),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.black87),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 10.w,
                                    ),
                                  ),
                                  obscureText: _obscurePassword.value,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(8),
                                  ]),
                                ),
                              ),
                              SizedBox(height: 7.h),
                              Obx(
                                () => FormBuilderTextField(
                                  name: "confirm_password",
                                  keyboardType: TextInputType.visiblePassword,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black87,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      CupertinoIcons.lock,
                                      size: 16.sp,
                                      color: Colors.black87,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfPassword.value
                                            ? CupertinoIcons.eye
                                            : CupertinoIcons.eye_slash,
                                        size: 16.r,
                                        color: Colors.black87,
                                      ),
                                      onPressed: () {
                                        _obscureConfPassword.toggle();
                                      },
                                    ),
                                    hintText: "Konfirmasi password",
                                    hintStyle: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black54,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.r),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.black87),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.r),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.black87),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 10.w,
                                    ),
                                  ),
                                  obscureText: _obscureConfPassword.value,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(8),
                                  ]),
                                ),
                              ),
                              SizedBox(height: 25.h),
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
                                          duration: const Duration(
                                              milliseconds: 1650),
                                          backgroundColor:
                                              auth.statusCode == 200
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
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        final formData =
                                            _formKey.currentState!.value;

                                        final String? password =
                                            formData['password'];
                                        final String? confirmPassword =
                                            formData['confirm_password'];

                                        if (confirmPassword == password) {
                                          auth.resetPassword(
                                            email: email.toString().trim(),
                                            newPassword: confirmPassword
                                                .toString()
                                                .trim(),
                                          );
                                        } else {
                                          Get.snackbar(
                                            "Informasi ",
                                            "Password Tidak Sesuai",
                                            animationDuration: const Duration(
                                                milliseconds: 200),
                                            duration: const Duration(
                                                milliseconds: 1650),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 238, 238, 238),
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
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF1E2857),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      "Reset Password",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        GestureDetector(
                          onTap: () => Get.offAllNamed(Routes.SIGN_IN),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ingat password akun? ",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Color(0xFF1E2857),
                                ),
                              ),
                              Text(
                                "Masuk",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2857),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 60.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
