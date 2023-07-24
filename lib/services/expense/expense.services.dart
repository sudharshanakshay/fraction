import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fraction/database/expense.database.dart';
import 'package:fraction/database/group.database.dart';

const _currentGroupName = 'akshaya';
String? _currentUserEmail;

Future<void> init() async {
  FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      _currentUserEmail = user.email!;
      // return _currentUserEmail;
    }
  });
}

Stream<QuerySnapshot> getExpenseCollection() {
  return ExpenseDatabase()
      .getExpenseCollection(currentGroupName: _currentGroupName);
}

Stream<QuerySnapshot> getMyExpenses({required currentUserEmail}) {
  return ExpenseDatabase().getMyExpenses(
      currentGroupName: _currentGroupName, currentUserEmail: currentUserEmail);
}

Future addExpense({required String description, required cost}) async {
  init().whenComplete(() => ExpenseDatabase()
          .addExpense(
              currentGroupName: _currentGroupName,
              currentUserEmail: _currentUserEmail,
              description: description,
              cost: cost)
          .whenComplete(() {
        updateGroupMemberExpense(
          memberEmail: _currentUserEmail,
          groupName: _currentGroupName,
          expenseDiff: int.parse(cost),
        );
      }));
}

void deleteExpense({required docId, required cost}) {
  init().whenComplete(() {
    ExpenseDatabase()
        .deleteMyExpense(
            currentUserEmail: _currentUserEmail,
            currentGroupName: _currentGroupName,
            docId: docId)
        .whenComplete(() {
      updateGroupMemberExpense(
          groupName: _currentGroupName,
          memberEmail: _currentUserEmail,
          expenseDiff: -int.parse(cost));
    });
  });
}
