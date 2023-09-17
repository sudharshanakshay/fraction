import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/data/api/utils/database.utils.dart';

class UserDatabase {
  late String _userCollectionName;
  late FirebaseFirestore _firebaseFirestoreRef;

  UserDatabase() {
    _userCollectionName = DatabaseUtils().userCollectionName;
    _firebaseFirestoreRef = FirebaseFirestore.instance;
  }

  Future<void> createUser(
      {required currentUserEmail,
      required currentUserName,
      required preferedColor}) async {
    _firebaseFirestoreRef
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
    return _firebaseFirestoreRef
        .collection(_userCollectionName)
        .doc(currentUserEmail)
        .snapshots()
        .asyncExpand((DocumentSnapshot doc) {
      final profileInfo = doc.data()! as Map<String, dynamic>;
      return Stream.value(profileInfo['groupNames']);
    });
  }

  Future<String> getOneUserGroupName({required currentUserEmail}) {
    return _firebaseFirestoreRef
        .collection(_userCollectionName)
        .doc(currentUserEmail)
        .get()
        .then((DocumentSnapshot doc) {
      final profileInfo = doc.data() as Map<String, dynamic>;
      return profileInfo['groupNames'].isNotEmpty
          ? profileInfo['groupNames'][0]
          : '';
    });
  }

  Future insertGroupNameToProfile(
      {required currentUserEmail, required groupNameToAdd}) async {
    bool kDebugMode = true;

    _firebaseFirestoreRef
        .collection(_userCollectionName)
        .doc(currentUserEmail)
        .update({
      "groupNames": FieldValue.arrayUnion([groupNameToAdd]),
    }).whenComplete(() {
      if (kDebugMode) {
        if (kDebugMode) {
          print(
              '-------- groupName $groupNameToAdd added successfuly --------');
        }
      }
    });
  }

  Future<void> exitGroup(
      {required String currentUserEmail,
      required String currentUserGroup}) async {
    _firebaseFirestoreRef
        .collection(_userCollectionName)
        .doc(currentUserEmail)
        .update({
      'groupNames': FieldValue.arrayRemove([currentUserGroup])
    });
  }
}
