import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/presentation/screens/home/expense_group/view_expense/widget/expense_list_tile.dart';
import 'package:fraction/presentation/screens/home/expense_group/view_expense/widget/expense_list_tile_shadow.dart';
import 'package:fraction/services/expense/expense.services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  late ExpenseService _expenseService;
  late String _expenseTime;
  late String _today;

  @override
  void initState() {
    _expenseService = ExpenseService();
    _expenseTime = '';
    _today = DateFormat.MMMMEEEEd().format(DateTime.now()).toString();

    super.initState();
  }

  TextStyle titleListTileStyle =
      TextStyle(fontSize: 20, color: Colors.grey.shade800);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      if (appState.groupAndExpenseInstances[appState.currentUserGroup] ==
          null) {
        // ---- time to initialize expense group instances ----
        // return const Text('fetching data _');
        return const ExpenseListItemShadow();
      } else {
        // ---- once the initialize of expense group instances is done ----

        return StreamBuilder(
            stream: _expenseService.getExpenseCollection(
                currentUserGroup: appState.currentUserGroup,
                currentExpenseInstance: appState.currentExpenseInstance),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const ExpenseListItemShadow();
              } else if (snapshot.data!.docs.isEmpty) {
                return const ListTile(
                  title: Text('no expense to display _ '),
                );
              }
              _expenseTime = '';
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_expenseTime !=
                        DateFormat.MMMMEEEEd()
                            .format(snapshot.data!.docs[index]['timeStamp']
                                .toDate())
                            .toString()) {
                      _expenseTime = DateFormat.MMMMEEEEd()
                          .format(
                              snapshot.data!.docs[index]['timeStamp'].toDate())
                          .toString();
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: _expenseTime == _today
                                    ? Text(
                                        'Today, ${DateFormat.MMMMd().format(snapshot.data!.docs[index]['timeStamp'].toDate()).toString()}',
                                        style: titleListTileStyle)
                                    : Text(_expenseTime,
                                        style: titleListTileStyle),
                              ),
                            ],
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,

                            // --- Expense list Item ----
                            child: ExpenseListTile(
                              currentUserEmail: appState.currentUserEmail,
                              currentUserName: snapshot.data!.docs[index]
                                  ['userName'],
                              expenseServiceState: _expenseService,
                              expenseDoc: snapshot.data!.docs[index],
                              appState: appState,
                            ),
                          )
                        ],
                      );
                    }

                    // --- Expense list Item ----
                    return ExpenseListTile(
                      currentUserEmail: appState.currentUserEmail,
                      currentUserName: snapshot.data!.docs[index]['userName'],
                      expenseServiceState: _expenseService,
                      expenseDoc: snapshot.data!.docs[index],
                      appState: appState,
                    );
                  });
            });
      }
    });
  }
}
