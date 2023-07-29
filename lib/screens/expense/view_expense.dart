import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fraction/screens/expense/widget/expense_pallet.dart';
import 'package:fraction/services/group/group.services.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../services/expense/expense.services.dart';
import 'package:intl/intl.dart';

class ViewExpenseLayout extends StatefulWidget {
  const ViewExpenseLayout({Key? key}) : super(key: key);

  @override
  createState() => ViewExpenseLayoutState();
}

class ViewExpenseLayoutState extends State<ViewExpenseLayout> {
  final List<int> colorCodes = <int>[600, 500, 100];
  final String moreMembersIcon = 'assets/icons/moreMembersIcon.svg';
  String timeNow = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Consumer<GroupServices>(
              builder: (context, groupServiceState, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: StreamBuilder(
                      stream: groupServiceState.getGroupDetials(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.blue.shade100,
                                ),
                                borderRadius: BorderRadius.circular(6)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StreamBuilder(
                                        stream: groupServiceState
                                            .getMyTotalExpense(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              left: BorderSide(
                                                                  width: 1.0,
                                                                  color: Colors
                                                                      .black))),
                                                  child: const Text(
                                                      'My Expense: ',
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                ),
                                                Text(snapshot.data.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16))
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                    Column(
                                      children: [
                                        const Text('Next clear off',
                                            style: TextStyle(fontSize: 12)),
                                        Text(
                                            DateFormat.MMMd().format(snapshot
                                                .data['nextClearOffTimeStamp']
                                                .toDate()),
                                            style:
                                                const TextStyle(fontSize: 16))
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: SvgPicture.asset(moreMembersIcon),
                                      onPressed: () async {
                                        final someValue =
                                            await groupServiceState
                                                .getMemberDetails();
                                        // for (var element in someValue!) {

                                        // }
                                        await showMemberDetails(
                                            memberDetailList: someValue);
                                      },
                                    ),
                                    Text(
                                        snapshot.data['totalExpense']
                                            .toString(),
                                        style: const TextStyle(fontSize: 12))
                                  ],
                                )
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                );
              },
            ),
            Consumer<ExpenseService>(
                builder: (context, expenseServiceState, _) {
              return StreamBuilder(
                  stream: expenseServiceState.getExpenseCollection(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Loading ...');
                    }
                    return ListView.builder(
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
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
                            currentUserEmail:
                                expenseServiceState.currentUserEmail,
                            currentUserName: snapshot.data!.docs[index]
                                ['userName'],
                            expenseServiceState: expenseServiceState,
                            expenseDoc: snapshot.data!.docs[index],
                          );
                        });
                  });
            }),
            const SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  Future<String?> showMemberDetails({required memberDetailList}) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              content: SizedBox(
                height: 400,
                width: 400,
                child: ListView.builder(
                    itemCount: memberDetailList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                            width: 2,
                            color: Colors.blue.shade100,
                          )),
                          // borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title:
                              Text('${memberDetailList[index]['memberName']}'),
                          subtitle: Text(
                            '${memberDetailList[index]['totalExpense']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    }),
              ));
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
