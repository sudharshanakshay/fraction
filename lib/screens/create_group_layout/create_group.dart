import 'package:flutter/material.dart';
import 'package:fraction/services/group/group.services.dart';
import 'package:fraction/utils/constants.dart';
import 'package:provider/provider.dart';

class CreateGroupLayout extends StatefulWidget {
  const CreateGroupLayout({super.key});

  @override
  createState() => _CreateGroupLayoutState();
}

class _CreateGroupLayoutState extends State<CreateGroupLayout> {
  late TextEditingController _groupNameController;
  late TextEditingController _clearOffDateController;
  late GlobalKey<FormState> _formKey;
  DateTime? _selectedDate;

  @override
  void initState() {
    _groupNameController = TextEditingController();
    _clearOffDateController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _clearOffDateController.dispose();
    super.dispose();
  }

  validateGroupName(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter group Name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Fracton'),
      ),
      body: Consumer<GroupServices>(
        builder: (context, groupServiceState, _) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Create Expense Group',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // ---- select group name ----
                  FractionallySizedBox(
                    widthFactor: 0.74,
                    child: TextFormField(
                      controller: _groupNameController,
                      validator: (value) => validateGroupName(value),
                      decoration:
                          const InputDecoration(label: Text('Group Name')),
                    ),
                  ),
                  // ---- select cleraOff TimeStamp ----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                          child: FractionallySizedBox(
                        widthFactor: 0.7,
                        child: TextFormField(
                          controller: _clearOffDateController,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                              label: Text('Clear off date'),
                              hintText: 'yyyy-mm-dd',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      )),
                      IconButton(
                          onPressed: () async {
                            await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _selectedDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year + 1))
                                .then((value) {
                              if (value != null) {
                                _selectedDate = value;
                                _clearOffDateController.text = value.toString();
                              }
                            });
                          },
                          icon: const Icon(Icons.calendar_today)),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (groupServiceState.createGroup(
                                  inputGroupName: _groupNameController.text,
                                  nextClearOffTimeStamp: (_selectedDate)) ==
                              Constants().success) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('Create')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
