import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fraction/repository/notification.repo.dart';
import 'package:fraction/services/group/group.services.dart';
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
  final String clearOffIconPath = 'assets/icons/ClearOffIcon.svg';
  late DateTime next30day;
  late NotificationRepo _notificationRepoRef;
  late TextEditingController _memberEmailController;
  bool inviteToggle = true;

  @override
  void initState() {
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
    return Consumer<GroupServices>(builder: (context, groupServiceState, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
              'Fraction : ${Tools().sliptElements(element: groupServiceState.currentUserGroup)[0]}',
              style: const TextStyle(fontSize: 20)),
          actions: [
            kDebugMode
                ? IconButton(onPressed: () {}, icon: const Icon(Icons.print))
                : Container(),
            IconButton(
              onPressed: () async {
                if (kDebugMode) {
                  print('');
                }
                await confirmClearOff().then((value) {
                  if (value != Constants().cancel && value != null) {
                    groupServiceState.clearOff(
                        nextClearOffDate: value as DateTime);
                  }
                });
              },
              icon: SvgPicture.asset(clearOffIconPath),
            ),
            const SizedBox(
              width: 8.0,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<List>(
                    stream: FirebaseFirestore.instance
                        .collection('group')
                        .doc(groupServiceState.currentUserGroup)
                        .snapshots()
                        .asyncExpand((doc) {
                      try {
                        List memberDetails = [];
                        if (doc.exists && doc.data()!.isNotEmpty) {
                          var groupMemberDetails = doc.data()!['groupMembers']
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AccountPallet(
                                        streamSnapshot: snapshot, index: index);
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
