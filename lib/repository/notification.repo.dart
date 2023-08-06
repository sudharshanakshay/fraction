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
      for (var noti in event.docs) {
        _data.add(NotificationModel(
            title: noti.data()['body']['title'],
            message: noti.data()['body']['groupName'],
            type: noti.data()['body']['type']));
        notifyListeners();
      }
    });
  }
}
