import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDatabase {
  final _profileCollectionName = 'profile';

  Future<void> createUserProfile(
      {required currentUserEmail,
      required currentUserName,
      required preferedColor}) async {
    FirebaseFirestore.instance
        .collection(_profileCollectionName)
        .doc(currentUserEmail)
        .set(<String, dynamic>{
      'userName': currentUserName,
      'emailAddress': currentUserEmail,
      'color': preferedColor,
      'groupNames': []
    });
  }

  Stream availableProfileGroupsStream({required currentUserEmail}) {
    return FirebaseFirestore.instance
        .collection('profile')
        .doc(currentUserEmail)
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
