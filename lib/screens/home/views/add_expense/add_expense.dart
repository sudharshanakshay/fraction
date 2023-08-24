import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/services/expense/expense.services.dart';
import 'package:provider/provider.dart';

class AddExpenseLayout extends StatefulWidget {
  const AddExpenseLayout({Key? key}) : super(key: key);

  @override
  State<AddExpenseLayout> createState() => _AddExpenseLayoutState();
}

class _AddExpenseLayoutState extends State<AddExpenseLayout> {
  late ExpenseService _expenseService;
  late TextEditingController _descriptionTextController;
  late TextEditingController _costTextController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _expenseService = ExpenseService();
    _descriptionTextController = TextEditingController();
    _costTextController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

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
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // ---- (UI input) description ----
                    FractionallySizedBox(
                        widthFactor: 0.7,
                        //heightFactor: 0.2,
                        child: TextFormField(
                            validator: (value) => validateNotEmptyDesc(value),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _descriptionTextController,
                            decoration: const InputDecoration(
                              label: Text('Item Name'),
                            ))),
                    const SizedBox(height: 10),

                    // ---- (UI input) cost ----
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

                    // ---- (UI button) add expense ----
                    FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            const snakBar =
                                SnackBar(content: Text('adding expense ...'));
                            ScaffoldMessenger.of(context).showSnackBar(snakBar);
                            if (appState.groupAndExpenseInstances[
                                    appState.currentUserGroup] !=
                                null) {
                              _expenseService
                                  .addExpense(
                                    description:
                                        _descriptionTextController.text,
                                    cost: _costTextController.text,
                                    currentUserName: appState.currentUserName,
                                    currentUserEmail: appState.currentUserEmail,
                                    currentUserGroup: appState.currentUserGroup,
                                    currentExpenseInstance:
                                        appState.currentExpenseInstance,
                                  )
                                  .whenComplete(() => Navigator.pop(context));
                            }
                          }
                        },
                        child: const Text('Save')),
                  ]),
            ),
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
