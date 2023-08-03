import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/expense.database.dart';
import 'package:fraction/database/group.database.dart';

class ExpenseService extends ApplicationState {
  late ExpenseDatabase _expenseDatabaseRef;

  ExpenseService() {
    _expenseDatabaseRef = ExpenseDatabase();
  }

  Stream<QuerySnapshot> getExpenseCollection() {
    try {
      return _expenseDatabaseRef.getExpenseCollection(
          currentGroupName: super.currentUserGroup,
          currentExpenseInstance:
              super.currentExpenseInstance.toDate().toString());
    } catch (e) {
      print(e);
      return const Stream.empty();
    }
  }

  // Stream<QuerySnapshot> getMyExpenses(
  //     {required currentUserEmail, required currentUserGroup}) {
  //   try {
  //     return _expenseDatabaseRef.getMyExpenses(
  //         currentGroupName: currentUserGroup,
  //         currentUserEmail: currentUserEmail);
  //   } catch (e) {
  //     return const Stream.empty();
  //   }
  // }

  Future addExpense({required String description, required String cost}) async {
    print(super.currentUserGroup);
    _expenseDatabaseRef
        .addExpense(
            currentUserName: super.currentUserName,
            currentGroupName: super.currentUserGroup,
            currentUserEmail: super.currentUserEmail,
            description: description,
            cost: int.parse(cost),
            currentExpenseInstance:
                super.currentExpenseInstance.toDate().toString())
        .whenComplete(() {
      GroupDatabase().updateGroupMemberExpense(
        memberEmail: super.currentUserEmail,
        groupName: super.currentUserGroup,
        expenseDiff: int.parse(cost),
      );
    });
  }

  Future updateExpense({
    required String docId,
    required String updatedDescription,
    required String updatedCost,
    required int previousCost,
  }) async {
    try {
      _expenseDatabaseRef
          .updateExpense(
        currentGroupName: super.currentUserGroup,
        docId: docId,
        updatedCost: int.parse(updatedCost),
        updatedDescription: updatedDescription,
        currentExpenseInstance:
            super.currentExpenseInstance.toDate().toString(),
      )
          .whenComplete(() {
        if (int.parse(updatedCost) - previousCost != 0) {
          GroupDatabase().updateGroupMemberExpense(
              groupName: super.currentUserGroup,
              memberEmail: super.currentUserEmail,
              expenseDiff: int.parse(updatedCost) - previousCost);
        }
      });
    } catch (e) {}
  }

  Future deleteExpense({required expenseDoc}) async {
    if (super.currentUserEmail == expenseDoc['emailAddress']) {
      _expenseDatabaseRef
          .deleteMyExpense(
              currentUserEmail: super.currentUserEmail,
              currentGroupName: super.currentUserGroup,
              docId: expenseDoc.id,
              currentExpenseInstance:
                  super.currentExpenseInstance.toDate().toString())
          .whenComplete(() {
        GroupDatabase().updateGroupMemberExpense(
            groupName: super.currentUserGroup,
            memberEmail: super.currentUserEmail,
            expenseDiff: -expenseDoc['cost']);
      });
    }
  }
}
