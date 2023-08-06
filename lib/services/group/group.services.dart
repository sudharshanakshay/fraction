import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/group.database.dart';
import 'package:fraction/database/notification.database.dart';
import 'package:fraction/database/user.database.dart';
import 'package:fraction/utils/constants.dart';

class GroupServices extends ApplicationState {
  late GroupDatabase _groupDatabaseRef;
  late UserDatabase _userDatabaseRef;
  late NotificationDatabase _notificationDatabaseRef;

  GroupServices() {
    _groupDatabaseRef = GroupDatabase();
    _userDatabaseRef = UserDatabase();
    _notificationDatabaseRef = NotificationDatabase();
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

  Future<void> addMeToGroup({
    required String groupName,
    required String currentUserEmail,
    required String currentUserName,
    required String docId,
  }) async {
    try {
      _groupDatabaseRef
          .addMeToGroup(
              groupNameToAdd: groupName,
              currentUserEmail: currentUserEmail,
              currentUserName: currentUserName)
          .whenComplete(() {
        _notificationDatabaseRef.deleteNotification(docId: docId);
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

  StreamController broadCastMyTotalExpense() {
    StreamController streamController = StreamController.broadcast();
    try {
      streamController.addStream(_groupDatabaseRef.getMyTotalExpense(
          currentUserEmail: super.currentUserEmail,
          groupName: super.currentUserGroup));
    } catch (e) {
      print(e);
    }

    return streamController;
  }

  Future<List?> getMemberDetails() {
    try {
      return _groupDatabaseRef.getMemberDetails(
          currentUserGroup: super.currentUserGroup);
    } catch (e) {
      return Future.value();
    }
  }

  Future<void> clearOff({required DateTime nextClearOffDate}) async {
    try {
      _groupDatabaseRef
          .clearOff(
              groupName: super.currentUserGroup,
              nextClearOffDate: nextClearOffDate)
          .whenComplete(() async {
        await super.initGroupAndExpenseInstances().whenComplete(() {
          print(super.currentExpenseInstance.toDate().toString());
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  onError(e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
