import 'package:dikantin_app_rebuild/app/service/auth_service.dart';
import 'package:dikantin_app_rebuild/app/service/network_service.dart';
import 'package:dikantin_app_rebuild/app/service/fcm_service.dart';
import 'package:dikantin_app_rebuild/app/theme/theme.dart';
import 'package:dikantin_app_rebuild/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'app/modules/sign_in/controllers/api_controller.dart';
import 'app/service/api_service.dart';
import 'app/service/db_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();

  await initServices();

  String? token = await DatabaseProvider().getToken();
  String initialRoute = token != null ? Routes.NAVIGATION : Routes.SIGN_IN;

  runApp(
    // ChangeNotifierProvider(
    //   create: (context) => AuthenticationProvider(),
    //   child: DevicePreview(
    //     enabled: !kReleaseMode,
    //     builder: (context) => MyApp(initialRoute: initialRoute),
    //   ),
    // ),
    ChangeNotifierProvider(
      create: (context) => AuthenticationProvider(),
      child: MyApp(initialRoute: initialRoute),
    ),
  );

  FlutterNativeSplash.remove();
}

Future<void> initServices() async {
  Get.put(DatabaseProvider(), permanent: true);
  Get.put(NetworkProvider(), permanent: true);
  Get.put(ApiConfigService(), permanent: true);
  Get.put(ApiController(), permanent: true);
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..maskType = EasyLoadingMaskType.black
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..userInteractions = false
    ..dismissOnTap = false
    ..indicatorSize = 30.sp
    ..textStyle = TextStyle(
      fontSize: 15.sp,
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
        configLoading();

        return GetMaterialApp(
          useInheritedMediaQuery: true,
          // locale: DevicePreview.locale(context),
          title: "Dikantin",
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
