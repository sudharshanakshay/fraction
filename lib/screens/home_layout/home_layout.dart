import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/screens/home_layout/dashboard_view/dashboard.component.dart';
import 'package:fraction/screens/home_layout/drawer_view/app_drawer.dart';
import 'package:fraction/screens/home_layout/expense_view/expense_view.component.dart';
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
    return Consumer<ApplicationState>(builder: (context, appState, child) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/notification');
                  },
                  icon: const Icon(Icons.notifications_active_outlined)),
              IconButton(
                onPressed: () {
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
          body: appState.hasOneGroup
              ? const SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Dashboard(),
                        ExpenseView(),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Row(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('no group found _'),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/createGroup');
                        },
                        child: const Text('Tap here to create group')),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addExpense');
            },
          ));
    });
  }
}
