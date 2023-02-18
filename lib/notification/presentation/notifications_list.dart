import 'package:firebase_login/notification/data/notification_modal.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({Key? key}) : super(key: key);

  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  late Future<List<NotificationModal>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _getNotifications();
  }

  Future<List<NotificationModal>> _getNotifications() async {
    final database = await openDatabase('notifications.db');
    final notifications = await database.rawQuery('SELECT * FROM notifications');
    return notifications.map((notification) => NotificationModal.fromMap(notification)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NotificationModal>>(
      future: _notifications,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final notifications = snapshot.data!;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(notification.title),
                subtitle: Text(notification.body),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Error fetching notifications');
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
