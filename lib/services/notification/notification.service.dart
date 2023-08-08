import 'package:flutter/foundation.dart';
import 'package:fraction/database/notification.database.dart';

class NotificationService {
  late NotificationDatabase _notificationDatabaseRef;

  NotificationService() {
    _notificationDatabaseRef = NotificationDatabase();
  }

  Stream getNotiifcations({required String currentUserEmail}) {
    try {
      return _notificationDatabaseRef.getNotiifcations(
          currentUserEmail: currentUserEmail);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print('service -- notification -- getNotification');
      }
      return const Stream.empty();
    }
  }

  Future<void> addNotification(
      {required String from,
      required String to,
      required String title,
      required String message}) async {
    try {
      _notificationDatabaseRef.addNotification(
          from: from.trim(),
          to: to.trim(),
          title: title.trim(),
          message: message.trim());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> deleteNotification({required String docId}) async {
    try {
      _notificationDatabaseRef.deleteNotification(docId: docId);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print('service -- notification -- dismissNotification');
      }
    }
  }
}
