import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';

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

  ApplicationState appState;
  DateTime tempDateTime = DateTime.now();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final Map<String, Timestamp> _groupsAndExpenseInstances = {};

  Map<String, Timestamp> get groupAndExpenseInstances =>
      _groupsAndExpenseInstances;

  Timestamp? getCurrentExpenseInstance() =>
      _groupsAndExpenseInstances[appState.currentUserGroup];

  bool _hasOneGroup = true;
  bool get hasOneGroup => _hasOneGroup;

  GroupsRepo({required this.appState}) {
    initializeGroupRepo();
  }

  initializeGroupRepo() {
    // ---- query to fetch expenseGroup of currentUser from groupMembers collection ----
    // ---- groupMembers collection stored the many-to-many relation users & expensegroups ----
    firebaseFirestore
        .collection('groupMembers')
        .where('userId', isEqualTo: appState.currentUserEmail)
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
            try {
              _expenseGroupsList.add(GroupsRepoModel(
                  groupName: groupEvent.data()!['groupName'],
                  groupId: element.data()["groupId"],
                  lastUpdatedDesc: groupEvent.data()!["lastUpdatedDesc"],
                  lastUpdatedTime: DateTime.fromMillisecondsSinceEpoch(
                      groupEvent.data()!["lastUpdatedTime"],
                      isUtc: true)));
              // notifyListeners();
            } catch (e) {
              _expenseGroupsList.add(GroupsRepoModel(
                  groupName: groupEvent.data()!['groupName'],
                  groupId: element.data()["groupId"],
                  lastUpdatedDesc: groupEvent.data()!["lastUpdatedDesc"],
                  lastUpdatedTime:
                      groupEvent.data()!["lastUpdatedTime"].toDate()));
              // notifyListeners();
            }
            // ---- collection of instances of expenseGroups ----
            _groupsAndExpenseInstances.addAll({
              element.data()["groupId"]: groupEvent.data()!['expenseInstance']
            });
          }
        });
      }
      print('for loop done');
    }).onData((data) {
      // print(data.docs[0].data());
      for (var element in data.docs) {
        // ---- query to fetch expenseGroup name from group collection ----
        firebaseFirestore
            .collection("group")
            .doc(element.data()["groupId"])
            .snapshots()
            .listen((groupEvent) {
          if (groupEvent.exists) {
            // ---- this data is display in the frontend ----
            try {
              _expenseGroupsList.add(GroupsRepoModel(
                  groupName: groupEvent.data()!['groupName'],
                  groupId: element.data()["groupId"],
                  lastUpdatedDesc: groupEvent.data()!["lastUpdatedDesc"],
                  lastUpdatedTime: DateTime.fromMillisecondsSinceEpoch(
                      groupEvent.data()!["lastUpdatedTime"],
                      isUtc: true)));
              // notifyListeners();
            } catch (e) {
              _expenseGroupsList.add(GroupsRepoModel(
                  groupName: groupEvent.data()!['groupName'],
                  groupId: element.data()["groupId"],
                  lastUpdatedDesc: groupEvent.data()!["lastUpdatedDesc"],
                  lastUpdatedTime:
                      groupEvent.data()!["lastUpdatedTime"].toDate()));
              // notifyListeners();
            }
            // ---- collection of instances of expenseGroups ----
            _groupsAndExpenseInstances.addAll({
              element.data()["groupId"]: groupEvent.data()!['expenseInstance']
            });
            print('sorting started!');
            // ---- sorting in decending order of the TimeStamp.
            _expenseGroupsList.sort((a, b) =>
                a.lastUpdatedTime.isAfter(b.lastUpdatedTime) ? -1 : 1);
            print(_expenseGroupsList);
            notifyListeners();
          }
        });
      }
    });

    // .whenComplete(() {
    //       print(_expenseGroupsList);

    //     });

    if (_expenseGroupsList.isEmpty) {
      _hasOneGroup = false;
    }
  }
}
