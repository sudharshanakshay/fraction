import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../services/group/group.services.dart';
import '../../widgets/custom_input_form_field.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  createState() => CreateGroupState();
}

class CreateGroupState extends State<CreateGroup> {
  final _newGroupNameController = TextEditingController();
  final _joinGroupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // const Text('Join group'),
          CustomInputFormField(
              controller: _joinGroupNameController, label: 'Group name'),
          FilledButton(
              onPressed: () {
                GroupServices().joinCloudGroup(
                  inputGroupName: _joinGroupNameController.text,
                );
                //getGroupNamesFromLocalDatabase();
              },
              child: const Text('Join group')),
          const Flexible(
              child: FractionallySizedBox(
            heightFactor: 0.1,
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Create group'),
              const Flexible(
                  child: FractionallySizedBox(
                widthFactor: 0.1,
              )),
              FilledButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Scaffold.of(context).showBottomSheet<void>(
                      (BuildContext context) => Container(
                            height: 400,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text('Create new group'),
                                  CustomInputFormField(
                                      controller: _newGroupNameController,
                                      label: 'Group name'),
                                  FilledButton(
                                      onPressed: () {
                                        GroupServices().createCloudGroup(
                                            inputGroupName:
                                                _newGroupNameController.text);
                                      },
                                      child: const DetailAndIcon(
                                          Icons.navigate_next, "Next")),
                                ],
                              ),
                            ),
                          ));
                },
                //iconSize: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
