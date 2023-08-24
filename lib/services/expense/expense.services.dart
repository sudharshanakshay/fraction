import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/api/expense.api.dart';
import 'package:fraction/api/group.api.dart';

class ExpenseService {
  late ExpenseDatabase _expenseDatabaseRef;

  ExpenseService() {
    _expenseDatabaseRef = ExpenseDatabase();
  }

  Stream<QuerySnapshot> getExpenseCollection(
      {required String currentUserGroup,
      required Timestamp currentExpenseInstance}) {
    try {
      return _expenseDatabaseRef.getExpenseCollection(
          currentGroupName: currentUserGroup,
          currentExpenseInstance: currentExpenseInstance.toDate().toString());
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

  Future addExpense(
      {required String description,
      required String cost,
      required String currentUserName,
      required String currentUserGroup,
      required String currentUserEmail,
      required Timestamp currentExpenseInstance}) async {
    _expenseDatabaseRef
        .addExpense(
            currentUserName: currentUserName,
            currentGroupName: currentUserGroup,
            currentUserEmail: currentUserEmail,
            description: description,
            cost: int.parse(cost),
            currentExpenseInstance: currentExpenseInstance.toDate().toString())
        .whenComplete(() {
      GroupDatabase().updateGroupMemberExpense(
        memberEmail: currentUserEmail,
        groupName: currentUserGroup,
        expenseDiff: int.parse(cost),
      );
    });
  }

  Future updateExpense({
    required String currentUserEmail,
    required String currentUserGroup,
    required Timestamp currentExpenseInstance,
    required String docId,
    required String updatedDescription,
    required String updatedCost,
    required int previousCost,
  }) async {
    try {
      _expenseDatabaseRef
          .updateExpense(
        currentGroupName: currentUserGroup,
        docId: docId,
        updatedCost: int.parse(updatedCost),
        updatedDescription: updatedDescription,
        currentExpenseInstance: currentExpenseInstance.toDate().toString(),
      )
          .whenComplete(() {
        if (int.parse(updatedCost) - previousCost != 0) {
          GroupDatabase().updateGroupMemberExpense(
              groupName: currentUserGroup,
              memberEmail: currentUserEmail,
              expenseDiff: int.parse(updatedCost) - previousCost);
        }
      });
    } catch (e) {}
  }

  Future deleteExpense({
    required expenseDoc,
    required String currentUserEmail,
    required String currentUserGroup,
    required Timestamp currentExpenseInstance,
  }) async {
    if (currentUserEmail == expenseDoc['emailAddress']) {
      _expenseDatabaseRef
          .deleteMyExpense(
              currentUserEmail: currentUserEmail,
              currentGroupName: currentUserGroup,
              docId: expenseDoc.id,
              currentExpenseInstance:
                  currentExpenseInstance.toDate().toString())
          .whenComplete(() {
        GroupDatabase().updateGroupMemberExpense(
            groupName: currentUserGroup,
            memberEmail: currentUserEmail,
            expenseDiff: -expenseDoc['cost']);
      });
    }
  }
}
