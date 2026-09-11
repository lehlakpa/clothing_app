import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    // IMPORTANT:
    // Your installed package version uses positional parameter.
    await _notifications.initialize(initializationSettings);

    // Android 13+ permission
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'auth_channel',
      'Authentication Notifications',
      channelDescription: 'Login notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(id, title, body, notificationDetails);
  }

  static Future<void> showLoginSuccess() async {
    await showNotification(
      id: 1,
      title: 'Login Successful',
      body: 'Welcome back! You have successfully logged in.',
    );
  }

  static Future<void> showLoginError(String message) async {
    await showNotification(id: 2, title: 'Login Failed', body: message);
  }
}
