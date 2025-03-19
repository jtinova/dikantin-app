// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:async';

import 'package:dikantin_app_rebuild/app/data/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  SignUpView({super.key});

  final _formKey = GlobalKey<FormBuilderState>();
  final _obscurePassword = true.obs;
  final _obscureConfPassword = true.obs;

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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      'Registrasi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2857),
                      ),
                    ),
                  ),
                  Center(
                    child: const Text(
                      'Buat akun anda untuk melanjutkan',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormBuilderTextField(
                          name: "fullname",
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                          scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              CupertinoIcons.person,
                              size: 18,
                              color: Colors.black87,
                            ),
                            hintText: "Masukan nama lengkap",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          name: "phone_number",
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                          scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              CupertinoIcons.phone,
                              size: 18,
                              color: Colors.black87,
                            ),
                            hintText: "Masukan nomor telepon",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(11),
                          ]),
                        ),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          name: "email",
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                          scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              CupertinoIcons.mail,
                              size: 18,
                              color: Colors.black87,
                            ),
                            hintText: "Masukan email",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ]),
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => FormBuilderTextField(
                            name: "password",
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                            scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                CupertinoIcons.lock,
                                size: 18,
                                color: Colors.black87,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword.value
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash,
                                  size: 18.0,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  _obscurePassword.toggle();
                                },
                              ),
                              hintText: "Masukan password",
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(color: Colors.black87),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(color: Colors.black87),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                            ),
                            obscureText: _obscurePassword.value,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(8),
                            ]),
                          ),
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => FormBuilderTextField(
                            name: "confirm_password",
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                            scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                CupertinoIcons.lock,
                                size: 18,
                                color: Colors.black87,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfPassword.value
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash,
                                  size: 18.0,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  _obscureConfPassword.toggle();
                                },
                              ),
                              hintText: "Masukan konfirmasi password",
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(color: Colors.black87),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(color: Colors.black87),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                            ),
                            obscureText: _obscureConfPassword.value,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(8),
                            ]),
                          ),
                        ),
                      ],
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final formData = _formKey.currentState!.value;

                            final String? fullName = formData['fullname'];
                            final String? phone = formData['phone_number'];
                            final String? email = formData['email'];
                            final String? password = formData['password'];
                            final String? confirmPassword =
                                formData['confirm_password'];

                            if (confirmPassword == password) {
                              auth.registerUser(
                                fullName: fullName.toString(),
                                phoneNumber: phone.toString().trim(),
                                email: email.toString().trim(),
                                password: confirmPassword.toString().trim(),
                                context: context,
                              );
                            } else {
                              Get.snackbar(
                                "Informasi ",
                                "Password Tidak Sesuai",
                                animationDuration:
                                    const Duration(milliseconds: 200),
                                duration: const Duration(milliseconds: 1650),
                                backgroundColor:
                                    const Color.fromARGB(255, 238, 238, 238),
                                borderWidth: 5.0,
                                snackPosition: SnackPosition.TOP,
                                margin: const EdgeInsets.all(20.0),
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
                          "Daftar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () => Get.offAllNamed(Routes.SIGN_IN),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun? ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF1E2857),
                          ),
                        ),
                        const Text(
                          "Masuk",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2857),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
