import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';
// import 'package:fraction/data/api/expense/expense.api.dart';
// import 'package:fraction/data/api/group/group.api.dart';
// import 'package:fraction/data/api/notification/notification.api.dart';
// import 'package:fraction/data/api/user/user.api.dart';
import 'package:fraction/notification/services/notification_service.dart';
import 'package:fraction/utils/constants.dart';

class GroupServices {
  // late GroupDatabase _groupDatabaseRef;
  // late UserDatabase _userDatabaseRef;
  // late ExpenseDatabase _expenseDatabase;
  // late NotificationDatabase _notificationDatabaseRef;
  late FirebaseFirestore _firebaseFirestore;
  late NotificationService _notificationService;

  final String _groupCollectionName = 'group';

  GroupServices() {
    // _groupDatabaseRef = GroupDatabase();
    // _userDatabaseRef = UserDatabase();
    _firebaseFirestore = FirebaseFirestore.instance;
    // _expenseDatabase = ExpenseDatabase();
    // _notificationDatabaseRef = NotificationDatabase();
  }

  Future<String> createGroup(
      {required String currentUserName,
      required String currentUserEmail,
      required inputGroupName,
      required nextClearOffTimeStamp,
      ApplicationState? applicationState}) async {
    try {
      final adminEmailR = currentUserEmail.replaceAll('.', '#');
      final data = {
        'createdOn': DateTime.now(),
        'createdBy': currentUserEmail,
        'expenseInstance': DateTime.now(),
        'nextClearOffTimeStamp': nextClearOffTimeStamp,
        'groupName': inputGroupName,
        'totalExpense': 0,
        'groupMembers': {
          adminEmailR: {
            'memberName': currentUserName,
            'memberEmail': currentUserEmail,
            'totalExpense': 0
          }
        },
        'lastUpdatedTime': DateTime.now(),
        'lastUpdatedDesc': 'new Group',
      };

      final String groupNameWithIdentity =
          '$inputGroupName%$currentUserEmail%${DateTime.now().toString().replaceAll(RegExp(r'[\s]'), '%')}';

      if (kDebugMode) {
        print('group info: $data');
      }

      return _firebaseFirestore
          .collection(_groupCollectionName)
          .doc(groupNameWithIdentity)
          .set(data)
          .then((value) {
        // push one doc to sub-collection 'members' in 'group' collection.
        _firebaseFirestore
            .collection(_groupCollectionName)
            .doc(groupNameWithIdentity)
            .collection('members')
            .doc(currentUserEmail)
            .set({
          'memberName': currentUserName,
          'memberEmail': currentUserEmail,
          'memberExpense': 0
        }).then((value) {
          final groupMemberRelation = {
            "groupId": groupNameWithIdentity,
            "userId": currentUserEmail,
            "role": "admin",
          };

          _firebaseFirestore
              .collection("groupMembers")
              .add(groupMemberRelation);
        });
        return groupNameWithIdentity;
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
        final currentUserEmailR = currentUserEmail.replaceAll('.', '#');

        _firebaseFirestore.collection(_groupCollectionName).get().then((value) {
          for (var groupDoc in value.docs) {
            if (groupDoc.id == groupName) {
              final data = {
                'groupMembers': {
                  currentUserEmailR: {
                    'memberEmail': currentUserEmail,
                    'memberName': currentUserName,
                    'totalExpense': 0
                  }
                }
              };
              _firebaseFirestore
                  .collection(_groupCollectionName)
                  .doc(groupName)
                  .collection('members')
                  .doc(currentUserEmail)
                  .set({
                'memberName': currentUserName,
                'memberEmail': currentUserEmail,
                'memberExpense': 0
              }).then((value) {
                final groupMemberRelation = {
                  "groupId": groupName,
                  "userId": currentUserEmail,
                  "role": "member",
                };

                _firebaseFirestore
                    .collection("groupMembers")
                    .add(groupMemberRelation);
              });

              // push one doc to sub-collection 'members' in 'group' collection.
              _firebaseFirestore
                  .collection(_groupCollectionName)
                  .doc(groupName)
                  .set(data, SetOptions(merge: true))
                  .whenComplete(() {
                if (kDebugMode) {
                  print('group added');
                }
                _notificationService.deleteNotification(docId: docId);
                // _userDatabaseRef
                //     .insertGroupNameToProfile(
                //         currentUserEmail: currentUserEmail,
                //         groupNameToAdd: groupName.trim())
                //     .whenComplete(() {
                //   if (applicationState != null) {
                //     // applicationState.refreshGroupNamesAndExpenseInstances();

                //   }
                // });
              });
            } else {
              if (kDebugMode) {
                // print('group name doesnt exists');
              }
            }
          }
        });
      }
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
