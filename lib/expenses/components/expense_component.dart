import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/expenses/models/expense_model.dart';
import 'package:fraction/expenses/widgets/expense_tile.dart';
import 'package:fraction/expenses/widgets/expense_tile_shadow.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  // late ExpenseService _expenseService;
  late String _expenseTime;
  late String _today;

  @override
  void initState() {
    // _expenseService = ExpenseService();
    _expenseTime = '';
    _today = DateFormat.MMMMEEEEd().format(DateTime.now()).toString();
    super.initState();
  }

  TextStyle titleListTileStyle =
      TextStyle(fontSize: 20, color: Colors.grey.shade800);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      _expenseTime = '';
      return Consumer<ExpenseRepo?>(builder: (context, expenses, child) {
        if (expenses != null) {
          if (expenses.hasOneExpense && expenses.expenseList.isEmpty) {
            return const ExpenseListItemShadow();
          } else if (!expenses.hasOneExpense) {
            return const ListTile(
              title: Text('no expense to display _ '),
            );
          }

          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expenses.expenseList.length,
              // itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                if (_expenseTime !=
                    DateFormat.MMMMEEEEd()
                        .format(expenses.expenseList[index].timeStamp)
                        .toString()) {
                  _expenseTime = DateFormat.MMMMEEEEd()
                      .format(expenses.expenseList[index].timeStamp)
                      .toString();
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: _expenseTime == _today
                                ? Text(
                                    'Today, ${DateFormat.MMMMd().format(expenses.expenseList[index].timeStamp).toString()}',
                                    style: titleListTileStyle)
                                : Text(_expenseTime, style: titleListTileStyle),
                          ),
                        ],
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,

                        // --- Expense list Item ----
                        child: ExpenseListTile(
                          currentUserEmail: appState.currentUserEmail,
                          expenseDocId: expenses.expenseList[index].docId,
                          currentUserName: expenses.expenseList[index].userName,
                          appState: appState,
                          cost: expenses.expenseList[index].cost,
                          description: expenses.expenseList[index].description,
                          emailAddress:
                              expenses.expenseList[index].emailAddress,
                          tags: [],
                          timeStamp: expenses.expenseList[index].timeStamp,
                          expenseRepoState: expenses,
                        ),
                      )
                    ],
                  );
                }

                // --- Expense list Item ----
                return ExpenseListTile(
                  currentUserEmail: appState.currentUserEmail,
                  expenseDocId: expenses.expenseList[index].docId,
                  currentUserName: expenses.expenseList[index].userName,
                  expenseRepoState: expenses,
                  appState: appState,
                  cost: expenses.expenseList[index].cost,
                  description: expenses.expenseList[index].description,
                  emailAddress: expenses.expenseList[index].emailAddress,
                  tags: [],
                  timeStamp: expenses.expenseList[index].timeStamp,
                );
              });
        } else {
          return const Text(' data is null');
        }
      });
      // });
      // }
    });
  }
}
