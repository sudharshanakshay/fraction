import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/services/expense/expense.services.dart';
import 'package:fraction/services/fraction_services.dart';
import 'package:fraction/services/group/group.services.dart';
import 'package:fraction/services/profile/profile.services.dart';
import 'package:fraction/utils/tools.dart';
import 'package:fraction/widgets/custom_input_form_field.dart';
import 'package:fraction/widgets/widgets.dart';
import 'package:provider/provider.dart';

class FractionAppDrawer extends StatefulWidget {
  const FractionAppDrawer({super.key});

  @override
  State<StatefulWidget> createState() => FractionAppDrawerState();
}

class FractionAppDrawerState extends State<FractionAppDrawer> {
  late ExpenseService _expenseService;

  @override
  void initState() {
    // TODO: implement initState
    _expenseService = Provider.of<ExpenseService>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final newGroupNameController = TextEditingController();
    return Consumer<ApplicationState>(
      builder: (context, appState, child) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<Map<String, dynamic>>(
                  stream: getProfileDetailsFromCloud(
                      currentUserEmail: appState.currentUserEmail),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DrawerHeader(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text('Profile'),
                            const Divider(),
                            Text(appState.currentUserName),
                            Text(appState.currentUserEmail),
                            Text(snapshot.data?['userName'].toString() ?? ''),
                            Text(snapshot.data?['emailAddress'].toString() ??
                                ''),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              StreamBuilder(
                  stream: availableProfileGroupsStream(
                      currentUserEmail: appState.currentUserEmail),
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapShot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(Tools().sliptElements(
                                element: snapShot.data[index])[0]),
                            onTap: () {
                              _expenseService.setcurrentUserGroup(
                                  currentUserGroup: snapShot.data[index]);
                              // appState.setcurrentUserGroup(
                              //     currentUserGroup: snapShot.data[index]);
                              // appState.setCurrentGroupName(
                              // currentGroupName: snapShot.data[index]);
                            },
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  }),
              FilledButton(
                  onPressed: () {
                    // print(appState.currentUserGroup);
                  },
                  child: const Text('get one group name')),
              FilledButton(
                  onPressed: () {
                    Scaffold.of(context)
                        .showBottomSheet<void>((BuildContext context) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text('Create new group'),
                                  CustomInputFormField(
                                      controller: newGroupNameController,
                                      label: 'Group name'),
                                  FilledButton(
                                      onPressed: () {
                                        GroupServices().createCloudGroup(
                                            inputGroupName:
                                                newGroupNameController.text);
                                      },
                                      child: const DetailAndIcon(
                                          Icons.navigate_next, "Next")),
                                ],
                              ),
                            ));
                  },
                  child: const Text('create group'))
            ],
          ),
        ),
      ),
    );
  }
}
