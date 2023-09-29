import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/data/api/expense/expense.api.dart';
import 'package:fraction/data/api/group/group.api.dart';

class ExpenseService {
  late ExpenseDatabase _expenseDatabaseRef;
  late GroupDatabase _groupDatabase;

  ExpenseService() {
    _expenseDatabaseRef = ExpenseDatabase();
    _groupDatabase = GroupDatabase();
  }

  Stream<QuerySnapshot> getExpenseCollection(
      {required String currentUserGroup,
      required Timestamp currentExpenseInstance}) {
    try {
      return _expenseDatabaseRef.expenseCollectionStream(
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
    final timeStamp = DateTime.now();
    _expenseDatabaseRef
        .addExpense(
            currentUserName: currentUserName,
            currentGroupName: currentUserGroup,
            currentUserEmail: currentUserEmail,
            description: description,
            cost: int.parse(cost),
            currentExpenseInstance: currentExpenseInstance.toDate().toString(),
            timeStamp: timeStamp)
        .then((DocumentReference documentReference) {
      _groupDatabase
          .incrementOrDecrementGroupMemberExpense(
            memberEmail: currentUserEmail,
            groupName: currentUserGroup,
            expenseDiff: int.parse(cost),
          )
          .onError((error, stackTrace) => _expenseDatabaseRef.deleteMyExpense(
              currentUserEmail: currentUserEmail,
              currentGroupName: currentUserGroup,
              currentExpenseInstance: currentExpenseInstance,
              docId: documentReference));
    }).onError((error, stackTrace) => null);
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
          _groupDatabase.incrementOrDecrementGroupMemberExpense(
              groupName: currentUserGroup,
              memberEmail: currentUserEmail,
              expenseDiff: int.parse(updatedCost) - previousCost);
        }
      });
    } catch (e) {}
  }

  Future deleteExpense({
    required String expenseDocId,
    required String emailAddress,
    required String currentUserEmail,
    required String currentUserGroup,
    required Timestamp currentExpenseInstance,
  }) async {
    if (currentUserEmail == emailAddress) {
      _expenseDatabaseRef.deleteMyExpense(
          currentUserEmail: currentUserEmail,
          currentGroupName: currentUserGroup,
          docId: expenseDocId,
          currentExpenseInstance: currentExpenseInstance.toDate().toString());
      // this functionality is now handled by trigger function.
      //     .whenComplete(() {
      //   _groupDatabase.incrementOrDecrementGroupMemberExpense(
      //       groupName: currentUserGroup,
      //       memberEmail: currentUserEmail,
      //       expenseDiff: -expenseDoc['cost']);
      // });
    }
  }
}
