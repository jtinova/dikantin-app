import 'package:dikantin_partner/app/data/auth_canteen_provider.dart';
import 'package:dikantin_partner/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 17.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: Center(
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
                        backgroundColor: Colors.grey[100],
                        radius: 53.r,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        controller.users.value!.name,
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
              SizedBox(height: 35.h),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.MY_PROFILE),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.pencil,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Profile Saya',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.ABOUT_APP),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.info_circle,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Informasi Aplikasi',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Kamu yakin ingin logout?"),
                        backgroundColor: Colors.white,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Color(0xFF1E2857)),
                            ),
                            child: Text(
                              "Batal",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Consumer<AuthCanteenProvider>(
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
                                    margin: EdgeInsets.all(20.w),
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
                                auth.logoutCanteen();
                              },
                              child: Text(
                                "Logout",
                                style: TextStyle(
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
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.square_arrow_left,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17.sp,
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
  }
}
