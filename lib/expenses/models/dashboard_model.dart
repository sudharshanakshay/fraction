import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/groups/models/groups_model.dart';

class DashboardRepoModel {
  String totalExpense;
  String myExpense;
  DateTime nextClearOffDate;

  DashboardRepoModel(
      {required this.myExpense,
      required this.nextClearOffDate,
      required this.totalExpense});
}

class DashboardRepo extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  GroupsRepo? groupsRepoState;

  final DashboardRepoModel _dashboard = DashboardRepoModel(
      myExpense: "_", nextClearOffDate: DateTime.now(), totalExpense: "_");

  DashboardRepoModel get dashboard => _dashboard;

  DashboardRepo() {
    _initDashboardRepo();
  }

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

  update({
    required GroupsRepo newGroupsRepoState,
  }) {
    // appState = newAppState;
    groupsRepoState = newGroupsRepoState;
    _initDashboardRepo();
  }

  _initDashboardRepo() {
    try {
      if (groupsRepoState != null &&
          groupsRepoState!.appState != null &&
          groupsRepoState!.currentUserGroup != '') {
        _firebaseFirestore
            .collection('group')
            .doc(groupsRepoState!.currentUserGroup)
            .snapshots()
            .listen((event) {})
            .onData((data) {
          if (data.exists) {
            _dashboard.nextClearOffDate =
                data.data()!['nextClearOffTimeStamp'].toDate();
            _dashboard.totalExpense = data.data()!['totalExpense'].toString();
            notifyListeners();
          }
        });

        _firebaseFirestore
            .collection('group')
            .doc(groupsRepoState!.currentUserGroup)
            .collection('members')
            .doc(groupsRepoState!.appState!.currentUserEmail)
            .snapshots()
            .listen((event) {})
            .onData((data) {
          if (data.exists) {
            _dashboard.myExpense = data.data()!['memberExpense'].toString();
            notifyListeners();
          }
        });
      } else {
        if (kDebugMode) {
          print('else at dashboar_model.dart');
          print("groupsRepoState : $groupsRepoState");
          print("groupsRepoState!.appState : ${groupsRepoState!.appState}");
          print(
              "groupsRepoState!.currentUserGroup : ${groupsRepoState!.currentUserGroup}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('exception at dashboar_model.dart');
        print(e);
      }
    }
  }
}
