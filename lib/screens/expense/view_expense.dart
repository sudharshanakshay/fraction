import 'package:flutter/material.dart';
import 'package:fraction/screens/expense/widget/account_pallet.dart';
import 'package:fraction/screens/expense/widget/expense_pallet.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../services/expense/expense.services.dart';
import '../../services/group/group.services.dart';

class ViewExpenseLayout extends StatefulWidget {
  const ViewExpenseLayout({Key? key}) : super(key: key);

  @override
  createState() => ViewExpenseLayoutState();
}

class ViewExpenseLayoutState extends State<ViewExpenseLayout> {
  String _currentUserGroupState = '';

  // late ExpenseService _expenseProvider;

  @override
  void initState() {
    // _currentUserGroupState =  pref.getString('currentUserGroup')!;
    // _expenseProvider = Provider.of<ExpenseService>(context, listen: true);
    super.initState();
  }

  final List<int> colorCodes = <int>[600, 500, 100];

  Widget accountDetailWidget({required currentUserEmail}) {
    return Consumer<GroupServices>(
      builder: (context, groupServiceState, child) => StreamBuilder(
          stream: groupServiceState.getGroupAccountDetails(
              currentUserEmail: currentUserEmail),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
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
                  ));
            } else {
              return Container();
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseService>(builder: (context, expenseServiceState, _) {
      print('viewExpense State $_currentUserGroupState');

      print('viewExpense State $_currentUserGroupState');
      return StreamBuilder(
          stream: expenseServiceState.getExpenseCollection(
              // currentUserGroup: expenseServiceState.currentUserGroup
              ),
          // stream: getExpenseCollection(),
          builder: (context, snapshot) {
            // print(snapshot.data);
            if (!snapshot.hasData) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   setState(() {
              //     _currentUserGroupState = expenseServiceState.currentUserGroup;
              //   });
              // }
              return const Text('Loading ...');
            }
            return SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                  accountDetailWidget(
                      currentUserEmail: expenseServiceState.currentUserEmail),
                  Text(expenseServiceState.currentUserName),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ExpensePallet(
                            streamSnapshot: snapshot, index: index);
                      }),
                  const SizedBox(
                    height: 70,
                  )
                ]));
          });
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
