import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _channel = AndroidNotificationChannel(
  'high_importance_channel',
  'Важные уведомления',
  description: 'Канал для входящих FCM-уведомлений.',
  importance: Importance.max,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FcmNotificationService.logMessage(message, source: 'background');

  if (message.notification == null) {
    await FcmNotificationService.showBackgroundDataMessage(message);
  }
}

abstract final class FcmNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _initializeLocalNotifications();
    await _requestPermission();
    await _logToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      debugPrint('FCM Token refreshed: $token');
    });

    FirebaseMessaging.onMessage.listen((message) async {
      logMessage(message, source: 'foreground');
      await _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => logMessage(message, source: 'opened'),
    );

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      logMessage(initialMessage, source: 'terminated');
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _localNotifications.initialize(settings: initializationSettings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  static Future<void> _requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint(
      'FCM notification permission: ${settings.authorizationStatus.name}',
    );
  }

  static Future<void> _logToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: ${token ?? 'not available'}');
  }

  static void logMessage(RemoteMessage message, {required String source}) {
    final title = _titleOf(message);
    final body = _bodyOf(message);

    debugPrint('FCM message source: $source');
    debugPrint('FCM title: ${title ?? 'null'}');
    debugPrint('FCM body: ${body ?? 'null'}');
  }

  static Future<void> showBackgroundDataMessage(RemoteMessage message) async {
    await _initializeLocalNotifications();
    await _showNotification(message);
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    final title = _titleOf(message);
    final body = _bodyOf(message);
    final notificationId =
        (message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString())
            .hashCode &
        0x7fffffff;

    await _localNotifications.show(
      id: notificationId,
      title: title ?? 'Potter API',
      body: body ?? 'Получено новое сообщение',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'Важные уведомления',
          channelDescription: 'Канал для входящих FCM-уведомлений.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }

  static String? _titleOf(RemoteMessage message) {
    return message.notification?.title ?? message.data['title']?.toString();
  }

  static String? _bodyOf(RemoteMessage message) {
    return message.notification?.body ?? message.data['body']?.toString();
  }
}
