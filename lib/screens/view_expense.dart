import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/services/app_state.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'create_group.dart';

class ViewExpenseLayout extends StatefulWidget {
  const ViewExpenseLayout({Key? key}) : super(key: key);

  @override
  createState() => ViewExpenseLayoutState();
}

class ViewExpenseLayoutState extends State<ViewExpenseLayout> {
  List<Map<String, dynamic>> expenses = [
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'description': 'name_1', 'cost': 'cost_1', 'time_stamp': '2023-06-01'},
  ];

  //final List<String> expenses = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  Widget abcWidget() {
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

          height: 100,
          //color: Colors.amber[colorCodes[index % 3]],
          child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Flexible(child: FractionallySizedBox(widthFactor: 0.01)),
                const Flexible(child: FractionallySizedBox(widthFactor: 0.01)),
              ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => appState.groupIds.isEmpty ? const CreateGroup() :
       StreamBuilder(
          stream: FirebaseFirestore.instance.collection('expense').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading ...'));
            }
            return SingleChildScrollView(
                child: Column(children: <Widget>[
              abcWidget(),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              //eft: BorderSide(
                              width: 2,
                              color: getRandomColor(),
                              //)
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          //height: 50,
                          //color: Colors.amber[colorCodes[index % 3]],
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(
                                '${snapshot.data?.docs[index]['description']}'),
                            //isThreeLine: true,
                            subtitle: Text(DateFormat.yMMMd().format(snapshot
                                .data?.docs[index]['time_stamp']
                                .toDate())),
    
                            trailing: Text(
                              '${snapshot.data?.docs[index]['cost']}/-',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ));
                  })
            ]));
          }),
    );
    //});
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
