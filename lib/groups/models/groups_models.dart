import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GroupsRepoModel {
  String groupName;
  String lastUpdatedDesc;
  String groupId;
  DateTime lastUpdatedTime;

  GroupsRepoModel(
      {required this.groupName,
      required this.groupId,
      required this.lastUpdatedDesc,
      required this.lastUpdatedTime});
}

class GroupsRepo extends ChangeNotifier {
  final List<GroupsRepoModel> _expenseGroupsList = [];
  String test = "test";
  String currentUserEmail;
  DateTime tempDateTime = DateTime.now();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<GroupsRepoModel> get expenseGroupList => _expenseGroupsList;

  GroupsRepo({required this.currentUserEmail}) {
    initializeGroupRepo();
  }

  initializeGroupRepo() {
    firebaseFirestore
        .collection('groupMembers')
        .where('userId', isEqualTo: currentUserEmail)
        .snapshots()
        .listen((groupMembersEvent) {
      _expenseGroupsList.clear();
      for (var element in groupMembersEvent.docs) {
        firebaseFirestore
            .collection("group")
            .doc(element.data()["groupId"])
            .get()
            .then((groupEvent) {
          if (groupEvent.exists) {
            _expenseGroupsList.add(GroupsRepoModel(
                groupName: groupEvent.data()!['groupName'],
                groupId: element.data()["groupId"],
                lastUpdatedDesc: "lastUpdatedDesc",
                lastUpdatedTime: tempDateTime));
          }
        });
      }
    });
  }
}
