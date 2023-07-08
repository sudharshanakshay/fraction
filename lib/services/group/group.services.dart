import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fraction/database/group.database.dart';
import 'package:fraction/model/group.dart';

const _currentGroupName = 'akshaya';
String? _currentUserEmail;

Future<void> init() async {
  FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      _currentUserEmail = user.email!;
      // return _currentUserEmail;
    }
  });
}

void updateTotalExpenseSubCollectionAccount(
    {required userEmail, required newCost}) {
  final accRef = FirebaseFirestore.instance
      .collection('group')
      .doc('akshaya')
      .collection('account')
      .doc(userEmail);
  accRef.get().then((doc) {
    final previousExpense = doc.data()?['totalExpense'];
    return previousExpense;
  }).then((previousExpense) {
    accRef.update({'totalExpense': previousExpense + newCost});
  });
}

Future<void> joinCloudGroup({required inputGroupName}) async {
  init().whenComplete(() {
    FirebaseFirestore.instance
        .collection('profile')
        .doc(_currentUserEmail)
        .get()
        .then((doc) {
      addMemberToGroup(
              currentGroupName: 'akshaya',
              memberName: doc.data()?['userName'],
              memberEmail: _currentUserEmail ?? 'null')
          .whenComplete(() {
        updateGroupNameToProfileCollection(
            currentUserEmail: _currentUserEmail,
            groupNameToAdd: inputGroupName);
      });
    });
  });
}

Future<void> createCloudGroup({required inputGroupName}) async {
  try {
    init().whenComplete(() {
      FirebaseFirestore.instance
          .collection('profile')
          .doc(_currentUserEmail)
          .get()
          .then((doc) {
        createGroup(
                groupName: _currentGroupName,
                memberName: doc.data()?['userName'],
                memberEmail: _currentUserEmail)
            .whenComplete(() {
          updateGroupNameToProfileCollection(
              currentUserEmail: _currentUserEmail,
              groupNameToAdd: inputGroupName);
        });
      });
    });
  } catch (e) {
    print(e);
  }
}

Stream<List?> getGroupAccountDetails({required currentUserEmail}) {
  return FirebaseFirestore.instance
      .collection('group')
      .doc('akshaya')
      .withConverter<GroupModel>(
          fromFirestore: (snapShot, _) => GroupModel.fromJson(snapShot.data()!),
          toFirestore: (groupModel, _) => groupModel.toJson())
      .snapshots()
      .asyncExpand((doc) {
    print(doc.data()?.toList());
    return Stream.value(doc.data()?.toList());
  });
}

// Future updateGroupMembersToGroupCollection(
//     {required groupName, required currentUserEmail}) async {
//   FirebaseFirestore.instance
//       .collection('profile')
//       .doc(currentUserEmail)
//       .get()
//       .then((doc) {
//     var data = {
//       'userName': doc.data()?['userName'],
//       'userEmail': doc.data()?['emailAddress'],
//       'totalExpense': 0
//     };

//     FirebaseFirestore.instance.collection('group').doc(groupName).update({
//       "groupMembers": FieldValue.arrayUnion([data]),
//     });
//   });
// }

Future updateGroupNameToProfileCollection(
    {required currentUserEmail, required groupNameToAdd}) async {
  bool kDebugMode = true;

  FirebaseFirestore.instance
      .collection('profile')
      .doc(currentUserEmail)
      .update({
    "groupNames": FieldValue.arrayUnion([groupNameToAdd]),
  }).whenComplete(() {
    if (kDebugMode) {
      print('-------- groupName $groupNameToAdd added successfuly --------');
    }
  });
}
