import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/notification/services/notification_service.dart';
import 'package:fraction/utils/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepoModel {
  String _title = '';
  String _message = '';
  String _type = '';
  String _docId = '';

  get title => _title;
  get message => _message;
  get type => _type;
  get docId => _docId;

  NotificationRepoModel(
      {required title, required message, required type, required docId}) {
    _title = title;
    _message = message;
    _type = type;
    _docId = docId;
  }
}

class NotificationRepo with ChangeNotifier {
  final List<NotificationRepoModel> _data = [];
  List<NotificationRepoModel> get data => _data;

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
        if (notification.exists) {
          final notificationBody = notification.data() as Map<String, dynamic>;
          print(' ---- notificaion ---- ');
          print(notification.data());
          _data.add(NotificationRepoModel(
              title: notificationBody['body']['title'],
              message: notificationBody['body']['message'],
              type: notificationBody['body']['type'],
              // type: 'type',
              docId: notification.id));
          notifyListeners();
        }
      }
    });
  }

  Future<void> inviteMember({required String to}) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUerEmail = prefs.getString('currentUserEmail');
    final currentUserGroup = prefs.getString(currentUserGroupName);
    const title = 'you are invited to join the group';
    _notificationService.addNotification(
        from: currentUerEmail ?? '',
        to: to,
        title: title,
        message: currentUserGroup ?? '');
  }

  dismissNotification({required String docId}) {
    _notificationService.deleteNotification(docId: docId);
  }
}
