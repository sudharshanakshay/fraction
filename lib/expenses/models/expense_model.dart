import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/expenses/services/expenses_service.dart';
import 'package:fraction/groups/models/groups_models.dart';

class ExpenseRepoModel {
  String docId;
  String description;
  String cost;
  DateTime timeStamp;
  String userName;
  String emailAddress;

  ExpenseRepoModel(
      {required this.docId,
      required this.description,
      required this.cost,
      required this.timeStamp,
      required this.emailAddress,
      required this.userName});
}

class ExpenseRepo extends ChangeNotifier {
  // ---- appState is required to get current selected user expense group ----
  ApplicationState appState;

  // ---- groupRepoState to get the current instance of expense group ----
  GroupsRepo groupsRepoState;

  final ExpenseService _expenseService = ExpenseService();

  final List<ExpenseRepoModel> _expensesList = [];
  List<ExpenseRepoModel> get expenseList => _expensesList;

  bool _hasOneExpense = true;
  bool get hasOneExpense => _hasOneExpense;

  ExpenseRepo({required this.appState, required this.groupsRepoState}) {
    initExpenseInstances();
  }

  initExpenseInstances() {
    if (groupsRepoState.getCurrentExpenseInstance() != null) {
      _expenseService
          .getExpenseCollection(
              currentUserGroup: appState.currentUserGroup,
              currentExpenseInstance:
                  groupsRepoState.getCurrentExpenseInstance()!)
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
                userName: data["userName"]));
            notifyListeners();
          }
        }
        if (_expensesList.isEmpty) {
          _hasOneExpense = false;
          notifyListeners();
        }
        // print(_expensesList);
      });
    }
  }

  Future<void> addExpense(
      {required String description, required String cost}) async {
    if (groupsRepoState.getCurrentExpenseInstance() != null) {
      _expenseService.addExpense(
          description: description,
          cost: cost,
          currentUserName: appState.currentUserName,
          currentUserGroup: appState.currentUserGroup,
          currentUserEmail: appState.currentUserEmail,
          currentExpenseInstance: groupsRepoState.getCurrentExpenseInstance()!);
    }
  }
}
