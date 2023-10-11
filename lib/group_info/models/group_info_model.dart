import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  udpate({required GroupsRepo newGroupsState}) {
    groupsRepoState = newGroupsState;
    _initGroupInfoRepo();
  }

  _initGroupInfoRepo() {
    if (groupsRepoState!.appState != null) {
      FirebaseFirestore.instance
          .collection('group')
          .doc(groupsRepoState!.appState!.currentUserGroup)
          .collection('members')
          .snapshots()
          .listen((event) {})
          .onData((data) {
        _groupMembers.clear();
        if (data.docs.isEmpty) {
          // to avail changes from previous app version.
          FirebaseFirestore.instance
              .collection('group')
              .doc(groupsRepoState!.appState!.currentUserGroup)
              .get()
              .then((value) {
            if (value.exists) {
              Map<String, dynamic> groupMembers = value['groupMembers'];

              groupMembers.forEach((key, value) {
                print(value);
                FirebaseFirestore.instance
                    .collection('group')
                    .doc(groupsRepoState!.appState!.currentUserGroup)
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
              print('try');
              _groupMembers.add(GroupInfoRepoModel(
                  memberExpense: element.data()['memberExpense'].toString(),
                  memberName: element.data()['memberName']));
              notifyListeners();
            } catch (e) {
              print('catch');
              print(e);
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
    print('recalculate ..');
    if (groupsRepoState != null && groupsRepoState!.appState != null) {
      print('init success');
      print(groupsRepoState!.appState!.currentUserGroup);
      print(groupsRepoState!.groupsAndExpenseInstances[
              groupsRepoState!.appState!.currentUserGroup]
          ?.toDate()
          .toString());
      FirebaseFirestore.instance
          .collection('expense')
          .doc(groupsRepoState!.appState!.currentUserGroup)
          // .doc(
          //     'Buss pass one day%sudharshan6acharya@gmail.com%2023-08-18%07:22:04.459744')
          // .collection('2023-08-18 07:22:04.459')
          .collection(groupsRepoState!.groupsAndExpenseInstances[
                  groupsRepoState!.appState!.currentUserGroup]!
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
        FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
        memberExpenses.forEach((key, value) {
          totalGroupExpense += value;

          final memberEmailR = key.replaceAll('.', '#');
          final data = {'groupMembers.$memberEmailR.totalExpense': value};

          firebaseFirestore
              .collection('group')
              .doc(groupsRepoState!.appState!.currentUserGroup)
              .update(data);
          firebaseFirestore
              .collection('group')
              .doc(groupsRepoState!.appState!.currentUserGroup)
              .collection('members')
              .doc(key)
              .update({'memberExpense': value});
        });

        firebaseFirestore
            .collection('group')
            .doc(groupsRepoState!.appState!.currentUserGroup)
            .update({'totalExpense': totalGroupExpense});

        print(totalGroupExpense);
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

  exitGroup() {
    if (groupsRepoState != null && groupsRepoState!.appState != null) {
      FirebaseFirestore.instance
          .collection('groupMembers')
          .where('userId',
              isEqualTo: groupsRepoState!.appState!.currentUserEmail)
          .where('groupId',
              isEqualTo: groupsRepoState!.appState!.currentUserGroup)
          .get()
          .then((value) {
        for (var element in value.docs) {
          // element.reference.delete();
          // print(element.data());
          if (element.data()['role'] == Constants().admin) {
            // call firestore function to clean up!
            // & delete doc from groupMembers.
            element.reference
                .delete()
                .whenComplete(() => groupsRepoState?.updateState());
          } else {
            element.reference.delete();
          }
        }
      });
    }
  }
}
