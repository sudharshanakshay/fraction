import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/groups/models/groups_model.dart';

class MemberExpenseBreakdownModel {
  String memberName;
  String memberExpenditureSummary;

  MemberExpenseBreakdownModel(
      {required this.memberName, required this.memberExpenditureSummary});
}

class MemberExpenseBreakdownRepoNotifier extends ChangeNotifier {
  GroupsRepo? groupsRepoState;

  final List<MemberExpenseBreakdownModel> _memberExpenseBreakdownRepo = [];
  List<MemberExpenseBreakdownModel> get memberExpenseBreakdownRepo =>
      _memberExpenseBreakdownRepo;

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
        _memberExpenseBreakdownRepo.clear();
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
        var totalExpenditure = 0.0;
        var count = 0;

        for (var e in data.docs) {
          totalExpenditure += e.data()['memberExpense'];
          count++;
        }
        var totalExpenditureByCount = totalExpenditure / count;
        print(totalExpenditure);
        for (var element in data.docs) {
          if (element.exists) {
            try {
              _memberExpenseBreakdownRepo.add(MemberExpenseBreakdownModel(
                  memberExpenditureSummary: (totalExpenditureByCount -
                          element.data()['memberExpense'])
                      .toString(),
                  memberName: element.data()['memberName']));
              notifyListeners();
            } catch (e) {
              if (kDebugMode) {
                print('catch');
                print(e);
              }

              _memberExpenseBreakdownRepo.add(MemberExpenseBreakdownModel(
                  memberExpenditureSummary:
                      element.data()['memberExpense'].toString(),
                  memberName: 'name'));
            }
          }
        }
      });
    }
  }
}
