import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDatabase {
  Stream availableProfileGroupsStream({required currentUserEamil}) {
    return FirebaseFirestore.instance
        .collection('profile')
        .doc(currentUserEamil)
        .snapshots()
        .asyncExpand((DocumentSnapshot doc) {
      final profileInfo = doc.data()! as Map<String, dynamic>;
      return Stream.value(profileInfo['groupNames']);
    });
  }
}
