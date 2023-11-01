import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GroupsInfoServices {
  Future<void> addNotification(
      {required String from,
      required String to,
      required String title,
      required String message}) async {
    try {
      addNotificationRoot(
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

  Future<void> addNotificationRoot(
      {required String from,
      required String to,
      required String title,
      required String message}) async {
    final data = {
      'from': from,
      'to': to,
      'body': {'title': title, 'message': message, 'type': ''}
    };

    FirebaseFirestore.instance.collection('notification').add(data);
  }
}
