import 'package:flutter/material.dart';
import 'package:fraction/screens/home_layout/expense_view/widget/expense_pallet.dart';
import 'package:fraction/services/expense/expense.services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<StatefulWidget> createState() => ExpenseViewState();
}

class ExpenseViewState extends State<ExpenseView> {
  String timeNow = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseService>(builder: (context, expenseServiceState, _) {
      return StreamBuilder(
          stream: expenseServiceState.getExpenseCollection(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('Loading ...');
            }
            // if (snapshot.hasError) {}
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  if (timeNow !=
                      DateFormat.MMMMEEEEd()
                          .format(
                              snapshot.data!.docs[index]['timeStamp'].toDate())
                          .toString()) {
                    timeNow = DateFormat.MMMMEEEEd()
                        .format(
                            snapshot.data!.docs[index]['timeStamp'].toDate())
                        .toString();
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
                            currentUserEmail:
                                expenseServiceState.currentUserEmail,
                            currentUserName: snapshot.data!.docs[index]
                                ['userName'],
                            expenseServiceState: expenseServiceState,
                            expenseDoc: snapshot.data!.docs[index],
                          ),
                        )
                      ],
                    );
                  }

                  return ExpensePallet(
                    currentUserEmail: expenseServiceState.currentUserEmail,
                    currentUserName: snapshot.data!.docs[index]['userName'],
                    expenseServiceState: expenseServiceState,
                    expenseDoc: snapshot.data!.docs[index],
                  );
                });
          });
    });
  }
}
