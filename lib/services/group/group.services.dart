import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/group.database.dart';

class GroupServices extends ApplicationState {
  late GroupDatabase groupDatabaseRef;
  GroupServices() {
    groupDatabaseRef = GroupDatabase();
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

  Future<void> createGroup(
      {required inputGroupName, required nextClearOffTimeStamp}) async {
    try {
      GroupDatabase()
          .createGroup(
              groupName: inputGroupName,
              adminName: super.currentUserName,
              adminEmail: super.currentUserEmail,
              nextClearOffTimeStamp: nextClearOffTimeStamp)
          .then((String groupNameCreatedWithIdentity) {
        GroupDatabase().insertGroupNameToProfile(
            currentUserEmail: super.currentUserEmail,
            groupNameToAdd: groupNameCreatedWithIdentity);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Stream getGroupDetials() {
    try {
      return GroupDatabase().getGroupDetials(groupName: super.currentUserGroup);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Stream getMyTotalExpense() {
    try {
      return GroupDatabase().getMyTotalExpense(
          currentUserEmail: super.currentUserEmail,
          groupName: super.currentUserGroup);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future<List?> getMemberDetails() {
    try {
      return GroupDatabase()
          .getMemberDetails(currentUserGroup: super.currentUserGroup);
    } catch (e) {
      return Future.value();
    }
  }
}
