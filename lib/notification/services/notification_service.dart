import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  late FirebaseFirestore _firebaseFirestore;
  final String _notificationCollectionName = 'notification';

  NotificationService() {
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  Stream getNotiifcations({required String currentUserEmail}) {
    try {
      return _firebaseFirestore
          .collection(_notificationCollectionName)
          .where('to', isEqualTo: currentUserEmail)
          .snapshots();
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print('service -- notification -- getNotification');
      }
      return const Stream.empty();
    }
  }

  Future<void> deleteNotification({required String docId}) async {
    try {
      _firebaseFirestore
          .collection(_notificationCollectionName)
          .doc(docId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print('service -- notification -- dismissNotification');
      }
    }
  }
}
