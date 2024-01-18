import 'dart:io';
import 'package:dikantin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Inisialisasi FCMService

  // Menonaktifkan rotasi ke mode lanskap
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    GetMaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(
        () async {
          // final fmcToken = await messaging.getToken();
          // TokenController tokenController = TokenController();
          // tokenController.saveToStorage(fmcToken, 'tokenFirebase');
          // debugPrint(fmcToken);
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          messaging.requestPermission();

          FirebaseMessaging.onMessage.listen(
            (RemoteMessage message) async {
              FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
                  FlutterLocalNotificationsPlugin();

              const AndroidNotificationDetails androidPlatformChannelSpecifics =
                  AndroidNotificationDetails('DiPujasKantin', 'DiPujasKantin',
                      importance: Importance.max,
                      priority: Priority.high,
                      showWhen: false);
              const NotificationDetails platformChannelSpecifics =
                  NotificationDetails(android: androidPlatformChannelSpecifics);

              await flutterLocalNotificationsPlugin.show(
                0, // ID notifikasi
                message.notification!.title, // Judul notifikasi dari pesan FCM
                message.notification!.body,
                // Isi notifikasi dari pesan FCM
                platformChannelSpecifics,
              );
            },
          );
        },
      ),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
