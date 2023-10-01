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
  late DocumentReference _currentGroupDbRef;

  final List<GroupInfoRepoModel> _groupMembers = [];
  List<GroupInfoRepoModel> get groupMembers => _groupMembers;

  GroupInfoRepo({required this.appState}) {
    _currentGroupDbRef = FirebaseFirestore.instance
        .collection('group')
        .doc(appState.currentUserGroup);
    _initGroupInfoRepo();
  }

  _initGroupInfoRepo() {
    _currentGroupDbRef
        .collection('members')
        .snapshots()
        .listen((event) {})
        .onData((data) {
      _groupMembers.clear();
      if (data.docs.isEmpty) {
        // to avail changes from previous app version.
        _currentGroupDbRef.get().then((value) {
          if (value.exists) {
            Map<String, dynamic> groupMembers = value['groupMembers'];

            groupMembers.forEach((key, value) {
              print(value);
              _currentGroupDbRef
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
            // element.reference.delete();
          }
        }
      }
    });
  }
}
