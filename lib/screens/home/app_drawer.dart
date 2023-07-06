import 'package:flutter/material.dart';
import 'package:fraction/group_state.dart';
import 'package:provider/provider.dart';

class FractionAppDrawer extends StatefulWidget {
  const FractionAppDrawer({super.key});

  @override
  State<StatefulWidget> createState() => FractionAppDrawerState();
}

class FractionAppDrawerState extends State<FractionAppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, groupState, _) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const DrawerHeader(child: Text('Profile info')),
              // ListView.builder(
              //   itemBuilder: (BuildContext context, int index) {
              //     return ListTile(
              //       title: const Text('Item 1'),
              //       onTap: () {
              //         // Update the state of the app.
              //         // ...
              //       },
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
