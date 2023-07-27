import 'package:flutter/material.dart';
import 'package:fraction/screens/expense/widget/account_pallet.dart';
import 'package:fraction/screens/expense/widget/expense_pallet.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../services/expense/expense.services.dart';
import '../../services/group/group.services.dart';
import 'package:intl/intl.dart';

class ViewExpenseLayout extends StatefulWidget {
  const ViewExpenseLayout({Key? key}) : super(key: key);

  @override
  createState() => ViewExpenseLayoutState();
}

class ViewExpenseLayoutState extends State<ViewExpenseLayout> {
  final List<int> colorCodes = <int>[600, 500, 100];
  String timeNow = '';

  Widget accountDetailWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Consumer<GroupServices>(
        builder: (context, groupServiceState, child) => StreamBuilder(
            stream: groupServiceState.getMemberDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: getRandomColor(),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AccountPallet(
                          streamSnapshot: snapshot, index: index);
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: (1 / .4)),
                  ),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseService>(builder: (context, expenseServiceState, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: StreamBuilder(
            stream: expenseServiceState.getExpenseCollection(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('Loading ...');
              }
              return SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                    accountDetailWidget(),
                    // Text(
                    //     DateFormat.MMMMEEEEd().format(
                    //         snapshot.data!.docs[0]['timeStamp'].toDate()),
                    //     style: const TextStyle(fontSize: 20)),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (timeNow !=
                              DateFormat.MMMMEEEEd()
                                  .format(snapshot
                                      .data!.docs[index]['timeStamp']
                                      .toDate())
                                  .toString()) {
                            timeNow = DateFormat.MMMMEEEEd()
                                .format(snapshot.data!.docs[index]['timeStamp']
                                    .toDate())
                                .toString();
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                        DateFormat.MMMMEEEEd().format(snapshot
                                            .data!.docs[index]['timeStamp']
                                            .toDate()),
                                        style: const TextStyle(fontSize: 20)),
                                  ],
                                ),
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: ExpensePallet(
                                      description: snapshot.data!.docs[index]
                                          ['description'],
                                      cost: snapshot.data!.docs[index]['cost'],
                                      currentUserEmail:
                                          expenseServiceState.currentUserEmail,
                                      currentUserName:
                                          expenseServiceState.currentUserName,
                                      memberEmail: snapshot.data!.docs[index]
                                          ['emailAddress'],
                                      time: snapshot.data!.docs[index]
                                          ['timeStamp']),
                                )
                              ],
                            );
                          }

                          return ExpensePallet(
                              description: snapshot.data!.docs[index]
                                  ['description'],
                              cost: snapshot.data!.docs[index]['cost'],
                              currentUserEmail:
                                  expenseServiceState.currentUserEmail,
                              currentUserName:
                                  expenseServiceState.currentUserName,
                              memberEmail: snapshot.data!.docs[index]
                                  ['emailAddress'],
                              time: snapshot.data!.docs[index]['timeStamp']);
                        }),
                    const SizedBox(
                      height: 70,
                    )
                  ]));
            }),
      );
    });
  }
}

final rng = Random();

// all colors with shade 100
const randomColors_shade100 = [
  Color(0xFFBBDEFB), // blue
  Color(0xFFC8E6C9), // green
  Color(0xFFB2DFDB), // teal
  Colors.red,
  Color(0xFFFFCCBC), // deepOrange
  Color(0xFFFFD180), // Orange
  Colors.indigo,
  Colors.deepPurple,
  Colors.white,
  Color(0xFFFFECB3), // amber
];

Color getRandomColor() {
  return randomColors_shade200[rng.nextInt(randomColors_shade200.length)];
}

const randomColors_shade200 = [
  //Color(0xFF80CBC4), // teal
  Color(0xFFA5D6A7), // green
  Color(0xFFFFE082), // amber
  Color(0xFFCE93D8), // purple
  Color(0xFF90CAF9), // blue
  Color(0xFFEF9A9A), // red
];
