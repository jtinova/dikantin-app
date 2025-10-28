import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class CourierProfile extends StatelessWidget {
  CourierProfile({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Simpan',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: TextButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          child: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
            size: 25.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo_dikantin.png'),
              backgroundColor: Colors.black12,
              radius: 50.r,
            ),
            SizedBox(height: 5.h),
            Text(
              "Ubah Foto",
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 30.h),
            FormBuilder(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(25.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama :',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    FormBuilderTextField(
                      name: "name",
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black87,
                      ),
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          CupertinoIcons.person,
                          size: 18.sp,
                          color: Colors.black87,
                        ),
                        hintText: "Masukan Nama",
                        hintStyle: TextStyle(
                          fontSize: 18.sp,
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
                          vertical: 15.h,
                          horizontal: 15.w,
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Email :',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    FormBuilderTextField(
                      name: "email",
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black87,
                      ),
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          CupertinoIcons.mail,
                          size: 18.sp,
                          color: Colors.black87,
                        ),
                        hintText: "Masukan email",
                        hintStyle: TextStyle(
                          fontSize: 18.sp,
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
                          vertical: 15.h,
                          horizontal: 15.w,
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'No Telepon :',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                     SizedBox(height: 5.h),
                    FormBuilderTextField(
                      name: "no_telp",
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black87,
                      ),
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      decoration: InputDecoration(
                        prefixIcon:  Icon(
                          CupertinoIcons.phone,
                          size: 18.sp,
                          color: Colors.black87,
                        ),
                        hintText: "No Telepon",
                        hintStyle: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black54,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.r),
                          ),
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.r),
                          ),
                          borderSide: BorderSide(color: Colors.black87),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 15.w,
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Alamat :',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    FormBuilderTextField(
                      name: "address",
                      keyboardType: TextInputType.streetAddress,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black87,
                      ),
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          CupertinoIcons.mail,
                          size: 18.sp,
                          color: Colors.black87,
                        ),
                        hintText: "Alamat",
                        hintStyle: TextStyle(
                          fontSize: 18.sp,
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
                          vertical: 15.h,
                          horizontal: 15.w,
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
