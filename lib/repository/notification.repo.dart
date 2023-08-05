import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/model/notification.model.dart';
import 'package:fraction/utils/tools.dart';

class NotificationRepo extends ChangeNotifier {
  final List<NotificationModel> _data = [];
  List<NotificationModel> get data => _data;

  NotificationRepo() {
    checkForAvailableNotifications();
  }

  checkForAvailableNotifications() async {
    FirebaseFirestore.instance
        .collection('notification')
        .where('to', isEqualTo: 'mario@gmail.com')
        .snapshots()
        .listen((event) {
      _data.clear();
      for (var noti in event.docs) {
        _data.add(NotificationModel(
            title: noti.data()['body']['title'],
            message: Tools()
                .sliptElements(element: noti.data()['body']['groupName'])[0],
            type: noti.data()['body']['type']));
        notifyListeners();
      }
    });
  }
}


// .then((value) {
//       print(value.docs);
//       for (var noti in value.docs) {
//         _data.add(NotificationModel(
//             title: noti.data()['title'],
//             body: noti.data()['body'],
//             type: noti.data()['type']));
//         notifyListeners();
//       }
//     });