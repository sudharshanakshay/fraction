import 'package:flutter/material.dart';
import 'package:fraction/expenses/components/dashboard_component.dart';
import 'package:fraction/expenses/components/expense_component.dart';
import 'package:fraction/expenses/models/expense_model.dart';
import 'package:fraction/groups/models/groups_model.dart';
import 'package:fraction/utils/tools.dart';
import 'package:provider/provider.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key, required this.title});

  final String title;

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  late TextEditingController _descriptionTextController;
  late TextEditingController _costTextController;
  late GlobalKey<FormState> _formKey;
  bool _showAddExpense = false;

  void toggleAddExpense() {
    setState(() {
      _descriptionTextController.clear();
      _costTextController.clear();
      _showAddExpense = !_showAddExpense;
    });
  }

  late ExpenseRepo? _expenseRepo;
  late GroupsRepo? _groupsRepo;

  @override
  void initState() {
    _descriptionTextController = TextEditingController();
    _costTextController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _expenseRepo = Provider.of<ExpenseRepo?>(context, listen: false);
    _groupsRepo = Provider.of<GroupsRepo?>(context, listen: false);
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
          title: Text(
              Tools().sliptElements(
                  element: _groupsRepo?.currentUserGroup ?? 'Fraction')[0],
              style: const TextStyle(fontSize: 20)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Dashboard(),
                _showAddExpense
                    ? Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                AppBar(
                                  leading: IconButton(
                                    icon: const Icon(Icons.arrow_drop_up),
                                    onPressed: () => toggleAddExpense(),
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
                                        validator: (value) =>
                                            validateNotEmptyDesc(value),
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
                                        validator: (value) =>
                                            validateNotEmptyCost(value),
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
                                        const snakBar = SnackBar(
                                            content:
                                                Text('adding expense ...'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snakBar);

                                        if (_expenseRepo != null) {
                                          _expenseRepo!
                                              .addExpense(
                                                  description:
                                                      _descriptionTextController
                                                          .text,
                                                  cost:
                                                      _costTextController.text)
                                              .whenComplete(
                                            () {
                                              toggleAddExpense();
                                            },
                                          );
                                        }
                                      }
                                    },
                                    child: const Text('Save')),
                                const SizedBox(
                                  height: 20,
                                ),
                              ]),
                        ),
                      )
                    : Container(),
                const ExpenseView(),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              _showAddExpense = !_showAddExpense;
            });
          },
        ));
  }
}
