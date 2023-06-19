import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';

// ------------- Add Expenses to Firestore -------------

Future<DocumentReference> addExpense(String description, Float cost) {
  return FirebaseFirestore.instance.collection('expense').add(<String, dynamic>{
    'description': description,
    'cost': cost,
    'time_stamp': DateTime.now()
  });
}
