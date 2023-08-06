import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/screens/home_layout/dashboard_view/dashboard.component.dart';
import 'package:fraction/screens/home_layout/drawer_view/app_drawer.dart';
import 'package:fraction/screens/home_layout/expense_view/expense_view.component.dart';
import 'package:fraction/services/group/group.services.dart';
import 'package:provider/provider.dart';

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
    return Consumer<GroupServices>(
      builder: (context, groupServiceState, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/notification');
                  },
                  icon: const Icon(Icons.notifications_active_outlined)),
              kDebugMode
                  ? IconButton(
                      onPressed: () {
                        groupServiceState.signOut();
                      },
                      icon: const Icon(Icons.logout))
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Dashboard(context: context),
                  const ExpenseView(),
                  const SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addExpense');
            },
          )),
    );
  }
}
