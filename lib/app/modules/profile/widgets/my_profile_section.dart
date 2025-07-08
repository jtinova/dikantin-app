import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/profile_controller.dart';

class MyProfile extends StatelessWidget {
  MyProfile({super.key});

  final ProfileController controller = Get.put(ProfileController());
  final homeController = Get.find<HomeController>();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 80.w,
              height: 30.h,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final formData = _formKey.currentState!.value;

                    final String? fullName = formData['name'];
                    final String? phoneNumber = formData['no_telp'];
                    final String? buildingId = formData['building_id'];
                    final String? detailAddress = formData['detail_address'];

                    controller.updateUserData(
                      fullName: fullName.toString(),
                      phoneNumber: phoneNumber.toString().trim(),
                      buildingId: buildingId.toString(),
                      detailAddress: detailAddress.toString(),
                      context: context,
                    );

                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E2857),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
        leading: TextButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          child: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
            size: 25.r,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Obx(() {
                    var user = controller.users.value;

                    return FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo_dikantin.png'),
                            backgroundColor: Colors.black12,
                            radius: 53.r,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Ubah Foto",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 30.h),
                          _buildFormField(
                            "Nama",
                            "name",
                            user?.fullName,
                            CupertinoIcons.person,
                          ),
                          _buildFormField(
                            "Email",
                            "email",
                            user?.email,
                            CupertinoIcons.mail,
                            email: true,
                          ),
                          _buildFormField(
                            "No Telepon",
                            "no_telp",
                            user?.phoneNumber,
                            CupertinoIcons.phone,
                          ),
                          _buildBuildingDropdown(user),
                          _buildFormField(
                            "Detail Lokasi",
                            "detail_address",
                            user?.detailAddress,
                            CupertinoIcons.location_solid,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFormField(
      String label, String name, String? initialValue, IconData icon,
      {bool email = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5.h),
        FormBuilderTextField(
          name: name,
          initialValue: initialValue ?? '',
          enabled: !email,
          keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            if (email) FormBuilderValidators.email(),
          ]),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 18.r,
              color: icon == CupertinoIcons.mail ? Colors.grey : Colors.black87,
            ),
            hintText: "Masukkan $label",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.r),
              ),
              borderSide: BorderSide(color: Colors.black87),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildBuildingDropdown(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Lokasi Gedung",
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
        ),
        SizedBox(height: 5.h),
        Obx(() {
          if (homeController.buildings.isEmpty) {
            return Text("Memuat daftar gedung...");
          }

          return FormBuilderDropdown<String>(
            name: "building_id",
            initialValue: user?.building?.id,
            decoration: InputDecoration(
              prefixIcon: Icon(
                CupertinoIcons.location_solid,
                size: 18.r,
              ),
              hintText: "Pilih Lokasi",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
                borderSide: BorderSide(color: Colors.black87),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
            ),
            items: homeController.buildings.map((building) {
              return DropdownMenuItem<String>(
                value: building.id,
                child: Text(
                  building.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              final selected = homeController.buildings.firstWhereOrNull(
                (b) => b.id == value,
              );

              homeController.selectedLocation.value =
                  selected?.name ?? 'Pilih Lokasi';
            },
            validator: FormBuilderValidators.required(),
          );
        }),
        SizedBox(height: 20.h),
      ],
    );
  }
}
