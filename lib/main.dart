import 'package:dikantin_partner/app/data/auth_provider.dart';
import 'package:dikantin_partner/app/theme/theme.dart';
import 'package:dikantin_partner/app/modules/sign_in/controllers/api_controller.dart';
import 'package:dikantin_partner/app/service/fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dikantin_partner/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:dikantin_partner/app/data/auth_canteen_provider.dart';

import 'app/data/db_provider.dart';
import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();

  await GetStorage.init();
  // Check if a token exists before launching the app
  Get.put(ApiController());
  String? token = await DatabaseProvider().getToken();
  String initialRoute = token != null ? Routes.NAVIGATION : Routes.SIGN_IN;

  await ScreenUtil.ensureScreenSize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthCanteenProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );

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
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Dikantin Partner",
          initialRoute: initialRoute,
          theme: lightMode,
          getPages: AppPages.routes,
          builder: (context, widget) {
            final mediaQuery = MediaQuery.of(context);
            final newMediaQuery = mediaQuery.copyWith(
              size: Size(
                mediaQuery.size.width,
                mediaQuery.size.height,
              ),
              textScaler: TextScaler.linear(
                0.85,
              ),
            );

            widget = EasyLoading.init()(context, widget);
            return MediaQuery(
              data: newMediaQuery,
              child: widget,
            );
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
