import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/group.database.dart';

class GroupServices extends ApplicationState {
  late GroupDatabase _groupDatabaseRef;
  GroupServices() {
    _groupDatabaseRef = GroupDatabase();
  }
  // Future<void> joinCloudGroup({required newGroupName}) async {
  //   _groupDatabaseRef
  //       .insertMemberToGroup(
  //           currentGroupName: super.currentUserGroup,
  //           memberName: super.currentUserName,
  //           memberEmail: super.currentUserEmail)
  //       .whenComplete(() {
  //     _groupDatabaseRef.insertGroupNameToProfile(
  //         currentUserEmail: super.currentUserEmail,
  //         groupNameToAdd: newGroupName);
  //   });
  // }

  Future<void> createGroup(
      {required inputGroupName, required nextClearOffTimeStamp}) async {
    try {
      _groupDatabaseRef
          .createGroup(
              groupName: inputGroupName,
              adminName: super.currentUserName,
              adminEmail: super.currentUserEmail,
              nextClearOffTimeStamp: nextClearOffTimeStamp)
          .then((String groupNameCreatedWithIdentity) {
        _groupDatabaseRef.insertGroupNameToProfile(
            currentUserEmail: super.currentUserEmail,
            groupNameToAdd: groupNameCreatedWithIdentity);
      }).whenComplete(() {
        hasGroup = true;
        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Stream getGroupDetials() {
    try {
      return _groupDatabaseRef.getGroupDetials(
          groupName: super.currentUserGroup);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Stream getMyTotalExpense() {
    try {
      return _groupDatabaseRef.getMyTotalExpense(
          currentUserEmail: super.currentUserEmail,
          groupName: super.currentUserGroup);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future<List?> getMemberDetails() {
    try {
      return _groupDatabaseRef.getMemberDetails(
          currentUserGroup: super.currentUserGroup);
    } catch (e) {
      return Future.value();
    }
  }
}
