import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/services/expense/expense.services.dart';
import 'package:provider/provider.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({Key? key}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
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
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Center(
        child: Form(
          key: _formKey,
          child: PageView(
            children: [
              SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      AppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        // leading: const Icon(Icons.close),
                        title: const Text('Add Expense'),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // ---- (UI) add expense title ----

                      FractionallySizedBox(
                          // ---- (UI input) description ----
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

                      const SizedBox(
                          // ---- (ui, top margin of 10) ----
                          height: 10),

                      FractionallySizedBox(
                          // ---- (UI input) cost ----
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snakBar);
                              if (appState.groupAndExpenseInstances[
                                      appState.currentUserGroup] !=
                                  null) {
                                _expenseService
                                    .addExpense(
                                      description:
                                          _descriptionTextController.text,
                                      cost: _costTextController.text,
                                      currentUserName: appState.currentUserName,
                                      currentUserEmail:
                                          appState.currentUserEmail,
                                      currentUserGroup:
                                          appState.currentUserGroup,
                                      currentExpenseInstance:
                                          appState.currentExpenseInstance,
                                    )
                                    .whenComplete(() => Navigator.pop(context));
                              }
                            }
                          },
                          child: const Text('Save')),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
              ),
            ],
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
