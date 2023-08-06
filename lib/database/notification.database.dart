import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/database/utils/database.dart';

class NotificationDatabase {
  late FirebaseFirestore _firebaseFirestoreRef;
  late String _notificationCollectionName;

  NotificationDatabase() {
    _firebaseFirestoreRef = FirebaseFirestore.instance;
    _notificationCollectionName = DatabaseUtils().notificationCollectionName;
  }

  Stream getNotiifcations({required String currentUserEmail}) {
    return _firebaseFirestoreRef
        .collection(_notificationCollectionName)
        .where('to', isEqualTo: currentUserEmail)
        .snapshots();
  }

  Future<void> deleteNotification({required String docId}) async {
    _firebaseFirestoreRef
        .collection(_notificationCollectionName)
        .doc(docId)
        .delete();
  }
}
