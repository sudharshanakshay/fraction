import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';

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
  final descriptionController = TextEditingController();
  final costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FractionallySizedBox(
          widthFactor: 0.7,
          //heightFactor: 0.2,
          child: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                label: Text('Item Name'),
              ))),
      const SizedBox(height: 10),
      FractionallySizedBox(
          widthFactor: 0.7,
          //heightFactor: 0.2,
          child: TextField(
              controller: costController,
              decoration: const InputDecoration(
                label: Text('Item Cost'),
              ))),
      const SizedBox(height: 10),
      FilledButton(
          onPressed: () {
            //print('------------------------------------');
            //print(descriptionController.text);
            var data = FirebaseFirestore.instance
                .collection('expense')
                .add(<String, dynamic>{
              'description': descriptionController.text,
              'cost': costController.text,
              'time_stamp': DateTime.now()
            });

            //print("return data : $data");
          },
          child: const Text('Save')),
    ]);
  }

  @override
  dispose() {
    descriptionController.dispose();
    costController.dispose();
    super.dispose();
  }
}
