import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/repository/notification.repo.dart';
import 'package:fraction/services/group/group.services.dart';
import 'package:fraction/services/user/user.services.dart';
import 'package:fraction/utils/constants.dart';
import 'package:fraction/utils/tools.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo({Key? key}) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  late GroupServices _groupServices;
  late UserServices _userServices;
  final String clearOffIconPath = 'assets/icons/ClearOffIcon.svg';
  late DateTime next30day;
  late NotificationRepo _notificationRepoRef;
  late TextEditingController _memberEmailController;
  bool inviteToggle = true;

  @override
  void initState() {
    _groupServices = GroupServices();
    _userServices = UserServices();
    _notificationRepoRef =
        Provider.of<NotificationRepo>(context, listen: false);
    _memberEmailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _memberEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
              Tools().sliptElements(element: appState.currentUserGroup)[0],
              style: const TextStyle(fontSize: 20)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder<List>(
                        stream: FirebaseFirestore.instance
                            .collection('group')
                            .doc(appState.currentUserGroup)
                            .snapshots()
                            .asyncExpand((doc) {
                          try {
                            List memberDetails = [];
                            if (doc.exists && doc.data()!.isNotEmpty) {
                              var groupMemberDetails =
                                  doc.data()!['groupMembers']
                                      as Map<String, dynamic>;
                              groupMemberDetails.forEach((key, value) {
                                memberDetails.add(value);
                              });
                            }
                            return Stream.value(memberDetails);
                          } catch (e) {
                            return const Stream.empty();
                          }
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return AccountPallet(
                                            streamSnapshot: snapshot,
                                            index: index);
                                      },
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: (1 / .4)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                    inviteToggle ? inviteMemberToggle() : inviteMemberView(),
                  ],
                ),
                Container(
                  color: const Color(0x00640000),
                  child: Column(
                    children: [
                      ListTile(
                          leading: SvgPicture.asset(
                            clearOffIconPath,
                            color: Colors.blueAccent,
                          ),
                          title: const Text(
                            'Clear off',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.blueAccent),
                          ),
                          onTap: () async {
                            await confirmClearOff().then((value) async {
                              if (value != Constants().cancel &&
                                  value != null) {
                                _groupServices
                                    .clearOff(
                                        nextClearOffDate: value as DateTime,
                                        currentUserGroup:
                                            appState.currentUserGroup)
                                    .whenComplete(() => appState
                                        .refreshGroupNamesAndExpenseInstances());
                              }
                            });
                          }),
                      ListTile(
                        leading: const Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Exit group',
                          style: TextStyle(fontSize: 16.0, color: Colors.red),
                        ),
                        onTap: () async {
                          await confirmExitGroup().then((value) async {
                            if (value != Constants().cancel && value != null) {
                              _userServices
                                  .exitGroup(
                                      currentUserEmail:
                                          appState.currentUserEmail,
                                      currentUserGroup:
                                          appState.currentUserGroup,
                                      appState: appState)
                                  .whenComplete(() => Navigator.pop(context));
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget inviteMemberToggle() {
    return ListTile(
      leading: const Icon(Icons.person_add_outlined),
      title: const Text('Invite Member'),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () => setState(() {
        inviteToggle = inviteToggle ? false : true;
      }),
    );
  }

  Widget inviteMemberView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        inviteMemberToggle(),
        FractionallySizedBox(
          widthFactor: 0.7,
          child: Form(
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _memberEmailController,
              decoration: const InputDecoration(
                  label: Text('member email'), hintText: 'name@example.domain'),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        FilledButton(
            onPressed: () async {
              _notificationRepoRef
                  .inviteMember(to: _memberEmailController.text)
                  .whenComplete(() {
                _memberEmailController.clear();
                setState(() {
                  inviteToggle = true;
                });
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Invited'),
                            Flexible(
                              child: FractionallySizedBox(
                                widthFactor: 0.1,
                              ),
                            ),
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      );
                    });
              });
            },
            child: const Text('Invite')),
      ],
    );
  }

  Future<String?> confirmExitGroup() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exit group'),
        content: const Text(
            'exiting group will remore you from the group, but your expense data will persist _'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(6.0)),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> confirmClearOff() {
    TextEditingController selectDateController = TextEditingController();
    DateTime today = DateTime.now();
    DateTime selectedDateTime =
        DateTime(today.year, today.month + 1, today.day, today.hour);
    DateTime lastDate = DateTime(today.year + 1);

    // selectDateController.text = initialDate.toString();

    setSelectedDateController({required dateToSet}) {
      selectDateController.text =
          DateFormat.MMMd().format(dateToSet).toString();
    }

    setSelectedDateController(dateToSet: selectedDateTime);

    return showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                'Confirm clearoff',
                style: TextStyle(fontSize: 16),
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('next clearOff will be on _'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 80,
                        child: TextFormField(
                          controller: selectDateController,
                          readOnly: true,
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await showDatePicker(
                                    context: context,
                                    initialDate: selectedDateTime,
                                    firstDate: today,
                                    lastDate: lastDate)
                                .then((dateTime) {
                              if (dateTime != null) {
                                selectedDateTime = dateTime;
                                setSelectedDateController(dateToSet: dateTime);
                              }
                            });
                          },
                          icon: const Icon(Icons.calendar_month))
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, Constants().cancel),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, selectedDateTime),
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}

class AccountPallet extends StatefulWidget {
  const AccountPallet(
      {super.key,
      required this.streamSnapshot,
      required this.index,
      this.leading = false});

  final AsyncSnapshot streamSnapshot;
  final int index;
  final bool leading;

  @override
  State<StatefulWidget> createState() => AccountPalletState();
}

class AccountPalletState extends State<AccountPallet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(
          width: 2,
          color: Colors.blue.shade100,
        )),
        // borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title:
            Text('${widget.streamSnapshot.data[widget.index]['memberName']}'),
        subtitle: Text(
          '${widget.streamSnapshot.data[widget.index]['totalExpense']}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}