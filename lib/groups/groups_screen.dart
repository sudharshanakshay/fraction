import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/expenses/models/dashboard_model.dart';
import 'package:fraction/expenses/models/expense_model.dart';
import 'package:fraction/groups/components/create_group.screen.dart';
import 'package:fraction/drawer/app_drawer.dart';
import 'package:fraction/expenses/expenses_screen.dart';
import 'package:fraction/groups/models/groups_model.dart';
import 'package:fraction/notification/models/notification.dart';
import 'package:fraction/notification/notification_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final String profileIconPath = 'assets/icons/profileIcon.svg';
  final String settingsIconPath = 'assets/icons/SettingsIcon.svg';

  @override
  void initState() {
    super.initState();
  }

  static int buildTimes = 1;

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
          // leading: IconButton(
          // icon: const Icon(Icons.),
          // icon: SvgPicture.asset('settingsIconPath'),
          // onPressed: () {
          // Navigator.pushNamed(context, '/settings');
          // },
          // ),
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            Consumer<GroupsRepo>(
              builder: (context, groupsRepoState, child) => IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(
                                value: groupsRepoState),
                            ChangeNotifierProxyProvider<ApplicationState,
                                NotificationRepo?>(
                              create: (context) {
                                return NotificationRepo();
                              },
                              update:
                                  (context, value, NotificationRepo? previous) {
                                return previous
                                  ?..update(
                                      newCurrentUserEmail:
                                          value.currentUserEmail);
                              },
                            ),
                          ],
                          child: const NotificationScreen(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_active_outlined)),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ---- (ui, home screen, expense grouplist) ----
              Consumer<GroupsRepo?>(
                builder: (context, groupsRepoState, child) {
                  if (kDebugMode) {
                    print('buildTimes++');
                    print(buildTimes++);
                  }

                  if (groupsRepoState != null) {
                    return ListView.builder(
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
                              style: subListTileStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                                DateFormat("MMM, d")
                                    .format(groupsRepoState
                                        .expenseGroupList[index]
                                        .lastUpdatedTime)
                                    .toString(),
                                style: trailingListTileStyle),
                            onTap: () {
                              groupsRepoState.currentUserGroup = groupsRepoState
                                  .expenseGroupList[index].groupId;

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider.value(
                                            value: groupsRepoState,
                                          ),
                                          ChangeNotifierProxyProvider<
                                              ApplicationState, ExpenseRepo?>(
                                            lazy: false,
                                            create: (_) => ExpenseRepo(),
                                            update: (context, appState,
                                                    expenseRepo) =>
                                                expenseRepo
                                                  ?..update(
                                                      newAppState: appState,
                                                      newGroupsRepoState:
                                                          groupsRepoState),
                                          ),
                                          ChangeNotifierProxyProvider<
                                              GroupsRepo, DashboardRepo?>(
                                            create: (_) => DashboardRepo(),
                                            update: (context,
                                                    newGroupsRepoState,
                                                    dashboardRepoState) =>
                                                dashboardRepoState
                                                  ?..update(
                                                      newGroupsRepoState:
                                                          newGroupsRepoState),
                                          ),
                                        ],
                                        builder: (context, child) =>
                                            const ExpenseScreen(
                                                title: 'Fraction')),
                                  ));
                            },
                          ),
                        );
                      },
                    );
                  }
                  return const Text('data is null');
                },
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
