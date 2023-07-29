import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseDatabase {
  final _expenseCollectionName = 'expense';

  Stream<QuerySnapshot> getExpenseCollection({required currentGroupName}) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(currentGroupName)
        .collection(_expenseCollectionName)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .handleError((e) {
      throw (e);
    });
  }

  Stream<QuerySnapshot> getMyExpenses(
      {required currentGroupName, required currentUserEmail}) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(currentGroupName)
        .collection('expense')
        .where('emailAddress', isEqualTo: currentUserEmail)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Future<void> addExpense(
      {required currentGroupName,
      required currentUserName,
      required currentUserEmail,
      required String description,
      required cost}) {
    final data = {
      'description': description,
      'cost': cost,
      'tag': [],
      'userName': currentUserName,
      'emailAddress': currentUserEmail,
      'timeStamp': DateTime.now()
    };
    return FirebaseFirestore.instance
        .collection('group')
        .doc(currentGroupName)
        .collection('expense')
        .doc()
        .set(data);
  }

  Future updateExpense({
    required currentGroupName,
    required docId,
    required updatedDescription,
    required updatedCost,
  }) async {
    final data = {
      'description': updatedDescription,
      'cost': updatedCost,
      'tag': 'updated'
    };
    FirebaseFirestore.instance
        .collection('group')
        .doc(currentGroupName)
        .collection(_expenseCollectionName)
        .doc(docId)
        .update(data)
        .whenComplete(() {});
  }

  Future deleteMyExpense(
      {required currentUserEmail,
      required currentGroupName,
      required docId}) async {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(currentGroupName)
        .collection('expense')
        .doc(docId)
        .delete()
        .then(
      (doc) {
        print("Document deleted");
      },
      onError: (e) => print("Error deleting document $e"),
    );
  }
}
