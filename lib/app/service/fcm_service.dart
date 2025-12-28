// lib/app/service/fcm_service.dart

import 'dart:convert';
import 'package:dikantin_app_rebuild/app/modules/order/controllers/order_controller.dart';
import 'package:dikantin_app_rebuild/app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dikantin_app_rebuild/firebase_options.dart';
import 'package:get/get.dart';

import '../modules/home_courier/controllers/home_courier_controller.dart';
import '../modules/navigation/controllers/navigation_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Handling a background message: ${message.messageId}");

  // Refresh data pesanan di latar belakang
  if (Get.isRegistered<OrderController>()) {
    final orderController = Get.find<OrderController>();
    await orderController.refreshAll();
  }
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static void _handleNavigation(Map<String, dynamic> data) {
    if (data['type'] == 'new_delivery_task') {
      final arguments = {
        'action': 'open_detail',
        'transaction_id': data['transaction_id'],
        'order_delivery_id': data['order_delivery_id'], 
      };

      if (Get.currentRoute == Routes.NAVIGATION_COURIER || 
          Get.currentRoute == Routes.HOME_COURIER) {
          
        if (Get.isRegistered<HomeCourierController>()) {
          final controller = Get.find<HomeCourierController>();
          controller.handleNotificationArguments(arguments);
        }
      } else {
        Get.offAllNamed(
          Routes.NAVIGATION_COURIER, 
          arguments: arguments
        );
      }
      return; 
    }

    if (data.containsKey('transaction_id')) {
      final String transactionId = data['transaction_id'];
      final String status = data['status'] ?? '';
      final String orderType = data['order_type'] ?? '';

      final arguments = <String, dynamic>{
        'transaction_id': transactionId,
        'order_type': orderType,
        'status': status,
      };

      if (status == 'done' || status == 'cancel') {
        arguments['target_page'] = 3; 
        arguments['go_to'] = Routes.HISTORY_ORDER;
      } 
      else if (status == 'delivered' || status == 'arrived') {
        arguments['target_page'] = 1;
        arguments['target_sub_tab'] = 3;
      }
      else {
        arguments['target_page'] = 1; 
        if (status == 'pending') {
          arguments['target_sub_tab'] = 0;
        } else {
          switch (orderType) {
            case 'dine_in':
              arguments['target_sub_tab'] = 1;
              break;
            case 'take_away':
              arguments['target_sub_tab'] = 2;
              break;
            case 'delivery':
              arguments['target_sub_tab'] = 3;
              break;
            default:
              arguments['target_sub_tab'] = 0;
              break;
          }
        }
      }

      if (Get.isRegistered<NavigationController>() &&
          Get.currentRoute == Routes.NAVIGATION) {
        final navCtrl = Get.find<NavigationController>();
        navCtrl.goToPage(arguments['target_page']);

        Future.delayed(const Duration(milliseconds: 500), () {
          if (arguments['target_page'] == 1) {
            if (Get.isRegistered<OrderController>()) {
              final orderController = Get.find<OrderController>();
              orderController.handleNotificationArguments(arguments);
            }
          } else if (arguments['target_page'] == 3) {
            if (arguments.containsKey('go_to') &&
                arguments['go_to'] == Routes.HISTORY_ORDER) {
              Get.toNamed(Routes.HISTORY_ORDER, arguments: arguments);
            }
          }
        });
      } else {
        Get.offAllNamed(Routes.NAVIGATION, arguments: arguments);
      }
    }
  }

  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          debugPrint(
              'Notifikasi foreground diklik dengan payload: ${response.payload}');
          _handleNavigation(jsonDecode(response.payload!));
        }
      },
    );

    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("Aplikasi dibuka dari notifikasi (Terminated State)");
      Future.delayed(Duration(seconds: 1), () {
        _handleNavigation(initialMessage.data);
      });
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Aplikasi dibuka dari notifikasi (Background State)');
      _handleNavigation(message.data);
    });

    _setupForegroundMessageHandler();

    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint("===================================");
    debugPrint("FCM Token: $fcmToken");
    debugPrint("===================================");
  }

  static void _setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Menerima pesan di foreground!');
      debugPrint('Data Pesan: ${message.data}');

      if (message.notification != null) {
        _showLocalNotification(message);
      }

      if (Get.isRegistered<OrderController>()) {
        debugPrint("OrderController terdaftar. Memuat ulang data...");
        final orderController = Get.find<OrderController>();
        orderController.refreshAll();
      }
    });
  }

  static void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }
}
