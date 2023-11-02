import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ExpenseService {
  final String _expenseCollectionName = 'expense';
  late FirebaseFirestore _firebaseFirestore;

  ExpenseService() {
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  Stream<QuerySnapshot> getExpenseCollection(
      {required String currentUserGroup,
      required Timestamp currentExpenseInstance}) {
    try {
      return _firebaseFirestore
          .collection('expense')
          .doc(currentUserGroup)
          .collection(currentExpenseInstance.toDate().toString())
          .orderBy('timeStamp', descending: true)
          .snapshots()
          .handleError((e) {
        throw (e);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return const Stream.empty();
    }
  }

  Future addExpense(
      {required String description,
      required String cost,
      required String currentUserName,
      required String currentUserGroup,
      required String currentUserEmail,
      required Timestamp currentExpenseInstance}) async {
    final data = {
      'description': description,
      'cost': cost as int,
      'tags': [],
      'userName': currentUserName,
      'emailAddress': currentUserEmail,
      'timeStamp': DateTime.now()
    };
    return _firebaseFirestore
        .collection(_expenseCollectionName)
        .doc(currentUserGroup)
        .collection(currentExpenseInstance.toDate().toString())
        .add(data);
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
      final data = {
        'description': updatedDescription,
        'cost': updatedCost,
        'tags': FieldValue.arrayUnion(['updated'])
      };
      _firebaseFirestore
          .collection(_expenseCollectionName)
          .doc(currentUserGroup)
          .collection(currentExpenseInstance.toDate().toString())
          .doc(docId)
          .update(data);
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
      return _firebaseFirestore
          .collection(_expenseCollectionName)
          .doc(currentUserGroup)
          .collection(currentExpenseInstance.toDate().toString())
          .doc(expenseDocId)
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
}
