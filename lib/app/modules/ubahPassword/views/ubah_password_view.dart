import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ubah_password_controller.dart';

class UbahPasswordView extends GetView<UbahPasswordController> {
  const UbahPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Password',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: controller.newPassword,
                  initialValue: null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Password",
                    hintText: "**************",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Confirm Password',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: controller.confirmPassword,
                  initialValue: null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Password",
                    hintText: "**************",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updatePassword();
                    },
                    child: Text("Update Password"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(
                          MediaQuery.of(context).size.width * 0.9,
                          50)), // Adjust the width and height as needed
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
