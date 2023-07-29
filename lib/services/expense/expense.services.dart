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
    print(super.currentUserGroup);
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

  Future updateExpense({
    required docId,
    required String updatedDescription,
    required updatedCost,
    required previousCost,
  }) async {
    try {
      ExpenseDatabase()
          .updateExpense(
        currentGroupName: super.currentUserGroup,
        docId: docId,
        updatedCost: updatedCost,
        updatedDescription: updatedDescription,
      )
          .whenComplete(() {
        if (int.parse(updatedCost) - int.parse(previousCost) != 0) {
          GroupDatabase().updateGroupMemberExpense(
              groupName: super.currentUserGroup,
              memberEmail: super.currentUserEmail,
              expenseDiff: int.parse(updatedCost) - int.parse(previousCost));
        }
      });
    } catch (e) {}
  }

  Future deleteExpense({required expenseDoc}) async {
    if (super.currentUserEmail == expenseDoc['emailAddress']) {
      ExpenseDatabase()
          .deleteMyExpense(
              currentUserEmail: super.currentUserEmail,
              currentGroupName: super.currentUserGroup,
              docId: expenseDoc.id)
          .whenComplete(() {
        GroupDatabase().updateGroupMemberExpense(
            groupName: super.currentUserGroup,
            memberEmail: super.currentUserEmail,
            expenseDiff: -int.parse(expenseDoc['cost']));
      });
    }
  }
}
