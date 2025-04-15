import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class MyProfile extends StatelessWidget {
  MyProfile({super.key});

  final ProfileController controller = Get.put(ProfileController());
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 70,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final formData = _formKey.currentState!.value;

                    final String? fullName = formData['name'];
                    final String? phoneNumber = formData['no_telp'];

                    controller.updateUserData(
                      fullName: fullName.toString(),
                      phoneNumber: phoneNumber.toString().trim(),
                      context: context,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E2857),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16,
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
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          child: const Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
            size: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            var user = controller.users.value;

            return FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/logo_dikantin.png'),
                    backgroundColor: Colors.black12,
                    radius: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ubah Foto",
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  SizedBox(height: 30),
                  _buildFormField(
                    "Nama :",
                    "name",
                    user?.fullName,
                    CupertinoIcons.person,
                  ),
                  _buildFormField(
                    "Email :",
                    "email",
                    user?.email,
                    CupertinoIcons.mail,
                    email: true,
                  ),
                  _buildFormField(
                    "No Telepon :",
                    "no_telp",
                    user?.phoneNumber,
                    CupertinoIcons.phone,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFormField(
      String label, String name, String? initialValue, IconData icon,
      {bool email = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, color: Colors.black)),
        SizedBox(height: 5),
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
              size: 18,
              color: icon == CupertinoIcons.mail ? Colors.grey : Colors.black87,
            ),
            hintText: "Masukkan $label",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(color: Colors.black87),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
