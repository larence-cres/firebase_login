import 'package:firebase_login/notification/data/notification_modal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotificationDatabase {
  static const String _databaseName = 'notifications.db';
  static const int _databaseVersion = 1;

  static const String _table = 'notifications';
  static const String _columnId = 'id';
  static const String _columnTitle = 'title';
  static const String _columnBody = 'body';

  static late Database _database;

  static Future<void> initialize() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_table (
            $_columnId INTEGER PRIMARY KEY,
            $_columnTitle TEXT NOT NULL,
            $_columnBody TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static Future<List<NotificationModal>> getAllNotifications() async {
    final List<Map<String, dynamic>> data = await _database.query(_table);
    final notifications = data.map((e) => NotificationModal.fromMap(e)).toList();
    return notifications;
  }

  static Future<void> insertNotification(NotificationModal notification) async {
    await _database.insert(_table, notification.toMap());
  }
}
