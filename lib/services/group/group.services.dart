import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/group.database.dart';
import 'package:fraction/model/group.dart';

class GroupServices extends ApplicationState {
  void updateTotalExpenseSubCollectionAccount(
      {required userEmail, required newCost}) {
    final accRef = FirebaseFirestore.instance
        .collection('group')
        .doc(super.currentUserGroup)
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
    FirebaseFirestore.instance
        .collection('profile')
        .doc(super.currentUserEmail)
        .get()
        .then((doc) {
      addMemberToGroup(
              currentGroupName: super.currentUserGroup,
              memberName: doc.data()?['userName'],
              memberEmail: super.currentUserEmail)
          .whenComplete(() {
        updateGroupNameToProfileCollection(
            currentUserEmail: super.currentUserEmail,
            groupNameToAdd: inputGroupName);
      });
    });
  }

  Future<void> createCloudGroup({required inputGroupName}) async {
    try {
      FirebaseFirestore.instance
          .collection('profile')
          .doc(super.currentUserEmail)
          .get()
          .then((doc) {
        createGroup(
                groupName: inputGroupName,
                adminName: doc.data()?['userName'],
                adminEmail: super.currentUserEmail)
            .then((String groupNameCreatedWithIdentity) {
          updateGroupNameToProfileCollection(
              currentUserEmail: super.currentUserEmail,
              groupNameToAdd: groupNameCreatedWithIdentity);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List?> getGroupAccountDetails({required currentUserEmail}) {
    try {
      return FirebaseFirestore.instance
          .collection('group')
          .doc(super.currentUserGroup)
          .withConverter<GroupModel>(
              fromFirestore: (snapShot, _) =>
                  GroupModel.fromJson(snapShot.data()!),
              toFirestore: (groupModel, _) => groupModel.toJson())
          .snapshots()
          .asyncExpand((doc) {
        // print('----------------------');
        // print(' Expense Account  ${doc.data()}');
        return Stream.value(doc.data()?.toList());
      });
    } catch (e) {
      return const Stream.empty();
    }
  }

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
}
