import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/expenses/components/dashboard_component.dart';
import 'package:fraction/expenses/components/expense_component.dart';
import 'package:fraction/expenses/components/add_expense_component.dart';
import 'package:fraction/expenses/models/expense_model.dart';
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
  bool toggleAddExpense = false;

  late ExpenseRepo _expenseRepo;

  @override
  void initState() {
    // _expenseService = ExpenseService();
    _descriptionTextController = TextEditingController();
    _costTextController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _expenseRepo = Provider.of<ExpenseRepo>(context, listen: false);
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

  // final String _settingsIconPath = 'assets/icons/SettingsIcon.svg';
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                // leading: IconButton(
                //   icon: const Icon(Icons.navigate_before),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                // ),
                title: Text(
                    Tools()
                        .sliptElements(element: appState.currentUserGroup)[0],
                    style: const TextStyle(fontSize: 20)),

                // Group Info, navigation has been moved to dashboard component.
              ),
              // drawer: const FractionAppDrawer(),
              body: appState.hasOneGroup
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Dashboard(),
                            toggleAddExpense
                                ? Form(
                                    key: _formKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            AppBar(
                                              leading: IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () =>
                                                    Navigator.pop(context),
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
                                                        validateNotEmptyDesc(
                                                            value),
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: null,
                                                    controller:
                                                        _descriptionTextController,
                                                    decoration:
                                                        const InputDecoration(
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
                                                        validateNotEmptyCost(
                                                            value),
                                                    controller:
                                                        _costTextController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text('Item Cost'),
                                                    ))),
                                            const SizedBox(height: 10),

                                            // ---- (UI button) add expense ----
                                            FilledButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    const snakBar = SnackBar(
                                                        content: Text(
                                                            'adding expense ...'));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snakBar);
                                                    // if (appState.groupAndExpenseInstances[
                                                    //     appState.currentUserGroup] !=
                                                    // null) {
                                                    // _expenseService
                                                    // .addExpense(
                                                    //   description:
                                                    //       _descriptionTextController.text,
                                                    //   cost: _costTextController.text,
                                                    //   currentUserName: appState.currentUserName,
                                                    //   currentUserEmail:
                                                    //       appState.currentUserEmail,
                                                    //   currentUserGroup:
                                                    //       appState.currentUserGroup,
                                                    //   currentExpenseInstance:
                                                    //       appState.currentExpenseInstance,
                                                    // )

                                                    // .whenComplete(() => Navigator.pop(context));
                                                    // }

                                                    _expenseRepo
                                                        .addExpense(
                                                            description:
                                                                _descriptionTextController
                                                                    .text,
                                                            cost:
                                                                _costTextController
                                                                    .text)
                                                        .whenComplete(() =>
                                                            // Navigator.pop(context)
                                                            setState(() {
                                                              toggleAddExpense =
                                                                  !toggleAddExpense;
                                                            }));
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
                            ExpenseView(),
                            SizedBox(
                              height: 80,
                            )
                          ],
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('no group found _'),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/createGroup');
                            },
                            child: const Text('Tap here to create group')),
                      ],
                    ),
              floatingActionButton: appState.hasOneGroup
                  ? FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          toggleAddExpense = !toggleAddExpense;
                        });
                        // showAddExpenseDialog();
                        // Navigator.pushNamed(context, '/addExpense');
                      },
                    )
                  : Container(),
            ));
  }

  Future showAddExpenseDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return const Dialog.fullscreen(child: AddExpense());
        });
  }
}
