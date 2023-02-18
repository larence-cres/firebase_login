import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/firebase_options.dart';
import 'package:firebase_login/handler/push_notification_handler.dart';
import 'package:firebase_login/home/home_page.dart';
import 'package:firebase_login/login/presentation/login_page.dart';
import 'package:firebase_login/notification/data/notification_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

initFirebaseMessaging() async {
  // Request permission to show notifications
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_notification_channel',
    'Default Notification Channel',
    'Description', // description
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Define the callback for handling incoming notifications
  FirebaseMessaging.onMessageOpenedApp.listen(onMessageReceived);
  FirebaseMessaging.onMessage.listen(onMessageReceived);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initFirebaseMessaging();
  await NotificationDatabase.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _checkAuthState(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return const HomePage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }

  Future<bool> _checkAuthState() async {
    final preferences = await SharedPreferences.getInstance();
    final isAuthenticated = preferences.getBool('isAuthenticated') ?? false;
    return isAuthenticated;
  }
}
