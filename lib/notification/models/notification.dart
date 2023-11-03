import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/notification/services/notification_service.dart';

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

  var currentUserEmail = '';

  NotificationRepo() {
    _notificationService = NotificationService();
  }

  update({String? newCurrentUserEmail}) {
    if (newCurrentUserEmail != null) {
      currentUserEmail = newCurrentUserEmail;
      checkForAvailableNotifications();
      if (kDebugMode) {
        print("update called on notification repo");
      }
    }
  }

  checkForAvailableNotifications() async {
    if (currentUserEmail != '') {
      _notificationService
          .getNotiifcations(currentUserEmail: currentUserEmail)
          .listen((event) {
        _data.clear();
        for (DocumentSnapshot notification in event.docs) {
          if (notification.exists) {
            final notificationBody =
                notification.data() as Map<String, dynamic>;
            print(' ---- notificaion ---- ');
            print(notification.data());
            _data.add(NotificationRepoModel(
                title: notificationBody['body']['title'],
                message: notificationBody['body']['message'],
                type: notificationBody['body']['type'],
                docId: notification.id));
            notifyListeners();
          }
        }
      });
    }
  }

  dismissNotification({required String docId}) {
    _notificationService.deleteNotification(docId: docId);
  }
}
