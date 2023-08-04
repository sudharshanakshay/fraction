import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fraction/services/group/group.services.dart';
import 'package:fraction/utils/tools.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.context});

  final BuildContext context;
  final String moreMembersIcon = 'assets/icons/moreMembersIcon.svg';

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupServices>(
      builder: (context, groupServiceState, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: StreamBuilder(
              stream: groupServiceState.getGroupDetials(),
              builder: (context, groupDetailsSnapshot) {
                if (groupDetailsSnapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.blue.shade100,
                        ),
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StreamBuilder(
                                stream: groupServiceState.getMyTotalExpense(),
                                builder: (context, myTotalExpenseSnapshot) {
                                  if (myTotalExpenseSnapshot.hasData) {
                                    return Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black))),
                                          child: const Text('My Expense: ',
                                              style: TextStyle(fontSize: 16)),
                                        ),
                                        Text(
                                            myTotalExpenseSnapshot.data
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 16))
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                            Column(
                              children: [
                                const Text('Next clear off',
                                    style: TextStyle(fontSize: 12)),
                                Text(
                                    DateFormat.MMMd().format(
                                        groupDetailsSnapshot
                                            .data['nextClearOffTimeStamp']
                                            .toDate()),
                                    style: const TextStyle(fontSize: 16))
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(Tools().sliptElements(
                                element:
                                    groupServiceState.currentUserGroup)[0]),
                            IconButton(
                              icon: SvgPicture.asset(moreMembersIcon),
                              onPressed: () async {
                                final someValue =
                                    await groupServiceState.getMemberDetails();
                                // for (var element in someValue!) {

                                // }
                                await showMemberDetails(
                                    memberDetailList: someValue);
                              },
                            ),
                            Text(
                                groupDetailsSnapshot.data['totalExpense']
                                    .toString(),
                                style: const TextStyle(fontSize: 12)),
                            IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/groupInfo');
                                },
                                icon: const Icon(Icons.navigate_next))
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        );
      },
    );
  }

  Future<String?> showMemberDetails({required memberDetailList}) {
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
              scrollable: true,
              content: SizedBox(
                height: 400,
                width: 400,
                child: ListView.builder(
                    itemCount: memberDetailList.length,
                    itemBuilder: (context, int index) {
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
                              Text('${memberDetailList[index]['memberName']}'),
                          subtitle: Text(
                            '${memberDetailList[index]['totalExpense']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    }),
              ));
        });
  }
}
