import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

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
            fontSize: 20,
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
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/logo_dikantin.png'),
                    backgroundColor: Colors.black12,
                    radius: 50,
                  ),
                ),
                const SizedBox(height: 30),

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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextFormField(
          enabled: false,
          initialValue: value,
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
