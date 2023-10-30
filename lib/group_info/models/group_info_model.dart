import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/groups/models/groups_model.dart';
import 'package:fraction/utils/constants.dart';

class GroupInfoRepoModel {
  String memberName;
  String memberExpense;

  GroupInfoRepoModel({required this.memberExpense, required this.memberName});
}

class GroupInfoRepo extends ChangeNotifier {
  GroupsRepo? groupsRepoState;

  final List<GroupInfoRepoModel> _groupMembers = [];
  List<GroupInfoRepoModel> get groupMembers => _groupMembers;

  // GroupInfoRepo() {
  //   _currentGroupDbRef = ;
  // }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  udpate({required GroupsRepo newGroupsState}) {
    groupsRepoState = newGroupsState;
    _initGroupInfoRepo();
  }

  _initGroupInfoRepo() {
    if (groupsRepoState != null) {
      FirebaseFirestore.instance
          .collection('group')
          .doc(groupsRepoState!.currentUserGroup)
          .collection('members')
          .snapshots()
          .listen((event) {})
          .onData((data) {
        _groupMembers.clear();
        if (data.docs.isEmpty) {
          // to avail changes from previous app version.
          FirebaseFirestore.instance
              .collection('group')
              .doc(groupsRepoState!.currentUserGroup)
              .get()
              .then((value) {
            if (value.exists) {
              Map<String, dynamic> groupMembers = value['groupMembers'];

              groupMembers.forEach((key, value) {
                FirebaseFirestore.instance
                    .collection('group')
                    .doc(groupsRepoState!.currentUserGroup)
                    .collection('members')
                    .doc(value['memberEmail'])
                    .set({
                  'memberEmail': value['memberEmail'],
                  'memberName': value['memberName'],
                  'memberExpense': value['totalExpense']
                });
              });
            }
          });
        }
        for (var element in data.docs) {
          if (element.exists) {
            try {
              _groupMembers.add(GroupInfoRepoModel(
                  memberExpense: element.data()['memberExpense'].toString(),
                  memberName: element.data()['memberName']));
              notifyListeners();
            } catch (e) {
              if (kDebugMode) {
                print('catch');
                print(e);
              }

              _groupMembers.add(GroupInfoRepoModel(
                  memberExpense: element.data()['memberExpense'].toString(),
                  memberName: 'name'));
              // element.reference.delete();
            }
          }
        }
      });
    }
  }

  Future<void> recalculateMemberExpenses() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    if (kDebugMode) {
      print('recalculate ..');
    }
    if (groupsRepoState != null && groupsRepoState!.appState != null) {
      firebaseFirestore
          .collection('group')
          .doc(groupsRepoState!.currentUserGroup)
          .get()
          .then((value) {
        var groupMembersDetail = value['groupMembers'] as Map<String, dynamic>;

        groupMembersDetail.forEach((key, value) {
          final data = {'groupMembers.$key.totalExpense': 0};
          firebaseFirestore
              .collection('group')
              .doc(groupsRepoState!.currentUserGroup)
              .update(data);
          final memberEmailR = key.replaceAll('#', '.');
          firebaseFirestore
              .collection('group')
              .doc(groupsRepoState!.currentUserGroup)
              .collection('members')
              .doc(memberEmailR)
              .update({'memberExpense': 0});
        });

        // groupMembers.forEach((key, value) {

        // firebaseFirestore
        // .collection('group')
        // .doc(groupsRepoState!.currentUserGroup)

        // });
      });

      firebaseFirestore
          .collection('expense')
          .doc(groupsRepoState!.currentUserGroup)
          // .doc(
          //     'Buss pass one day%sudharshan6acharya@gmail.com%2023-08-18%07:22:04.459744')
          // .collection('2023-08-18 07:22:04.459')
          .collection(groupsRepoState!
              .groupsAndExpenseInstances[groupsRepoState!.currentUserGroup]!
              .toDate()
              .toString())
          .get()
          .then((value) {
        Map<String, int> memberExpenses = {};
        for (var element in value.docs) {
          try {
            memberExpenses[element['emailAddress']] =
                memberExpenses[element['emailAddress']]! + element['cost']
                    as int;
          } catch (e) {
            final data = {
              element['emailAddress'] as String: element['cost'] as int
            };
            memberExpenses.addAll(data);
          }
        }
        int totalGroupExpense = 0;

        memberExpenses.forEach((key, value) {
          totalGroupExpense += value;

          final memberEmailR = key.replaceAll('.', '#');
          final data = {'groupMembers.$memberEmailR.totalExpense': value};

          firebaseFirestore
              .collection('group')
              .doc(groupsRepoState!.currentUserGroup)
              .update(data);
          firebaseFirestore
              .collection('group')
              .doc(groupsRepoState!.currentUserGroup)
              .collection('members')
              .doc(key)
              .update({'memberExpense': value});
        });

        firebaseFirestore
            .collection('group')
            .doc(groupsRepoState!.currentUserGroup)
            .update({'totalExpense': totalGroupExpense});
      });
    }
  }

  // Future<void> refreshMemberExpenses(
  //     {required String currentGroupName,
  //     required Timestamp currentExpenseInstance}) async {
  //   QuerySnapshot groupExpenseDetails =
  //       await _expenseDatabase.getExpenseCollection(
  //           currentGroupName: currentGroupName,
  //           currentExpenseInstance: currentExpenseInstance.toDate().toString());

  //   Map<String, int> memberExpenses = {};

  //   for (var element in groupExpenseDetails.docs) {
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
  //   }
  //   if (kDebugMode) {
  //   }
  //   int totalGroupExpense = 0;
  //   memberExpenses.forEach((key, value) {
  //     totalGroupExpense += value;
  //     _groupDatabaseRef.updateGroupMemberExpense(
  //         groupName: currentGroupName, memberEmail: key, newExpenseSum: value);
  //   });

  //   _groupDatabaseRef.updateGroupTotalExpense(
  //       groupName: currentGroupName, newExpenseSum: totalGroupExpense);

  // }

  Future<void> clearOff({required DateTime nextClearOffDate}) async {
    if (groupsRepoState != null && groupsRepoState!.currentUserGroup != '') {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final Map<String, dynamic> groupMembers = {};
      firebaseFirestore
          .collection('group')
          .doc(groupsRepoState!.currentUserGroup)
          .get()
          .then((DocumentSnapshot doc) {
        if (doc.exists) {
          final groupDetails = doc.data() as Map<String, dynamic>;
          final memberDetails =
              groupDetails['groupMembers'] as Map<String, dynamic>;
          memberDetails.forEach((key, value) {
            final Map<String, dynamic> groupMember = {
              key: {'totalExpense': 0}
            };
            groupMembers.addAll(groupMember);
          });
        }
      });

      final data = {
        'expenseInstance': DateTime.now(),
        'groupMembers': groupMembers,
        'totalExpense': 0,
        'nextClearOffTimeStamp': nextClearOffDate
      };

      firebaseFirestore
          .collection('group')
          .doc(groupsRepoState!.currentUserGroup)
          .set(data, SetOptions(merge: true));

      firebaseFirestore
          .collection('group')
          .doc(groupsRepoState!.currentUserGroup)
          .collection('members')
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.update({'memberExpense': 0});
        }
      });
    }
  }

  Future<void> exitGroup() async {
    if (groupsRepoState != null && groupsRepoState!.appState != null) {
      FirebaseFirestore.instance
          .collection('groupMembers')
          .where('userId',
              isEqualTo: groupsRepoState!.appState!.currentUserEmail)
          .where('groupId', isEqualTo: groupsRepoState!.currentUserGroup)
          .get()
          .then((value) {
        for (var element in value.docs) {
          // element.reference.delete();
          if (element.data()['role'] == Constants().admin) {
            // call firestore function to clean up!
            // & delete doc from groupMembers.
            element.reference
                .delete()
                .whenComplete(() => groupsRepoState?.updateState());
            FirebaseFunctions.instance
                .httpsCallable("groupClearUpOnDeleteByAdmin")
                .call({"text": groupsRepoState!.currentUserGroup});
          } else {
            element.reference.delete();
          }
        }
      });
    }
  }
}
