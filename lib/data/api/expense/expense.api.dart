import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/data/api/utils/database.utils.dart';

class ExpenseDatabase extends DatabaseUtils {
  // final _expenseCollectionName = 'expense';
  late String _expenseCollectionName;
  late FirebaseFirestore _firebaseFirestoreInstance;

  ExpenseDatabase() {
    _firebaseFirestoreInstance = FirebaseFirestore.instance;
    _expenseCollectionName = DatabaseUtils().expenseCollectionName;
  }

  Stream<QuerySnapshot> expenseCollectionStream(
      {required currentGroupName, required currentExpenseInstance}) {
    return _firebaseFirestoreInstance
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
    return _firebaseFirestoreInstance
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

  Future<void> updateChat(
      {required String currentUserEmail,
      required String currentUserGroup,
      required String lastExpenseDesc,
      required DateTime lastExpenseTime,
      required int totalGroupExpense}) async {
    final data = {
      "lastExpenseDesc": lastExpenseDesc,
      "lastExpenseTime": lastExpenseTime,
      "totalGroupExpense": totalGroupExpense
    };
    _firebaseFirestoreInstance
        .collection(chatsCollectionName)
        .doc(currentUserEmail)
        .collection(chatsCollectionName)
        .doc(currentUserGroup)
        .update(data);
  }

  Future<DocumentReference> addExpense(
      {required String currentGroupName,
      required String currentExpenseInstance,
      required String currentUserName,
      required String currentUserEmail,
      required String description,
      required DateTime timeStamp,
      required int cost}) {
    final data = {
      'description': description,
      'cost': cost,
      'tags': [],
      'userName': currentUserName,
      'emailAddress': currentUserEmail,
      'timeStamp': DateTime.now()
    };
    return _firebaseFirestoreInstance
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
    _firebaseFirestoreInstance
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
    return _firebaseFirestoreInstance
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
