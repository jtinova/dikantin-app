import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
                fontSize: 18,
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
          child: const Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
            size: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo_dikantin.png'),
              backgroundColor: Colors.black12,
              radius: 50,
            ),
            SizedBox(height: 5),
            Text(
              "Ubah Foto",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 30),
            FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama :',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FormBuilderTextField(
                      name: "name",
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
                          CupertinoIcons.person,
                          size: 18,
                          color: Colors.black87,
                        ),
                        hintText: "Masukan Nama",
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
                    const SizedBox(height: 20),
                    Text(
                      'Email :',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 20),
                    Text(
                      'No Telepon :',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FormBuilderTextField(
                      name: "no_telp",
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
                        hintText: "No Telepon",
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
                    const SizedBox(height: 20),
                    Text(
                      'Alamat :',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FormBuilderTextField(
                      name: "address",
                      keyboardType: TextInputType.streetAddress,
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
                        hintText: "Alamat",
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
