import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../controllers/otp_page_controller.dart';

class OtpPageView extends GetView<OtpPageController> {
  const OtpPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final OtpPageController c = Get.put(OtpPageController());
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
          child: Column(
            children: [
              Center(
                child: Text(
                  "Masukan Kode OTP anda",
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "dan jangan bagikan kode tersebut \nkepada orang lain",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              OtpTextField(
                numberOfFields: 4,
                borderColor: Color(0xFF512DA8),
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) async {
                  await c.verifyCode(verificationCode);
                  print(verificationCode);
                }, // end onSubmit
              ),
            ],
          ),
        ),
      ),
    );
  }
}
