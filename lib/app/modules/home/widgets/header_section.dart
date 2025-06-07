// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../routes/app_pages.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

class Header extends StatelessWidget {
  Header({super.key, required this.formKey, required this.controller});

  final HomeController controller;
  final profileController = Get.find<ProfileController>();

  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 97.5.h,
          color: const Color(0xFF1E2857),
        ),
        Positioned(
          top: -5.h,
          right: 0.w,
          child: Image.asset(
            'assets/images/logo_dikantin_putih.png',
            width: 90.w,
            height: 90.h,
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Text(
                'Antar ke :',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    color: Colors.white,
                    size: 20.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Skeletonizer(
                          child: Container(
                            margin: EdgeInsets.only(right: 90.w),
                            height: 23.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.MY_PROFILE);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 90.w),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          height: 23.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  profileController
                                          .users.value?.building?.name ??
                                      'Pilih Lokasi',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Icon(
                                CupertinoIcons.chevron_down,
                                color: Colors.grey,
                                size: 18.r,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 13.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: FormBuilder(
                    key: formKey,
                    child: FormBuilderTextField(
                      name: "search",
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          size: 22.r,
                          color: Colors.black87,
                        ),
                        hintText: "Cari Seleramu",
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black54,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 10.w,
                        ),
                      ),
                      onChanged: (value) {
                        if (value!.isNotEmpty) {
                          controller.getSearchMenu(query: value);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
