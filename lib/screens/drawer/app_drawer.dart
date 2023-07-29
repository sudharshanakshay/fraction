import 'package:flutter/material.dart';
import 'package:fraction/services/expense/expense.services.dart';
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
  late GroupServices _groupService;

  @override
  void initState() {
    _expenseService = Provider.of<ExpenseService>(context, listen: false);
    _groupService = Provider.of<GroupServices>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final newGroupNameController = TextEditingController();
    return Consumer<ProfileServices>(
      builder: (context, profileState, child) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Profile'),
                    const Divider(),
                    Text(profileState.currentUserName),
                    Text(profileState.currentUserEmail),
                  ],
                ),
              ),
              StreamBuilder(
                  stream: profileState.myGroupsStream(),
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
                              _groupService.setcurrentUserGroup(
                                  currentUserGroup: snapShot.data[index]);
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
                                  Consumer<GroupServices>(
                                    builder: (context, groupServiceState, _) {
                                      return FilledButton(
                                          onPressed: () {
                                            print(groupServiceState
                                                .currentUserEmail);
                                            groupServiceState.createGroup(
                                                inputGroupName:
                                                    newGroupNameController.text,
                                                nextClearOffTimeStamp:
                                                    DateTime.now());
                                          },
                                          child: const DetailAndIcon(
                                              Icons.navigate_next, "Next"));
                                    },
                                  ),
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
