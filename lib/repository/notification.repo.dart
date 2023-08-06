import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/model/notification.model.dart';
import 'package:fraction/services/notification/notification.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepo with ChangeNotifier {
  final List<NotificationModel> _data = [];
  List<NotificationModel> get data => _data;

  late NotificationService _notificationService;

  NotificationRepo() {
    _notificationService = NotificationService();
    checkForAvailableNotifications();
  }

  checkForAvailableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUerEmail = prefs.getString('currentUserEmail');
    _notificationService
        .getNotiifcations(currentUserEmail: currentUerEmail ?? '')
        .listen((event) {
      _data.clear();
      for (DocumentSnapshot notification in event.docs) {
        final notificationBody = notification.data() as Map<String, dynamic>;
        _data.add(NotificationModel(
            title: notificationBody['body']['title'],
            message: notificationBody['body']['groupName'],
            type: notificationBody['body']['type'],
            docId: notification.id));
        notifyListeners();
      }
    });
  }

  dismissNotification({required String docId}) {
    _notificationService.deleteNotification(docId: docId);
  }
}
