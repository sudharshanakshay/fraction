import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/expense/expense.services.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AddExpenseLayout());
  }
}

class AddExpenseLayout extends StatefulWidget {
  const AddExpenseLayout({Key? key}) : super(key: key);

  @override
  State<AddExpenseLayout> createState() => _AddExpenseLayoutState();
}

class _AddExpenseLayoutState extends State<AddExpenseLayout> {
  final _descriptionTextController = TextEditingController();
  final _costTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FractionallySizedBox(
          widthFactor: 0.7,
          //heightFactor: 0.2,
          child: TextField(
              controller: _descriptionTextController,
              decoration: const InputDecoration(
                label: Text('Item Name'),
              ))),
      const SizedBox(height: 10),
      FractionallySizedBox(
          widthFactor: 0.7,
          //heightFactor: 0.2,
          child: TextField(
              controller: _costTextController,
              decoration: const InputDecoration(
                label: Text('Item Cost'),
              ))),
      const SizedBox(height: 10),
      FilledButton(
          onPressed: () {
            addExpenseToCloud(
                description: _descriptionTextController.text,
                cost: _costTextController.text);
            //print('------------------------------------');
            //print(descriptionController.text);
            // var data = FirebaseFirestore.instance
            //     .collection('expense')
            //     .add(<String, dynamic>{
            //   'description': descriptionController.text,
            //   'cost': costController.text,
            //   'time_stamp': DateTime.now()
            // });

            //print("return data : $data");
          },
          child: const Text('Save')),
    ]);
  }

  @override
  dispose() {
    _descriptionTextController.dispose();
    _costTextController.dispose();
    super.dispose();
  }
}
