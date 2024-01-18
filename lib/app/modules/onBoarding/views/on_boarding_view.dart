import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/on_boarding_controller.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  const OnBoardingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);

    return MediaQuery(
      data: query.copyWith(
          textScaleFactor: query.textScaleFactor.clamp(1.0, 1.15)),
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              Image.asset(
                "assets/Onboarding.png",
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.width / 1.5,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  "WELCOME TO DIKANTIN",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 2.5,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(
                    MediaQuery.of(context).size.width -
                        30, // Sesuaikan sesuai kebutuhan
                    0, // Tinggi minimum, 0 agar mengikuti tinggi teks
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal:
                        0, // Set horizontal padding ke 0 agar tidak mempengaruhi lebar minimum
                  ),
                ),
                onPressed: () {
                  Get.offAllNamed("/login");
                },
                child: const Text("Mulai", style: TextStyle(fontSize: 20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
