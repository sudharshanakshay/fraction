import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/group.database.dart';

class GroupServices extends ApplicationState {
  void updateTotalExpenseSubCollectionAccount({required newCost}) {
    final accRef = FirebaseFirestore.instance
        .collection('group')
        .doc(super.currentUserGroup)
        .collection('account')
        .doc(super.currentUserName);
    accRef.get().then((doc) {
      final previousExpense = doc.data()?['totalExpense'];
      return previousExpense;
    }).then((previousExpense) {
      accRef.update({'totalExpense': previousExpense + newCost});
    });
  }

  Future<void> joinCloudGroup({required newGroupName}) async {
    GroupDatabase()
        .insertMemberToGroup(
            currentGroupName: super.currentUserGroup,
            memberName: super.currentUserName,
            memberEmail: super.currentUserEmail)
        .whenComplete(() {
      GroupDatabase().insertGroupNameToProfile(
          currentUserEmail: super.currentUserEmail,
          groupNameToAdd: newGroupName);
    });
  }

  Future<void> createGroup({required inputGroupName}) async {
    try {
      GroupDatabase()
          .createGroup(
              groupName: inputGroupName,
              adminName: super.currentUserName,
              adminEmail: super.currentUserEmail)
          .then((String groupNameCreatedWithIdentity) {
        GroupDatabase().insertGroupNameToProfile(
            currentUserEmail: super.currentUserEmail,
            groupNameToAdd: groupNameCreatedWithIdentity);
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List?> getMemberDetails() {
    try {
      return GroupDatabase()
          .getMemberDetails(currentUserGroup: super.currentUserGroup);
    } catch (e) {
      return const Stream.empty();
    }
  }
}
