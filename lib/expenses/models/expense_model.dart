import 'package:flutter/material.dart';

class ExpenseRepoModel {
  String description;
  String cost;
  String timeStamp;
  String userName;
  String emailAddress;

  ExpenseRepoModel(
      {required this.description,
      required this.cost,
      required this.timeStamp,
      required this.emailAddress,
      required this.userName});
}

class ExpenseRepo extends ChangeNotifier {
  String currentExpenseInstance = '';
  String currentExpenseGroup = '';
  ExpenseRepo() {}
}
