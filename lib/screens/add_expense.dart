import 'package:flutter/material.dart';

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
  final itemNameController = TextEditingController();
  final itemCostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FractionallySizedBox(
          widthFactor: 0.7,
          //heightFactor: 0.2,
          child: TextField(
              controller: itemNameController,
              decoration: const InputDecoration(
                label: Text('Item Name'),
              ))),
      const SizedBox(height: 10),
      FractionallySizedBox(
          widthFactor: 0.7,
          //heightFactor: 0.2,
          child: TextField(
              controller: itemCostController,
              decoration: const InputDecoration(
                label: Text('Item Cost'),
              ))),
      const SizedBox(height: 10),
      FilledButton(onPressed: () {}, child: const Text('Save')),
    ]);
  }

  @override
  dispose() {
    itemNameController.dispose();
    itemCostController.dispose();
    super.dispose();
  }
}
