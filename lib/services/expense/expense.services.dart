import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/expense.database.dart';
import 'package:fraction/database/group.database.dart';

class ExpenseService extends ApplicationState {
  Stream<QuerySnapshot> getExpenseCollection() {
    try {
      return ExpenseDatabase()
          .getExpenseCollection(currentGroupName: super.currentUserGroup);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Stream<QuerySnapshot> getMyExpenses(
      {required currentUserEmail, required currentUserGroup}) {
    try {
      return ExpenseDatabase().getMyExpenses(
          currentGroupName: currentUserGroup,
          currentUserEmail: currentUserEmail);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future addExpense({required String description, required cost}) async {
    ExpenseDatabase()
        .addExpense(
            currentUserName: super.currentUserName,
            currentGroupName: super.currentUserGroup,
            currentUserEmail: super.currentUserEmail,
            description: description,
            cost: cost)
        .whenComplete(() {
      GroupDatabase().updateGroupMemberExpense(
        memberEmail: super.currentUserEmail,
        groupName: super.currentUserGroup,
        expenseDiff: int.parse(cost),
      );
    });
  }

  void deleteExpense({required docId, required cost}) {
    ExpenseDatabase()
        .deleteMyExpense(
            currentUserEmail: super.currentUserEmail,
            currentGroupName: super.currentUserGroup,
            docId: docId)
        .whenComplete(() {
      GroupDatabase().updateGroupMemberExpense(
          groupName: super.currentUserGroup,
          memberEmail: super.currentUserEmail,
          expenseDiff: -int.parse(cost));
    });
  }
}
