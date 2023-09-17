import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/groups/services/groups_service.dart';
import 'package:fraction/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  late GroupServices _groupServices;
  late TextEditingController _groupNameController;
  late TextEditingController _clearOffDateController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _groupServices = GroupServices();
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

  setClearOffDateController({required dateToSet}) {
    _clearOffDateController.text =
        DateFormat.MMMd().format(dateToSet).toString();
  }

  @override
  Widget build(BuildContext context) {
    // ---- values initialization for date picker ----

    DateTime today = DateTime.now();
    DateTime selectedDate =
        DateTime(today.year, today.month + 1, today.day, today.hour);
    setClearOffDateController(dateToSet: selectedDate);
    DateTime lastDate = DateTime(today.year + 1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Fracton'),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // ---- (ui, root column for create group screen) ----

                  const SizedBox(
                    // ---- (ui, create group screen, top margin of 8) ----
                    height: 8,
                  ),

                  const Text(
                    // ---- (ui, heading for create group)----
                    'Create Expense Group',
                    style: TextStyle(fontSize: 20),
                  ),

                  const SizedBox(
                    // ---- (ui, top margin of 18) ----
                    height: 18,
                  ),

                  FractionallySizedBox(
                    // ---- (ui, user input for group name ) ----
                    widthFactor: 0.74,
                    child: TextFormField(
                      controller: _groupNameController,
                      validator: (value) => validateGroupName(value),
                      decoration:
                          const InputDecoration(label: Text('Group Name')),
                    ),
                  ),

                  Row(
                    // ---- (ui, user input for cleraOff TimeStamp) ----
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                          // ---- (ui, selected TimeStamp) ----
                          child: FractionallySizedBox(
                        widthFactor: 0.7,
                        child: TextFormField(
                          controller: _clearOffDateController,
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          decoration: const InputDecoration(
                              label: Text('Clear off date'),
                              // hintText: 'yyyy-mm-dd',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      )),
                      IconButton(
                          // ---- (ui, date picker) ----
                          onPressed: () async {
                            await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: today,
                                    lastDate: lastDate)
                                .then((value) {
                              if (value != null) {
                                selectedDate = value;
                                setClearOffDateController(dateToSet: value);
                              }
                            });
                          },
                          icon: const Icon(Icons.calendar_month)),
                    ],
                  ),

                  const SizedBox(
                    // ---- (ui, top margin of 10) ----
                    height: 10,
                  ),

                  FilledButton(
                      // ---- (ui, create group button) ----
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // appState.refreshGroupNamesAndExpenseInstances();
                          _groupServices
                              .createGroup(
                                  inputGroupName: _groupNameController.text,
                                  nextClearOffTimeStamp: selectedDate,
                                  currentUserName: appState.currentUserName,
                                  currentUserEmail: appState.currentUserEmail,
                                  applicationState: appState)
                              .then((String result) {
                            if (result != Constants().failed) {
                              appState.setCurrentUserGroup(
                                  currentUserGroup: result);
                              Navigator.pop(context);
                            }
                          });
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
