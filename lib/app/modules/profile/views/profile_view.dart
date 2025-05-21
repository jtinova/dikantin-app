import 'package:dikantin_app_rebuild/app/data/auth_provider.dart';
import 'package:dikantin_app_rebuild/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
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
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.MY_PROFILE),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.pencil,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Profile Saya',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.ABOUT_APP),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.info_circle,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Informasi Aplikasi',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
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
                                    duration:
                                        const Duration(milliseconds: 1650),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          fontSize: 18,
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
