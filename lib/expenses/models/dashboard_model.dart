import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';

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
  ApplicationState appState;

  final DashboardRepoModel _dashboard = DashboardRepoModel(
      myExpense: "_", nextClearOffDate: DateTime.now(), totalExpense: "_");

  DashboardRepoModel get dashboard => _dashboard;

  DashboardRepo({required this.appState}) {
    _initDashboardRepo();
  }

  _initDashboardRepo() {
    _firebaseFirestore
        .collection('group')
        .doc(appState.currentUserGroup)
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
        .doc(appState.currentUserGroup)
        .collection('members')
        .doc(appState.currentUserEmail)
        .snapshots()
        .listen((event) {})
        .onData((data) {
      if (data.exists) {
        _dashboard.myExpense = data.data()!['memberExpense'].toString();
        notifyListeners();
      }
    });
  }
}
