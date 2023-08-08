import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/screens/home_layout/expense_view/widget/expense_pallet.dart';
import 'package:fraction/services/expense/expense.services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  String timeNow = '';
  late ExpenseService _expenseService;

  @override
  void initState() {
    _expenseService = ExpenseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      if (kDebugMode) {
        print('build expense view');
      }
      if (appState.groupAndExpenseInstances[appState.currentUserGroup] ==
          null) {
        if (kDebugMode) {
          print('instance null if-1');
        }
        // ---- time to initialize expense group instances ----
        return const Text('loading now _');
      } else {
        if (kDebugMode) {
          print('return streamBuilder for expense view');
        }
        // ---- once the initialize of expense group instances is done ----
        return StreamBuilder(
            stream: _expenseService.getExpenseCollection(
                currentUserGroup: appState.currentUserGroup,
                currentExpenseInstance: appState.currentExpenseInstance),
            builder: (context, snapshot) {
              if (kDebugMode) {
                print('inside stream builder');
              }
              if (!snapshot.hasData) {
                return const Column(
                  children: [
                    Icon(Icons.refresh_outlined),
                    Text('loading now _')
                  ],
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return const ListTile(
                  title: Text('no expense to display _ '),
                );
              }
              // print(snapshot.data!.docs[0]);
              if (kDebugMode) {
                print('1');
              }
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (timeNow != snapshot.data!.docs[index]['timeStamp']) {
                      timeNow =
                          snapshot.data!.docs[index]['timeStamp'].toString();
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                    DateFormat.MMMMEEEEd().format(snapshot
                                        .data!.docs[index]['timeStamp']
                                        .toDate()),
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ],
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: ExpensePallet(
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

                    return ExpensePallet(
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
