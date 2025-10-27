// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:async';

import 'package:dikantin_partner/app/data/auth_canteen_provider.dart';
import 'package:dikantin_partner/app/modules/sign_in/controllers/api_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  SignInView({super.key});

  final _formKey = GlobalKey<FormBuilderState>();
  final _obscureText = true.obs;

  // Variables to track back button
  int _backButtonPressCount = 0;
  late Timer _timer;

  // Function to check if the keyboard is visible
  bool isKeyboardVisible(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.viewInsets.bottom > 0;
  }

  @override
  Widget build(BuildContext context) {
    final apiController = Get.find<ApiController>();
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
            borderWidth: 5.0.w,
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.all(20.0.w),
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
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo_dikantin.png',
                      width: 170.w,
                      height: 170.h,
                    ),
                  ),
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      _showApiBottomSheet(context, apiController);
                    },
                    child: Center(
                      child: Text(
                        'Selamat Datang',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2857),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Masuk ke akun anda untuk melanjutkan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormBuilderTextField(
                          name: "email",
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black87,
                          ),
                          scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              CupertinoIcons.mail,
                              size: 17.sp,
                              color: Colors.black87,
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black54,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.r),
                              ),
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.r),
                              ),
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 10.w,
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ]),
                        ),
                        SizedBox(height: 10.h),
                        Obx(
                          () => FormBuilderTextField(
                            name: "password",
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black87,
                            ),
                            scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                CupertinoIcons.lock,
                                size: 17.sp,
                                color: Colors.black87,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText.value
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash,
                                  size: 17.sp,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  _obscureText.toggle();
                                },
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black54,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.r),
                                ),
                                borderSide: BorderSide(color: Colors.black87),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.r),
                                ),
                                borderSide: BorderSide(color: Colors.black87),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 10.w,
                              ),
                            ),
                            obscureText: _obscureText.value,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 40.h,
                    child: Consumer<AuthCanteenProvider>(
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
                                borderWidth: 5.0.w,
                                snackPosition: SnackPosition.TOP,
                                margin: EdgeInsets.all(20.w),
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
                              final formData = _formKey.currentState!.value;

                              final String? email = formData['email'];
                              final String? password = formData['password'];

                              auth.loginCanteen(
                                email: email.toString().trim(),
                                password: password.toString().trim(),
                                context: context,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1E2857),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            minimumSize: Size(double.infinity, 50.h),
                          ),
                          child: Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 70.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showApiBottomSheet(BuildContext context, ApiController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.6,
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengaturan API',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: Color(0xFF1E2857),
                  ),
                ),
                SizedBox(height: 10.h),
                Obx(() {
                  return Column(
                    children: controller.apiEnvironments.keys.map((env) {
                      return RadioListTile<String>(
                        title: Text(
                          env,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        value: env,
                        groupValue: controller.selectedEnv.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedEnv.value = value;
                          }
                        },
                      );
                    }).toList(),
                  );
                }),
                Obx(() {
                  if (controller.selectedEnv.value == 'Custom') {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: TextField(
                        controller: controller.customUrlController,
                        decoration: const InputDecoration(
                          labelText: 'URL API Custom',
                          hintText: '192.xxx.x.x:xxxx',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                SizedBox(height: 15.h),
                SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.saveApiSetting();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E2857),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
