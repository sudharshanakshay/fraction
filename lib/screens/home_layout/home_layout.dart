import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/devilCode.dart';
import 'package:fraction/screens/create_group_layout/create_group.dart';
import 'package:fraction/screens/home_layout/dashboard_view/dashboard.component.dart';
import 'package:fraction/screens/home_layout/expense_view/expense_view.component.dart';
import 'package:provider/provider.dart';

import 'drawer_view/app_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final String _settingsIconPath = 'assets/icons/SettingsIcon.svg';
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            kDebugMode
                ? IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(Icons.logout))
                : Container(),
            kDebugMode
                ? IconButton(
                    onPressed: () {
                      appState
                          .setGroupAndExpenseInstances()
                          .whenComplete(() => appState.printGroupMap());
                    },
                    icon: const Icon(Icons.print))
                : Container(),
            kDebugMode
                ? IconButton(
                    onPressed: () {
                      DevilCode()
                          .callDevil1(shouldCallExpenseToGroupExpense: true);
                    },
                    icon: const Icon(Icons.refresh))
                : Container(),
            IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print('');
                }
                Navigator.pushNamed(context, '/groupInfo');
              },
              // icon: SvgPicture.asset(_settingsIconPath),
              icon: const Icon(Icons.navigate_next),
            ),
            const SizedBox(
              width: 8.0,
            )
          ],
        ),
        drawer: const FractionAppDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: appState.hasGroup
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Dashboard(context: context),
                      const ExpenseView(),
                      const SizedBox(
                        height: 70,
                      )
                    ],
                  )
                : const CreateGroupLayout(),
          ),
        ),
        floatingActionButton: appState.hasGroup
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, '/addExpense');
                },
              )
            : Container(),
      ),
    );
  }
}
