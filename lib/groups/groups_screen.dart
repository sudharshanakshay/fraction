import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/expenses/models/dashboard_model.dart';
import 'package:fraction/expenses/models/expense_model.dart';
import 'package:fraction/group_info/models/group_info_model.dart';
import 'package:fraction/groups/components/create_group.screen.dart';
import 'package:fraction/drawer/app_drawer.dart';
import 'package:fraction/expenses/expenses_screen.dart';
import 'package:fraction/groups/models/groups_models.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  TextStyle titleListTileStyle =
      TextStyle(fontSize: 16, color: Colors.grey.shade800);

  TextStyle subListTileStyle =
      TextStyle(fontSize: 12, color: Colors.grey.shade600);

  TextStyle trailingListTileStyle =
      TextStyle(fontSize: 12, color: Colors.grey.shade600);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            // kDebugMode
            //     ? IconButton(
            //         onPressed: () {

            //         },
            //         icon: const Icon(Icons.chat))
            //     : Container(),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/notification');
                },
                icon: const Icon(Icons.notifications_active_outlined)),
          ],
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ---- (ui, home screen, expense grouplist) ----
              Consumer<GroupsRepo>(
                builder: (context, groupsRepoState, child) => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groupsRepoState.expenseGroupList.length,
                  itemBuilder: (context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 4.0),
                      child: ListTile(
                        title: Text(
                          groupsRepoState.expenseGroupList[index].groupName,
                          style: titleListTileStyle,
                        ),
                        subtitle: Text(
                            groupsRepoState
                                .expenseGroupList[index].lastUpdatedDesc,
                            style: subListTileStyle),
                        trailing: Text(
                            DateFormat.yMd()
                                .format(groupsRepoState
                                    .expenseGroupList[index].lastUpdatedTime)
                                .toString(),
                            style: trailingListTileStyle),
                        onTap: () {
                          appState.setCurrentUserGroup(
                              currentUserGroup: groupsRepoState
                                  .expenseGroupList[index].groupId);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                        create: (_) => ExpenseRepo(
                                            appState: appState,
                                            groupsRepoState: groupsRepoState),
                                      ),
                                      ChangeNotifierProvider(
                                          create: (_) => DashboardRepo(
                                              appState: appState)),
                                      ChangeNotifierProvider(
                                          create: (_) =>
                                              GroupInfoRepo(appState: appState))
                                    ],
                                    builder: (context, child) =>
                                        const ExpenseScreen(title: 'Fraction')),
                              ));
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 80,
              )
            ],
          ),
        ),
        // ---- (ui, home screen, create new expense group ) ----
        floatingActionButton: appState.hasOneGroup
            ? FloatingActionButton(
                child: const Icon(Icons.chat_bubble),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateGroupScreen()));
                },
              )
            : Container(),
      ),
    );
  }
}
