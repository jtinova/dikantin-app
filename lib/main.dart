import 'package:device_preview/device_preview.dart';
import 'package:dikantin_app_rebuild/app/data/auth_provider.dart';
import 'package:dikantin_app_rebuild/app/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'app/data/db_provider.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Check if a token exists before launching the app
  String? token = await DatabaseProvider().getToken();
  String initialRoute = token != null ? Routes.NAVIGATION : Routes.SIGN_IN;

  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(initialRoute: initialRoute),
  //   ),
  // );

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
    ..indicatorSize = 25.sp
    ..textStyle = TextStyle(
      fontSize: 35.sp,
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
        ChangeNotifierProvider(create: (_) => DatabaseProvider())
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: GetMaterialApp(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          title: "Dikantin App Rebuild",
          initialRoute: initialRoute,
          theme: lightMode,
          getPages: AppPages.routes,
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
