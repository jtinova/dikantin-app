import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dikantin_partner/firebase_options.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'dart:convert';

import '../modules/pesanan_kantin/controllers/pesanan_controller.dart';
import '../modules/pesanan_kantin/views/detail_pesanan.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  developer.log("Handling a background message: ${message.messageId}",
      name: 'FCMService');
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

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
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        developer.log('Local notification tapped!', name: 'FCMService');
        developer.log('Payload: ${details.payload}', name: 'FCMService');
        if (details.payload != null && details.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> data = jsonDecode(details.payload!);
            final String? transactionId = data['transaction_id'];

            if (transactionId != null) {
              _navigateToDetail(transactionId);
            } else {
              developer.log(
                  'transaction_id is null in local notification payload.',
                  name: 'FCMService',
                  error: 'Missing transaction_id');
            }
          } catch (e) {
            developer.log(
                'Error decoding or handling local notification payload:',
                name: 'FCMService',
                error: e);
          }
        }
      },
    );

    _setupForegroundMessageHandler();
    _setupInteractionHandlers();

    final fcmToken = await _firebaseMessaging.getToken();
    developer.log("===================================", name: 'FCMService');
    developer.log("FCM Token: $fcmToken", name: 'FCMService');
    developer.log("===================================", name: 'FCMService');
  }

  static void _setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      developer.log('Received a message in the foreground!',
          name: 'FCMService');
      if (message.notification != null) {
        developer.log('Message notification: ${message.notification}',
            name: 'FCMService');
        developer.log('Message data: ${message.data}', name: 'FCMService');
        _showLocalNotification(message);

        if (Get.isRegistered<PesananController>()) {
          Get.find<PesananController>().refreshData();
        }
      }
    });
  }

  static void _setupInteractionHandlers() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        developer.log('Handling initial message (terminated state)',
            name: 'FCMService');
        _handleNotificationClick(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log('Handling message opened app (background state)',
          name: 'FCMService');
      _handleNotificationClick(message);
    });
  }

  static void _navigateToDetail(String transactionId) {
    developer.log('Navigating to detail for transaction_id: $transactionId',
        name: 'FCMService');

    if (!Get.isRegistered<PesananController>()) {
      developer.log('PesananController is not registered. Putting it now.',
          name: 'FCMService');
      Get.put(PesananController());
    } else {
      developer.log('PesananController is already registered.',
          name: 'FCMService');
    }

    try {
      final PesananController pesananController = Get.find<PesananController>();
      developer.log('Successfully found PesananController instance.',
          name: 'FCMService');
      developer.log('Fetching transaction details...', name: 'FCMService');

      pesananController.fetchTransactionById(transactionId).then((transaction) {
        if (transaction != null) {
          developer.log(
              'Transaction details fetched successfully. Attempting navigation...',
              name: 'FCMService');
          try {
            Get.to(() => DetailPesananView(), arguments: transaction);
            developer.log('Navigation Get.to called successfully.',
                name: 'FCMService');
          } catch (navError) {
            developer.log('Error during Get.to navigation:',
                name: 'FCMService', error: navError);
            Get.snackbar(
              "Error Navigasi",
              "Gagal membuka halaman detail.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          developer.log(
              'Failed to fetch transaction details for id: $transactionId',
              name: 'FCMService',
              error: 'Transaction data is null');
          Get.snackbar(
            "Error Navigasi",
            "Gagal memuat detail pesanan.",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }).catchError((error) {
        developer.log('Error during fetchTransactionById:',
            name: 'FCMService', error: error);
        Get.snackbar(
          "Error Server",
          "Gagal menghubungi server untuk detail pesanan.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    } catch (e) {
      developer.log('Error finding PesananController:',
          name: 'FCMService', error: e);
      Get.snackbar(
        "Error Aplikasi",
        "Terjadi kesalahan internal saat membuka detail pesanan.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static void _handleNotificationClick(RemoteMessage message) {
    developer.log('FCM Notification clicked!', name: 'FCMService');
    developer.log('Message data: ${message.data}', name: 'FCMService');

    final transactionId = message.data['transaction_id'];

    if (transactionId != null) {
      _navigateToDetail(transactionId);
    } else {
      developer.log('transaction_id is null in FCM notification data.',
          name: 'FCMService', error: 'Missing transaction_id');
      Get.snackbar(
        "Error Notifikasi",
        "Data ID transaksi tidak ditemukan dalam notifikasi.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  static void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      final String payload = jsonEncode(message.data);
      developer.log('Showing local notification with payload: $payload',
          name: 'FCMService');

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
        payload: payload,
      );
    } else {
      developer.log(
          'Cannot show local notification: notification or android part is null.',
          name: 'FCMService');
    }
  }
}
