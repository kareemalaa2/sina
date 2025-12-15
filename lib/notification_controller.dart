import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Background message handler - must be top-level
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📩 Background Message: ${message.notification?.title}");
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 🔹 Request notification permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔹 Initialize notification settings
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("🔔 Notification clicked: ${response.payload}");
      },
    );

    // 🔹 Create / ensure notification channel exists
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'Used for important notifications.',
  importance: Importance.max,
  playSound: true,
);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 🔹 Get FCM token
    final fcmToken = await _firebaseMessaging.getToken();
    debugPrint("🎯 FCM Token: $fcmToken");

    if (fcmToken != null) {
      final sh = await SharedPreferences.getInstance();
      await sh.setString("fcm", fcmToken);
    }

    // 🔹 Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_onMessage);

    // 🔹 When app opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // 🔹 Handle background messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 🔹 Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint("🔄 FCM Token refreshed: $newToken");
      final sh = await SharedPreferences.getInstance();
      await sh.setString("fcm", newToken);
    });
  }
static Future<void> _onMessage(RemoteMessage message) async {
  debugPrint("🔥 Foreground Message received: ${message.data}");

  // Handle both notification & data messages
  final notification = message.notification;
  String? title = notification?.title ?? message.data['title'];
  String? body = notification?.body ?? message.data['body'];

  if (title == null && body == null) {
    debugPrint("⚠️ No title/body found in message");
    return;
  }

  await _showLocalNotification(
    title ?? 'New Notification',
    body ?? '',
    message.data.toString(),
  );
}


  /// 🔹 Handle notification click
  static void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint("📲 Notification clicked (opened app): ${message.data}");
    // You can navigate to a screen here based on message.data
  }

  /// 🔹 Display local notification
  static Future<void> _showLocalNotification(
      String? title, String? body, String payload) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title ?? 'New Notification',
      body ?? '',
      platformDetails,
      payload: payload,
    );
  }

  /// 🔹 Get stored token
  static Future<String?> getSavedToken() async {
    final sh = await SharedPreferences.getInstance();
    return sh.getString("fcm");
  }

  /// 🔹 Manual test
  static Future<void> testLocalNotification() async {
    await _localNotifications.show(
      0,
      'Test Notification',
      'This is a manual local notification test.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
    );
  }
}
