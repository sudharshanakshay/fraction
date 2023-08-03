import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fraction/services/group/group.services.dart';
import 'package:provider/provider.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo({Key? key}) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final String clearOffIconPath = 'assets/icons/ClearOffIcon.svg';
  @override
  Widget build(BuildContext context) {
    return Consumer<GroupServices>(builder: (context, groupServiceState, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Fraction : ${groupServiceState.currentUserGroup}',
              style: const TextStyle(fontSize: 20)),
          actions: [
            IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print('');
                }
                // Navigator.pushNamed(context, '/profile');
              },
              icon: SvgPicture.asset(clearOffIconPath),
            ),
            const SizedBox(
              width: 8.0,
            )
          ],
        ),
        body: Column(
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
                      var groupMemberDetails =
                          doc.data()!['groupMembers'] as Map<String, dynamic>;
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
                    return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.blue.shade100,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AccountPallet(
                                  streamSnapshot: snapshot, index: index);
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: (1 / .4)),
                          ),
                        ));
                  } else {
                    return Container();
                  }
                })
          ],
        ),
      );
    });
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
