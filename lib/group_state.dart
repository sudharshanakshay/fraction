import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/model/group.dart';
import 'package:fraction/services/group/group.services.dart';

class GroupState extends ChangeNotifier {
  GroupState() {
    init();
  }
  List<dynamic> _groupNames = [];
  List<dynamic> get groupNames => _groupNames;

  init() async {
    await getCloudGroupNames().then((GroupModel groupModel) {
      print('---- print data (group_state) ----');
      print(' ---- ${groupModel.groupMembers} (group_state) ----');
      _groupNames = groupModel.groupMembers;
    });
  }

  Future<void> joinCloudGroup(inputGroupName) async {
    FirebaseFirestore.instance
        .collection('group')
        .where('groupName', isEqualTo: inputGroupName)
        .get()
        .then((querySnapshot) {
      print('Successfully completed');

      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        if (docSnapshot.data()['groupName'] == inputGroupName) {
          updateGroupNameToProfileCollection(inputGroupName);
          updateGroupMembersToGroupCollection(inputGroupName);
        }
      }
    }).whenComplete(() {
      notifyListeners();
    });
  }
}
