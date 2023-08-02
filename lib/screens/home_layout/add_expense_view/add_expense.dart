import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/expense/expense.services.dart';

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

  final _formKey = GlobalKey<FormState>();

  validateNotEmptyDesc(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  validateNotEmptyCost(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter cost';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Expense'),
      ),
      body: Consumer<ExpenseService>(
        builder: (context, expenseServiceState, _) => Center(
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  FractionallySizedBox(
                      widthFactor: 0.7,
                      //heightFactor: 0.2,
                      child: TextFormField(
                          validator: (value) => validateNotEmptyDesc(value),
                          controller: _descriptionTextController,
                          decoration: const InputDecoration(
                            label: Text('Item Name'),
                          ))),
                  const SizedBox(height: 10),
                  FractionallySizedBox(
                      widthFactor: 0.7,
                      //heightFactor: 0.2,
                      child: TextFormField(
                          validator: (value) => validateNotEmptyCost(value),
                          controller: _costTextController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('Item Cost'),
                          ))),
                  const SizedBox(height: 10),
                  FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          const snakBar =
                              SnackBar(content: Text('adding expense ...'));
                          ScaffoldMessenger.of(context).showSnackBar(snakBar);
                          expenseServiceState
                              .addExpense(
                                  description: _descriptionTextController.text,
                                  cost: _costTextController.text)
                              .whenComplete(() => Navigator.pop(context));
                        }
                      },
                      child: const Text('Save')),
                ]),
          ),
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
