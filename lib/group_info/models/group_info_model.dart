import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';

class GroupInfoRepoModel {
  String memberName;
  String memberExpense;

  GroupInfoRepoModel({required this.memberExpense, required this.memberName});
}

class GroupInfoRepo extends ChangeNotifier {
  final ApplicationState appState;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final List<GroupInfoRepoModel> _groupMembers = [];
  List<GroupInfoRepoModel> get groupMembers => _groupMembers;

  GroupInfoRepo({required this.appState}) {
    _initGroupInfoRepo();
  }

  _initGroupInfoRepo() {
    _firebaseFirestore
        .collection('group')
        .doc(appState.currentUserGroup)
        .collection('members')
        .snapshots()
        .listen((event) {})
        .onData((data) {
      for (var element in data.docs) {
        if (element.exists) {
          _groupMembers.add(GroupInfoRepoModel(
              memberExpense: element.data()['memberExpense'].toString(),
              memberName: 'name'));
          notifyListeners();
        }
      }
    });
  }
}
