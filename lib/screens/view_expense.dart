import 'package:flutter/material.dart';
import 'dart:math';

/// Flutter code sample for [BottomNavigationBar].

// void main() => runApp(const BottomNavigationBarExampleApp());

// class BottomNavigationBarExampleApp extends StatelessWidget {
//   const BottomNavigationBarExampleApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: BottomNavigationBarExample(),
//     );
//   }
// }

// class BottomNavigationBarExample extends StatefulWidget {
//   const BottomNavigationBarExample({super.key});

//   @override
//   State<BottomNavigationBarExample> createState() =>
//       _BottomNavigationBarExampleState();
// }

// class _BottomNavigationBarExampleState
//     extends State<BottomNavigationBarExample> {
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static const List<Widget> _widgetOptions = <Widget>[
//     ViewExpenseLayout(),
//     AddExpenseLayout(),
//     Profile(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('BottomNavigationBar Sample'),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.menu_rounded),
//             label: 'Expense',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add),
//             label: 'Add Expense',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline_rounded),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

class ViewExpenseLayout extends StatefulWidget {
  const ViewExpenseLayout({Key? key}) : super(key: key);

  @override
  createState() => ViewExpenseLayoutState();
}

class ViewExpenseLayoutState extends State<ViewExpenseLayout> {
  final List<Map<dynamic, dynamic>> entries = [
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
    {'item_desc': 'name_1', 'item_cost': 'cost_1', 'time_stamp': '2023-06-01'},
  ];

  //final List<String> entries = <String>['A', 'B', 'C'];
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
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      abcWidget(),
      ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      //eft: BorderSide(
                      width: 2,
                      color: getRandomColor(),
                      //)
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 50,
                  //color: Colors.amber[colorCodes[index % 3]],
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Flexible(
                            child: FractionallySizedBox(widthFactor: 0.01)),
                        Center(child: Text('${entries[index]['item_desc']}')),
                        Center(child: Text('${entries[index]['item_cost']}')),
                        Center(child: Text('${entries[index]['time_stamp']}')),
                        const Flexible(
                            child: FractionallySizedBox(widthFactor: 0.01)),
                      ]),
                ));
          })
    ]));
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
