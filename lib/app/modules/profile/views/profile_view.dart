import 'package:dikantin_app_rebuild/app/data/auth_provider.dart';
import 'package:dikantin_app_rebuild/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  @override
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      if (controller.users.value != null) {
                        return Column(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/logo_dikantin.png'),
                              backgroundColor: Colors.black12,
                              radius: 48.r,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              controller.users.value!.fullName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              controller.users.value!.email,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/logo_dikantin.png'),
                              backgroundColor: Colors.black12,
                              radius: 48.r,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Data User Tidak Ditemukan",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                    SizedBox(height: 40.h),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.MY_PROFILE),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.pencil,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10.h),
                            Text(
                              'Profile Saya',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.ABOUT_APP),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.info_circle,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Informasi Aplikasi',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              content: Text(
                                "Kamu yakin ingin logout?",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                              ),
                              backgroundColor: Colors.white,
                              actions: [
                                SizedBox(
                                  width: 90.w,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Color(0xFF1E2857),
                                      ),
                                    ),
                                    child: Text(
                                      "Batal",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Consumer<AuthenticationProvider>(
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

                                        auth.clear();
                                      }
                                    },
                                  );
                                  return TextButton(
                                    onPressed: () {
                                      auth.logoutUser();
                                    },
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.square_arrow_left,
                              color: Colors.red,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Keluar',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
