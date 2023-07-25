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

  Future<String> getOneProfileGroupName({required currentUserEmail}) {
    return FirebaseFirestore.instance
        .collection('profile')
        .doc(currentUserEmail)
        .get()
        .then((DocumentSnapshot doc) {
      final profileInfo = doc.data()! as Map<String, List>;
      return profileInfo['groupNames']!.isNotEmpty
          ? profileInfo['groupNames']![0]
          : null;
    });
  }
}
