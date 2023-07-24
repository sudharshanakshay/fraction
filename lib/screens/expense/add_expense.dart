import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Expense'),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Center(
          child: Column(children: <Widget>[
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
                onPressed: () async {
                  const snakBar = SnackBar(content: Text('adding expense ...'));
                  ScaffoldMessenger.of(context).showSnackBar(snakBar);
                  addExpense(
                          description: _descriptionTextController.text,
                          cost: _costTextController.text)
                      .whenComplete(() => Navigator.pop(context));
                },
                child: const Text('Save')),
          ]),
        ),
      ),
    );
  }

  @override
  dispose() {
    _descriptionTextController.dispose();
    _costTextController.dispose();
    super.dispose();
  }
}
