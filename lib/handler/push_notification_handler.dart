import 'dart:convert';

import 'package:firebase_login/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';

// Create a callback for handling incoming notifications
Future<void> onMessageReceived(RemoteMessage message) async {
  print('A new onMessageOpenedApp event was published!');
  // Show the notification in your app
  showNotification(message);
}

// Show the notification in your app
Future<void> showNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification != null) {
    final android = message.notification?.android;
    final title = notification.title ?? "";
    final body = notification.body ?? "";
    final payload = message.data;

    // Save the notification to local storage
    final notificationData = {
      'title': title,
      'body': body,
      'payload': payload,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    final database = await openDatabase('notifications.db');
    await database.rawInsert('INSERT INTO notifications(title, body) VALUES("$title", "$body")');

    // Show the notification
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      'channel_description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(notificationData),
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}
