import 'package:cloud_firestore/cloud_firestore.dart';

void addExpense(email, description, cost, group) {
  FirebaseFirestore.instance.collection('expense').add(<String, dynamic>{
    'description': description,
    'cost': cost,
    'email_address': email,
    'group_id': group,
    'time_stamp': DateTime.now()
  });
}
