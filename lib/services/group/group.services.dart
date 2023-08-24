import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/api/group/group.api.dart';
import 'package:fraction/api/notification/notification.api.dart';
import 'package:fraction/api/user/user.api.dart';
import 'package:fraction/utils/constants.dart';

class GroupServices {
  late GroupDatabase _groupDatabaseRef;
  late UserDatabase _userDatabaseRef;
  late NotificationDatabase _notificationDatabaseRef;

  GroupServices() {
    _groupDatabaseRef = GroupDatabase();
    _userDatabaseRef = UserDatabase();
    _notificationDatabaseRef = NotificationDatabase();
  }

  Future<String> createGroup(
      {required String currentUserName,
      required String currentUserEmail,
      required inputGroupName,
      required nextClearOffTimeStamp,
      ApplicationState? applicationState}) async {
    try {
      return _groupDatabaseRef
          .createGroup(
              groupName: inputGroupName,
              adminName: currentUserName,
              adminEmail: currentUserEmail,
              nextClearOffTimeStamp: nextClearOffTimeStamp)
          .then((String groupNameCreatedWithIdentity) {
        _userDatabaseRef
            .insertGroupNameToProfile(
                currentUserEmail: currentUserEmail,
                groupNameToAdd: groupNameCreatedWithIdentity)
            .whenComplete(() {
          if (applicationState != null) {
            applicationState.refreshGroupNamesAndExpenseInstances();
          }
        });
        return groupNameCreatedWithIdentity;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Constants().failed;
    }
  }

  Future<void> addMeToGroup(
      {required String groupName,
      required String currentUserEmail,
      required String currentUserName,
      required String docId,
      ApplicationState? applicationState}) async {
    try {
      if (groupName.isNotEmpty) {
        _groupDatabaseRef
            .addMeToGroup(
                groupNameToAdd: groupName.trim(),
                currentUserEmail: currentUserEmail.trim(),
                currentUserName: currentUserName.trim())
            .whenComplete(() {
          _userDatabaseRef
              .insertGroupNameToProfile(
                  currentUserEmail: currentUserEmail,
                  groupNameToAdd: groupName.trim())
              .whenComplete(() {
            if (applicationState != null) {
              applicationState.refreshGroupNamesAndExpenseInstances();
              _notificationDatabaseRef.deleteNotification(docId: docId);
            }
          });
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Stream getGroupDetials({required currentUserGroup}) {
    try {
      return _groupDatabaseRef.getGroupDetials(groupName: currentUserGroup);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return const Stream.empty();
    }
  }

  Stream getMyTotalExpense(
      {required String currentUserEmail, required String currentUserGroup}) {
    try {
      return _groupDatabaseRef.getMyTotalExpense(
          currentUserEmail: currentUserEmail, groupName: currentUserGroup);
    } catch (e) {
      return const Stream.empty();
    }
  }

  StreamController broadCastMyTotalExpense({
    required String currentUserGroup,
    required String currentUserEmail,
  }) {
    StreamController streamController = StreamController.broadcast();
    try {
      streamController.addStream(_groupDatabaseRef.getMyTotalExpense(
          currentUserEmail: currentUserEmail, groupName: currentUserGroup));
    } catch (e) {
      print(e);
    }

    return streamController;
  }

  Future<List?> getMemberDetails({required String currentUserGroup}) {
    try {
      return _groupDatabaseRef.getMemberDetails(
          currentUserGroup: currentUserGroup);
    } catch (e) {
      return Future.value();
    }
  }

  Future<void> clearOff(
      {required DateTime nextClearOffDate,
      required String currentUserGroup}) async {
    try {
      _groupDatabaseRef
          .clearOff(
              groupName: currentUserGroup, nextClearOffDate: nextClearOffDate)
          .whenComplete(() async {
        // await super.initGroupAndExpenseInstances().whenComplete(() {
        //   if (kDebugMode) {
        //     // print(super.currentExpenseInstance.toDate().toString());
        //   }
        // });
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
