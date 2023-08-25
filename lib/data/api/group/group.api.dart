import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/data/api/utils/api.dart';
import 'package:fraction/data/model/group.dart';

class GroupDatabase {
  late String _groupCollectionName;
  late FirebaseFirestore _firebaseFirestoreRef;

  GroupDatabase() {
    _groupCollectionName = DatabaseUtils().groupCollectionName;
    _firebaseFirestoreRef = FirebaseFirestore.instance;
  }

// -- group is created as follows, groupName%creatorEmail%timeStamp --
// -- '%' represents key separation & --
// -- '#' represents '.' in a key --
// -- whenever user creates group, user is added to that group by default --
  Future<String> createGroup(
      {required String groupName,
      required String adminName,
      required String adminEmail,
      required DateTime nextClearOffTimeStamp}) {
    final adminEmailR = adminEmail.replaceAll('.', '#');
    final data = {
      'createdOn': DateTime.now(),
      'expenseInstance': DateTime.now(),
      'nextClearOffTimeStamp': nextClearOffTimeStamp,
      'groupName': groupName,
      'totalExpense': 0,
      'groupMembers': {
        adminEmailR: {
          'memberName': adminName,
          'memberEmail': adminEmail,
          'totalExpense': 0
        }
      }
    };

    final String groupNameWithIdentity =
        '$groupName%$adminEmail%${DateTime.now().toString().replaceAll(RegExp(r'[\s]'), '%')}';

    if (kDebugMode) {
      print('group info: $data');
    }

    return _firebaseFirestoreRef
        .collection(_groupCollectionName)
        .doc(groupNameWithIdentity)
        .set(data)
        .then((value) => groupNameWithIdentity);
  }

  Future<void> addMeToGroup(
      {required String groupNameToAdd,
      required String currentUserEmail,
      required currentUserName}) async {
    final currentUserEmailR = currentUserEmail.replaceAll('.', '#');

    _firebaseFirestoreRef.collection(_groupCollectionName).get().then((value) {
      print(groupNameToAdd);
      for (var groupDoc in value.docs) {
        if (groupDoc.id == groupNameToAdd) {
          final data = {
            'groupMembers': {
              currentUserEmailR: {
                'memberEmail': currentUserEmail,
                'memberName': currentUserName,
                'totalExpense': 0
              }
            }
          };

          _firebaseFirestoreRef
              .collection(_groupCollectionName)
              .doc(groupNameToAdd)
              .set(data, SetOptions(merge: true))
              .whenComplete(() {
            print('group added');
          });
        } else {
          if (kDebugMode) {
            // print('group name doesnt exists');
          }
        }
      }
    });
  }

  Stream getGroupDetials({required groupName}) {
    return _firebaseFirestoreRef
        .collection(_groupCollectionName)
        .doc(groupName)
        .snapshots();
  }

  Stream getMyTotalExpense({required currentUserEmail, required groupName}) {
    final currentUserEmailR = currentUserEmail.replaceAll('.', '#');

    return _firebaseFirestoreRef
        .collection(_groupCollectionName)
        .doc(groupName)
        .snapshots()
        .asyncExpand((doc) {
      return Stream.value(
          doc.data()!['groupMembers'][currentUserEmailR]['totalExpense']);
    });
  }

  Future<List?> getMemberDetails({required currentUserGroup}) {
    return _firebaseFirestoreRef
        .collection(_groupCollectionName)
        .doc(currentUserGroup)
        .withConverter<GroupModel>(
            fromFirestore: (snapShot, _) =>
                GroupModel.fromJson(snapShot.data()!),
            toFirestore: (groupModel, _) => groupModel.toJson())
        .get()
        .then((doc) {
      return doc.data()?.toList();
    });
  }

  // -- add member to the group requires, groupName to add & member details --
  Future<void> insertMemberToGroup(
      {required String currentGroupName,
      required String memberName,
      required String memberEmail}) {
    final memberEmailR = memberEmail.replaceAll('.', '#');
    final data = {
      'memberName': memberName,
      'memberEmail': memberEmail,
      'totalExpense': 0
    };
    return _firebaseFirestoreRef
        .collection(_groupCollectionName)
        .doc(currentGroupName)
        .update({"groupMembers.$memberEmailR": data});
  }

  // -- update group member details, expenseDiff can be '+' representing addition to current value, '-' vise-versa --
  void updateGroupMemberExpense(
      {required groupName, required memberEmail, required int expenseDiff}) {
    final memberEmailR = memberEmail.replaceAll('.', '#');
    final data = {
      'totalExpense': FieldValue.increment(expenseDiff),
      'groupMembers.$memberEmailR.totalExpense':
          FieldValue.increment(expenseDiff)
    };
    _firebaseFirestoreRef
        .collection(_groupCollectionName)
        .doc(groupName)
        .update(data);
  }

  Future<void> clearOff(
      {required String groupName, required DateTime nextClearOffDate}) async {
    final Map<String, dynamic> groupMembers = {};

    await _firebaseFirestoreRef
        .collection(_groupCollectionName)
        .doc(groupName)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        final groupDetails = doc.data() as Map<String, dynamic>;
        final memberDetails =
            groupDetails['groupMembers'] as Map<String, dynamic>;
        memberDetails.forEach((key, value) {
          final Map<String, dynamic> groupMember = {
            key: {'totalExpense': 0}
          };
          groupMembers.addAll(groupMember);
        });
      }
    });

    final data = {
      'expenseInstance': DateTime.now(),
      'groupMembers': groupMembers,
      'totalExpense': 0,
      'nextClearOffTimeStamp': nextClearOffDate
    };

    // print(data);

    _firebaseFirestoreRef
        .collection(_groupCollectionName)
        .doc(groupName)
        .set(data, SetOptions(merge: true));
  }
}
