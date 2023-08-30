import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/data/api/utils/api.dart';

class ExpenseDatabase extends DatabaseUtils {
  // final _expenseCollectionName = 'expense';
  late String _expenseCollectionName;
  late FirebaseFirestore _databaseRef;

  ExpenseDatabase() {
    _databaseRef = FirebaseFirestore.instance;
    _expenseCollectionName = DatabaseUtils().expenseCollectionName;
  }

  Stream<QuerySnapshot> expenseCollectionStream(
      {required currentGroupName, required currentExpenseInstance}) {
    return _databaseRef
        .collection(_expenseCollectionName)
        .doc(currentGroupName)
        .collection(currentExpenseInstance)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .handleError((e) {
      throw (e);
    });
  }

  Future<QuerySnapshot> getExpenseCollection(
      {required String currentGroupName,
      required String currentExpenseInstance}) {
    return _databaseRef
        .collection(_expenseCollectionName)
        .doc(currentGroupName)
        .collection(currentExpenseInstance)
        .orderBy('timeStamp', descending: true)
        .get();
  }

  // Stream<QuerySnapshot> getMyExpenses(
  //     {required currentGroupName, required currentUserEmail}) {
  //   return FirebaseFirestore.instance
  //       .collection('group')
  //       .doc(currentGroupName)
  //       .collection('expense')
  //       .where('emailAddress', isEqualTo: currentUserEmail)
  //       .orderBy('timeStamp', descending: true)
  //       .snapshots();
  // }

  Future<DocumentReference> addExpense(
      {required String currentGroupName,
      required String currentExpenseInstance,
      required String currentUserName,
      required String currentUserEmail,
      required String description,
      required int cost}) {
    final data = {
      'description': description,
      'cost': cost,
      'tags': [],
      'userName': currentUserName,
      'emailAddress': currentUserEmail,
      'timeStamp': DateTime.now()
    };
    return _databaseRef
        .collection(_expenseCollectionName)
        .doc(currentGroupName)
        .collection(currentExpenseInstance)
        .add(data);
  }

  Future updateExpense({
    required String currentGroupName,
    required String currentExpenseInstance,
    required String docId,
    required String updatedDescription,
    required int updatedCost,
  }) async {
    final data = {
      'description': updatedDescription,
      'cost': updatedCost,
      'tags': FieldValue.arrayUnion(['updated'])
    };
    _databaseRef
        .collection(_expenseCollectionName)
        .doc(currentGroupName)
        .collection(currentExpenseInstance)
        .doc(docId)
        .update(data)
        .whenComplete(() {});
  }

  Future deleteMyExpense(
      {required currentUserEmail,
      required currentGroupName,
      required currentExpenseInstance,
      required docId}) async {
    return _databaseRef
        .collection(_expenseCollectionName)
        .doc(currentGroupName)
        .collection(currentExpenseInstance)
        .doc(docId)
        .delete()
        .then(
      (doc) {
        if (kDebugMode) {
          print("Document deleted");
        }
      },
      onError: (e) => print("Error deleting document $e"),
    );
  }
}
