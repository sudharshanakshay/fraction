import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';
// import 'package:fraction/data/api/expense/expense.api.dart';
import 'package:fraction/data/api/group/group.api.dart';
import 'package:fraction/data/api/notification/notification.api.dart';
import 'package:fraction/data/api/user/user.api.dart';
import 'package:fraction/utils/constants.dart';

class GroupServices {
  late GroupDatabase _groupDatabaseRef;
  late UserDatabase _userDatabaseRef;
  // late ExpenseDatabase _expenseDatabase;
  late NotificationDatabase _notificationDatabaseRef;

  GroupServices() {
    _groupDatabaseRef = GroupDatabase();
    _userDatabaseRef = UserDatabase();
    // _expenseDatabase = ExpenseDatabase();
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

          // this function is taken care by firebase trigger functions

          // .then((String groupNameCreatedWithIdentity)
          // {
          // _userDatabaseRef
          //     .insertGroupNameToProfile(
          //         currentUserEmail: currentUserEmail,
          //         groupNameToAdd: groupNameCreatedWithIdentity)
          .then((String groupNameCreatedWithIdentity) {
        // if (applicationState != null) {
        //   applicationState.refreshGroupNamesAndExpenseInstances();
        // }
        // });
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
              // applicationState.refreshGroupNamesAndExpenseInstances();
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

  // Future<void> clearOff(
  //     {required DateTime nextClearOffDate,
  //     required String currentUserGroup}) async {
  //   try {
  //     _groupDatabaseRef
  //         .clearOff(
  //             groupName: currentUserGroup, nextClearOffDate: nextClearOffDate)
  //         .whenComplete(() async {
  //       // await super.initGroupAndExpenseInstances().whenComplete(() {
  //       //   if (kDebugMode) {
  //       //     // print(super.currentExpenseInstance.toDate().toString());
  //       //   }
  //       // });
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  // ---- not application, since this data has been moved to 'members' collection. ----

  // Future<void> refreshMemberExpenses(
  //     {required String currentGroupName,
  //     required Timestamp currentExpenseInstance}) async {
  //   QuerySnapshot groupExpenseDetails =
  //       await _expenseDatabase.getExpenseCollection(
  //           currentGroupName: currentGroupName,
  //           currentExpenseInstance: currentExpenseInstance.toDate().toString());

  //   Map<String, int> memberExpenses = {};

  //   for (var element in groupExpenseDetails.docs) {
  //     // print(element.data());
  //     try {
  //       memberExpenses[element['emailAddress']] =
  //           memberExpenses[element['emailAddress']]! + element['cost'] as int;
  //     } catch (e) {
  //       final data = {
  //         element['emailAddress'] as String: element['cost'] as int
  //       };
  //       memberExpenses.addAll(data);
  //     }
  //     // if (memberExpenses[element['emailAddress']]) {}
  //     // print(memberExpenses['hello'].bitLength)
  //   }
  //   if (kDebugMode) {
  //     print(memberExpenses);
  //   }
  //   int totalGroupExpense = 0;
  //   memberExpenses.forEach((key, value) {
  //     totalGroupExpense += value;
  //     _groupDatabaseRef.updateGroupMemberExpense(
  //         groupName: currentGroupName, memberEmail: key, newExpenseSum: value);
  //   });

  //   _groupDatabaseRef.updateGroupTotalExpense(
  //       groupName: currentGroupName, newExpenseSum: totalGroupExpense);

  //   print(totalGroupExpense);
  // }

  onError(e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
