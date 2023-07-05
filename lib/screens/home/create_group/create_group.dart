import 'package:flutter/material.dart';
import 'package:fraction/group_state.dart';
import 'package:fraction/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../../services/group/group.services.dart';
import '../../../widgets/input_text_field.dart';

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
    return Consumer<GroupState>(
      builder: (context, groupState, _) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // const Text('Join group'),
          CustomInputFormField(
              controller: _joinGroupNameController, label: 'Group name'),
          FilledButton(
              onPressed: () {
                groupState.joinCloudGroup(_joinGroupNameController.text);
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
                                        createCloudGroup(
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
