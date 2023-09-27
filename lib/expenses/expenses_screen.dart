import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/expenses/components/dashboard_component.dart';
import 'package:fraction/expenses/components/expense_component.dart';
import 'package:fraction/expenses/components/add_expense_component.dart';
import 'package:fraction/utils/tools.dart';
import 'package:provider/provider.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key, required this.title});

  final String title;

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  // final String _settingsIconPath = 'assets/icons/SettingsIcon.svg';
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // leading: IconButton(
          //   icon: const Icon(Icons.navigate_before),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          title: Text(
              Tools().sliptElements(element: appState.currentUserGroup)[0],
              style: const TextStyle(fontSize: 20)),

          // Group Info, navigation has been moved to dashboard component.
        ),
        // drawer: const FractionAppDrawer(),
        body: appState.hasOneGroup
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Dashboard(),
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
                  showAddExpenseDialog();
                  // Navigator.pushNamed(context, '/addExpense');
                },
              )
            : Container(),
      );
    });
  }

  Future showAddExpenseDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Dialog.fullscreen(child: AddExpense());
        });
  }
}
