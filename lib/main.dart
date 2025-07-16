import 'package:dikantin_app_rebuild/app/data/auth_provider.dart';
import 'package:dikantin_app_rebuild/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:dikantin_app_rebuild/app/data/auth_canteen_provider.dart';

import 'app/data/db_provider.dart';
import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init(); 
  // Check if a token exists before launching the app
  String? token = await DatabaseProvider().getToken();
  String initialRoute = token != null ? Routes.SIGN_IN : Routes.NAVIGATION;

  runApp(MyApp(initialRoute: initialRoute));


  FlutterNativeSplash.remove();
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..maskType = EasyLoadingMaskType.black
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..userInteractions = false
    ..dismissOnTap = false
    ..indicatorSize = 35
    ..textStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
    );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => AuthCanteenProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider())
      ],
      child: GetMaterialApp(
        title: "Dikantin App Rebuild",
        initialRoute: initialRoute,
        theme: lightMode,
        getPages: AppPages.routes,
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
