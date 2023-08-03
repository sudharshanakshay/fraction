import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/model/group.dart';

class GroupDatabase {
  final _groupCollectionName = 'group';
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

    final String groupNameWithIdentity = groupName +
        '%' +
        adminEmail +
        '%' +
        DateTime.now().toString().replaceAll(RegExp(r'[\s]'), '%');

    if (kDebugMode) {
      print('group info: $data');
    }

    return FirebaseFirestore.instance
        .collection(_groupCollectionName)
        .doc(groupNameWithIdentity)
        .set(data)
        .then((value) => groupNameWithIdentity);
  }

  Stream getGroupDetials({required groupName}) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(groupName)
        .snapshots();
  }

  Stream getMyTotalExpense({required currentUserEmail, required groupName}) {
    final currentUserEmailR = currentUserEmail.replaceAll('.', '#');

    return FirebaseFirestore.instance
        .collection(_groupCollectionName)
        .doc(groupName)
        .snapshots()
        .asyncExpand((doc) {
      return Stream.value(
          doc.data()!['groupMembers'][currentUserEmailR]['totalExpense']);
    });
  }

  Future<List?> getMemberDetails({required currentUserGroup}) {
    return FirebaseFirestore.instance
        .collection('group')
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
    return FirebaseFirestore.instance
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
    FirebaseFirestore.instance
        .collection(_groupCollectionName)
        .doc(groupName)
        .update(data);
  }

  Future insertGroupNameToProfile(
      {required currentUserEmail, required groupNameToAdd}) async {
    bool kDebugMode = true;

    FirebaseFirestore.instance
        .collection('users')
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
}
