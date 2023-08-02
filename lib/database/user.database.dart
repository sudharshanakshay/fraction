import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  final _userCollectionName = 'users';

  Future<void> createUser(
      {required currentUserEmail,
      required currentUserName,
      required preferedColor}) async {
    FirebaseFirestore.instance
        .collection(_userCollectionName)
        .doc(currentUserEmail)
        .set(<String, dynamic>{
      'userName': currentUserName,
      'emailAddress': currentUserEmail,
      'color': preferedColor,
      'groupNames': []
    });
  }

  Stream userSubscribedGroupsStream({required currentUserEmail}) {
    return FirebaseFirestore.instance
        .collection(_userCollectionName)
        .doc(currentUserEmail)
        .snapshots()
        .asyncExpand((DocumentSnapshot doc) {
      final profileInfo = doc.data()! as Map<String, dynamic>;
      return Stream.value(profileInfo['groupNames']);
    });
  }

  Future<String> getOneUserGroupName({required currentUserEmail}) {
    return FirebaseFirestore.instance
        .collection(_userCollectionName)
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
