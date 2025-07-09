// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:async';

import 'package:dikantin_app_rebuild/app/data/auth_provider.dart';
import 'package:dikantin_app_rebuild/app/modules/sign_in/controllers/api_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  SignInView({super.key});

  final _formKey = GlobalKey<FormBuilderState>();
  final _obscureText = true.obs;

  int _backButtonPressCount = 0;
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    final apiController = Get.find<ApiController>();

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
                            height: 180.h,
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
                              FormBuilderTextField(
                                name: "email",
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    CupertinoIcons.mail,
                                    size: 16.sp,
                                    color: Colors.black87,
                                  ),
                                  hintText: "Masukan email",
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
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.email(),
                                ]),
                              ),
                              SizedBox(height: 7.h),
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
                                        _obscureText.value
                                            ? CupertinoIcons.eye
                                            : CupertinoIcons.eye_slash,
                                        size: 16.sp,
                                        color: Colors.black87,
                                      ),
                                      onPressed: () {
                                        _obscureText.toggle();
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
                                  obscureText: _obscureText.value,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () =>
                                          Get.offAllNamed(Routes.SEND_EMAIL),
                                      child: Center(
                                        child: Text(
                                          "Lupa password?",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1E2857),
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
                                      duration:
                                          const Duration(milliseconds: 1650),
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
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    final formData =
                                        _formKey.currentState!.value;

                                    final String? email = formData['email'];
                                    final String? password =
                                        formData['password'];

                                    auth.loginUser(
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
                                ),
                                child: Text(
                                  "Masuk",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 7.h),
                        SizedBox(
                          width: double.infinity,
                          height: 45.h,
                          child: ElevatedButton(
                            onPressed: () => Get.offAllNamed(Routes.SIGN_UP),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                                side: const BorderSide(
                                  color: Color(0xFF1E2857),
                                ),
                              ),
                            ),
                            child: Text(
                              "Daftar",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E2857),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 80.h),
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

  void _showApiBottomSheet(BuildContext context, ApiController controller) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.6,
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengaturan API',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  color: Color(0xFF1E2857),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(() {
                return Column(
                  children: controller.apiEnvironments.keys.map((env) {
                    return RadioListTile<String>(
                      title: Text(env),
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextField(
                      controller: controller.customUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL API Custom',
                        hintText: 'http://...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.saveApiSetting();
                  },
                  child: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E2857),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
