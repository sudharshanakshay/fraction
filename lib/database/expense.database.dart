import 'package:cloud_firestore/cloud_firestore.dart';

const expenseCollectionName = 'expense';

class ExpenseDatabase {
  Stream<QuerySnapshot> getExpenseCollection({required currentGroupName}) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(currentGroupName)
        .collection(expenseCollectionName)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Future<void> addExpense(
      {required currentGroupName,
      required currentUserEmail,
      required String description,
      required cost}) {
    return FirebaseFirestore.instance
        .collection('profile')
        .doc(currentUserEmail)
        .get()
        .then((doc) {
      final data = {
        'description': description,
        'cost': cost,
        'userName': doc.data()?['userName'],
        'emailAddress': doc.data()?['emailAddress'],
        'timeStamp': DateTime.now()
      };
      FirebaseFirestore.instance
          .collection('group')
          .doc(currentGroupName)
          .collection('expense')
          .doc()
          .set(data);
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
      onError: (e) => print("Error updating document $e"),
    );
  }

  // getExpenseAndAddToSubCollectionInGroup() {
  //   FirebaseFirestore.instance.collection('expense').get().then((value) {
  //     if (value.docs.isNotEmpty) {
  //       for (var element in value.docs) {
  //         print(element.data());
  //         FirebaseFirestore.instance
  //             .collection('group')
  //             .doc('akshaya')
  //             .collection('expense')
  //             .doc()
  //             .set(element.data());
  //       }
  //     }
  //   });
  // }
}
