import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/group.database.dart';
import 'package:fraction/database/user.database.dart';
import 'package:fraction/utils/constants.dart';

class GroupServices extends ApplicationState {
  late GroupDatabase _groupDatabaseRef;
  late UserDatabase _userDatabaseRef;

  GroupServices() {
    _groupDatabaseRef = GroupDatabase();
    _userDatabaseRef = UserDatabase();
  }

  Future<String> createGroup(
      {required inputGroupName, required nextClearOffTimeStamp}) async {
    try {
      _groupDatabaseRef
          .createGroup(
              groupName: inputGroupName,
              adminName: super.currentUserName,
              adminEmail: super.currentUserEmail,
              nextClearOffTimeStamp: nextClearOffTimeStamp)
          .then((String groupNameCreatedWithIdentity) {
        _userDatabaseRef
            .insertGroupNameToProfile(
                currentUserEmail: super.currentUserEmail,
                groupNameToAdd: groupNameCreatedWithIdentity)
            .whenComplete(() async {
          super.initGroupAndExpenseInstances();
        });
      });
      return Constants().success;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Constants().failed;
    }
  }

  Stream getGroupDetials() {
    try {
      return _groupDatabaseRef.getGroupDetials(
          groupName: super.currentUserGroup);
    } catch (e) {
      print(e);
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

  onError(e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
