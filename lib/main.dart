import 'dart:io';

import 'package:flutter/material.dart';

import 'app.dart';
import 'core/notifications/fcm_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await FcmNotificationService.initialize();
  }

  runApp(const PotterApiApp());
}
