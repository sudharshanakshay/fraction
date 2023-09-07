import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/data/api/chats/chat.api.dart';
import 'package:fraction/groups/components/create_group.screen.dart';
import 'package:fraction/drawer/app_drawer.dart';
import 'package:fraction/expenses/expenses_screen.dart';
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
            //           ChatApi().initChatCollection(
            //               currentUserEmail: appState.currentUserEmail);
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
              StreamBuilder(
                  stream: ChatApi().getChatsCollection(
                      currentUserEmail: appState.currentUserEmail),
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      print('----printing snapshot data----');
                      print(snapShot.data!.docs[0].data());
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapShot.data!.docs.length,
                        itemBuilder: (context, int index) {
                          final chat = snapShot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          return Container(
                            margin: const EdgeInsets.only(top: 4.0),
                            // color: AppColors().groupListTileColor,
                            child: ListTile(
                              title: Text(
                                chat['groupName'],
                                style: titleListTileStyle,
                              ),
                              subtitle: Text(chat['lastExpenseDesc'],
                                  style: subListTileStyle),
                              trailing: Text(
                                  DateFormat.yMd()
                                      .format(chat['lastExpenseTime'].toDate())
                                      .toString(),
                                  style: trailingListTileStyle),
                              onTap: () {
                                appState.setCurrentUserGroup(
                                    currentUserGroup:
                                        snapShot.data!.docs[index].id);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ExpenseGroup(
                                                title: 'Fraction')));
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  }),
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
