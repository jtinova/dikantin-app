import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProfile extends StatelessWidget {
  MyProfile({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil Kantin",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final canteen = controller.users.value; // Tipe: Canteen?

          return Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/logo_dikantin.png'),
                    backgroundColor: Colors.black12,
                    radius: 50.r,
                  ),
                ),
                SizedBox(height: 30.h),

                _buildReadOnlyField("Nama Kantin", canteen?.name ?? ''),
                _buildReadOnlyField("Email", canteen?.email ?? ''),
                _buildReadOnlyField("Nomor Telepon", canteen?.phoneNumber ?? ''),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 5.h),
        TextFormField(
          enabled: false,
          initialValue: value,
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}
