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
  List<GroupsRepoModel> get expenseGroupList => _expenseGroupsList;

  String currentUserEmail;
  DateTime tempDateTime = DateTime.now();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final Map<String, Timestamp> _groupsAndExpenseInstances = {};

  Map<String, Timestamp> get groupAndExpenseInstances =>
      _groupsAndExpenseInstances;

  Timestamp getCurrentExpenseInstance({required currentUserGroup}) =>
      _groupsAndExpenseInstances[currentUserGroup]!;

  GroupsRepo({required this.currentUserEmail}) {
    initializeGroupRepo();
  }

  initializeGroupRepo() {
    // ---- query to fetch expenseGroup of currentUser from groupMembers collection ----
    // ---- groupMembers collection stored the many-to-many relation users & expensegroups ----
    firebaseFirestore
        .collection('groupMembers')
        .where('userId', isEqualTo: currentUserEmail)
        .snapshots()
        .listen((groupMembersEvent) {
      _expenseGroupsList.clear();
      for (var element in groupMembersEvent.docs) {
        // ---- query to fetch expenseGroup name from group collection ----
        firebaseFirestore
            .collection("group")
            .doc(element.data()["groupId"])
            .get()
            .then((groupEvent) {
          if (groupEvent.exists) {
            // ---- this data is display in the frontend ----
            _expenseGroupsList.add(GroupsRepoModel(
                groupName: groupEvent.data()!['groupName'],
                groupId: element.data()["groupId"],
                lastUpdatedDesc: "lastUpdatedDesc",
                lastUpdatedTime: tempDateTime));
            // ---- collection of instances of expenseGroups ----
            _groupsAndExpenseInstances.addAll({
              element.data()["groupId"]: groupEvent.data()!['expenseInstance']
            });
          }
        });
      }
    });
  }
}
