import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/widgets/account_pallet.dart';
import 'package:fraction/widgets/expense_pallet.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/expense/expense.services.dart';
import '../../services/profile/profile.services.dart';
import 'create_group/create_group.dart';

class ViewExpenseLayout extends StatefulWidget {
  const ViewExpenseLayout({Key? key}) : super(key: key);

  @override
  createState() => ViewExpenseLayoutState();
}

class ViewExpenseLayoutState extends State<ViewExpenseLayout> {
  final List<int> colorCodes = <int>[600, 500, 100];

  Widget accountDetailWidget({required currentUserEmail}) {
    return StreamBuilder(
        // stream: null,
        stream: getGroupAccountDetails(currentUserEmail: currentUserEmail),
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
                    itemCount: snapshot.data?['groupMembers'].length,
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => StreamBuilder(
        stream: getGroupNamesFromProfile(appState.currentUserEmail),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('printing snapshot ${snapshot.data}');
            return const CreateGroup();
          } else {
            return StreamBuilder(
                // stream: FirebaseFirestore.instance
                //     .collection('expense')
                //     .snapshots(),
                stream: getExpenseCollectionFromCloud(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    // print(snapshot.hasData);
                    return const Center(child: Text('Loading ...'));
                  }
                  return SingleChildScrollView(
                      child: Column(children: <Widget>[
                    accountDetailWidget(
                        currentUserEmail: appState.currentUserEmail),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ExpensePallet(
                              streamSnapshot: snapshot, index: index);
                          // return Padding(
                          //     padding: const EdgeInsets.all(8),
                          //     child: Container(
                          //       padding: const EdgeInsets.all(4),
                          //       decoration: BoxDecoration(
                          //         border: Border.all(
                          //           //eft: BorderSide(
                          //           width: 2,
                          //           // color: getRandomColor(),
                          //           color: Colors.blue.shade100,
                          //           //)
                          //         ),
                          //         borderRadius: BorderRadius.circular(12),
                          //       ),
                          //       //height: 50,
                          //       //color: Colors.amber[colorCodes[index % 3]],
                          //       child: ListTile(
                          //         leading: const Icon(Icons.person),
                          //         title: Text(
                          //             '${snapshot.data?.docs[index]['description']}'),
                          //         //isThreeLine: true,
                          //         subtitle: Row(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: <Widget>[
                          //             Text(snapshot.data?.docs[index]
                          //                 ['userName']),
                          //             const Text(','),
                          //             const Flexible(
                          //               child: FractionallySizedBox(
                          //                 widthFactor: 0.01,
                          //               ),
                          //             ),
                          //             Text(DateFormat.yMMMd().format(snapshot
                          //                 .data?.docs[index]['timeStamp']
                          //                 .toDate())),
                          //           ],
                          //         ),

                          //         trailing: Text(
                          //           '${snapshot.data?.docs[index]['cost']}/-',
                          //           style: const TextStyle(fontSize: 20),
                          //         ),
                          //       ),
                          //     ));
                        })
                  ]));
                });
          }
        },
      ),
    );
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
