import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/presentation/screens/create_group/create_group.screen.dart';
import 'package:fraction/presentation/screens/drawer/app_drawer.dart';
import 'package:fraction/presentation/screens/home/expense_group/expense_group.screen.dart';
import 'package:fraction/services/user/user.services.dart';
import 'package:fraction/utils/tools.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserServices _userServices;

  @override
  void initState() {
    _userServices = UserServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/notification');
                },
                icon: const Icon(Icons.notifications_active_outlined)),
          ],
        ),
        drawer: const AppDrawer(),
        body: StreamBuilder(
            stream: _userServices.groupStream(
                currentUserEmail: appState.currentUserEmail),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapShot.data.length,
                  itemBuilder: (context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 4.0),
                      // color: AppColors().groupListTileColor,
                      child: ListTile(
                        title: Text(Tools()
                            .sliptElements(element: snapShot.data[index])[0]),
                        onTap: () {
                          appState.setCurrentUserGroup(
                              currentUserGroup: snapShot.data[index]);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ExpenseGroup(title: 'Fraction')));
                        },
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            }),
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
