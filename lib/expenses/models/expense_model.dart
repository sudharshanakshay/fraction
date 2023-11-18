import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/expenses/services/expenses_service.dart';
import 'package:fraction/groups/models/groups_model.dart';

class ExpenseRepoModel {
  String docId;
  String description;
  String cost;
  DateTime timeStamp;
  String userName;
  String emailAddress;
  late List<String> tags;

  ExpenseRepoModel(
      {required this.docId,
      required this.description,
      required this.cost,
      required this.timeStamp,
      required this.emailAddress,
      required this.userName,
      required List dynamicTypeTags}) {
    tags = dynamicTypeTags.cast<String>();
  }
}

class ExpenseRepo extends ChangeNotifier {
  // ---- appState is required to get current selected user expense group ----
  ApplicationState? appState;

  // ---- groupRepoState to get the current instance of expense group ----
  GroupsRepo? groupsRepoState;

  final ExpenseService _expenseService = ExpenseService();

  final List<ExpenseRepoModel> _expensesList = [];
  List<ExpenseRepoModel> get expenseList => _expensesList;

  bool _hasOneExpense = true;
  bool get hasOneExpense => _hasOneExpense;

  static int count = 0;

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

  update(
      {required ApplicationState newAppState,
      required GroupsRepo newGroupsRepoState}) {
    appState = newAppState;
    groupsRepoState = newGroupsRepoState;

    if (appState != null) {
      // _currentExpenseInstance = newGroupsRepoState
      //     .groupsAndExpenseInstances[appState?.currentUserGroup];
      initExpenseInstances();
    }
  }

  initExpenseInstances() {
    try {
      if (kDebugMode) {
        count++;
        print("update: $count");
      }

      if (groupsRepoState != null &&
          groupsRepoState!.currentExpenseInstance != null) {
        _expenseService
            .getExpenseCollection(
                currentUserGroup: groupsRepoState!.currentUserGroup,
                currentExpenseInstance:
                    groupsRepoState!.currentExpenseInstance!)
            .listen((event) {
          _expensesList.clear();
          for (var element in event.docs) {
            if (element.exists) {
              final data = element.data() as Map<String, dynamic>;
              _expensesList.add(ExpenseRepoModel(
                docId: element.id,
                description: data["description"],
                cost: data["cost"].toString(),
                timeStamp: data["timeStamp"].toDate(),
                emailAddress: data["emailAddress"],
                userName: data["userName"],
                dynamicTypeTags: data["tags"],
              ));
              notifyListeners();
            }
          }
          if (_expensesList.isEmpty) {
            _hasOneExpense = false;
            notifyListeners();
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('exception at expense_model.dart');
        print(e);
      }
    }
  }

  Future<void> addExpense(
      {required String description, required String cost}) async {
    if (groupsRepoState != null &&
        groupsRepoState!.currentExpenseInstance != null) {
      _expenseService.addExpense(
          description: description,
          cost: cost,
          currentUserName: appState!.currentUserName,
          currentUserGroup: groupsRepoState!.currentUserGroup,
          currentUserEmail: appState!.currentUserEmail,
          currentExpenseInstance: groupsRepoState!.currentExpenseInstance!);
    }
  }

  Future<void> updateExpense({
    required String docId,
    required String updatedDescription,
    required String updatedCost,
  }) async {
    if (groupsRepoState != null &&
        groupsRepoState!.currentExpenseInstance != null &&
        groupsRepoState!.currentUserGroup != '') {
      final data = {
        'description': updatedDescription,
        'cost': double.parse(updatedCost),
        'tags': FieldValue.arrayUnion(['updated'])
      };
      FirebaseFirestore.instance
          .collection('expense')
          .doc(groupsRepoState!.currentUserGroup)
          .collection(
              groupsRepoState!.currentExpenseInstance!.toDate().toString())
          .doc(docId)
          .update(data)
          .whenComplete(() {});
    }
  }

  Future<void> deleteExpense({required docId}) async {
    if (groupsRepoState != null &&
        groupsRepoState!.currentExpenseInstance != null &&
        groupsRepoState!.currentUserGroup != '' &&
        appState != null &&
        appState!.currentUserEmail != '') {
      FirebaseFirestore.instance
          .collection('expense')
          .doc(groupsRepoState!.currentUserGroup)
          .collection(
              groupsRepoState!.currentExpenseInstance!.toDate().toString())
          .doc(docId)
          .get()
          .then(
        (doc) {
          if (doc.exists) {
            if (doc.data()?['emailAddress'] == appState!.currentUserEmail) {
              doc.reference.delete();
              if (kDebugMode) {
                print("Document deleted");
              }
            } else {
              if (kDebugMode) {
                print('no delete access');
              }
            }
          }
        },
        onError: (e) => print("Error deleting document $e"),
      );
    }
  }
}
