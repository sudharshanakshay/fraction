import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/expenses/widgets/dashboard_shadow.dart';
import 'package:fraction/groups/services/groups_service.dart';
import 'package:fraction/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late GroupServices _groupService;

  @override
  void initState() {
    _groupService = GroupServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: StreamBuilder(
              stream: _groupService.getGroupDetials(
                  currentUserGroup: appState.currentUserGroup),
              builder: (context, groupDetailsSnapshot) {
                if (!groupDetailsSnapshot.hasData) {
                  return const DashboardShadow();
                }
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/groupInfo'),
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 6.0,
                      bottom: 2.0,
                      right: 12,
                      left: 12,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: appState.toggleRandomDashboardColor
                              ? getRandomColor()
                              : Colors.blue.shade100,
                        ),
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        dashboardExpenseDetail(
                            appState, groupDetailsSnapshot, context),
                        dashboardInfo(appState, groupDetailsSnapshot),
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  Column dashboardExpenseDetail(ApplicationState appState,
      AsyncSnapshot<dynamic> groupDetailsSnapshot, BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            // ---- (changes, group name now visible in app bar ) ----

            Text('Total Expense: ',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800)),

            Text(
                // ---- (ui, Total group expense) ----
                groupDetailsSnapshot.data['totalExpense'].toString(),
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                  // border: Border(
                  //     left: BorderSide(
                  //         width: 1.0,
                  //         color: Colors.black)),
                  ),
              child: Text('My Expense: ',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade800)),
            ),
            StreamBuilder(
                // ---- (ui, My Expense) Stream Builder ----
                stream: _groupService.getMyTotalExpense(
                    currentUserEmail: appState.currentUserEmail,
                    currentUserGroup: appState.currentUserGroup),
                builder: (context, myTotalExpenseSnapshot) {
                  if (myTotalExpenseSnapshot.hasData) {
                    return Text(
                        // ---- (ui, My Expense) ----
                        myTotalExpenseSnapshot.data.toString(),
                        style: const TextStyle(fontSize: 14));
                  } else {
                    return Container();
                  }
                }),
          ],
        )
      ],
    );
  }

  Column dashboardInfo(
      ApplicationState appState, AsyncSnapshot<dynamic> groupDetailsSnapshot) {
    return Column(
      children: [
        Column(
          // ---- (ui, Next clear off) ----
          children: [
            const Text('Next clear off', style: TextStyle(fontSize: 12)),
            Text(
                DateFormat.MMMd().format(groupDetailsSnapshot
                    .data['nextClearOffTimeStamp']
                    .toDate()),
                style: const TextStyle(fontSize: 16))
          ],
        ),
        Row(
          children: [
            appState.hasOneGroup
                ? IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/groupInfo');
                    },
                    // icon: SvgPicture.asset(_settingsIconPath),
                    icon: const Icon(Icons.bar_chart_outlined),
                  )
                : Container(),
            // IconButton(
            //   icon: SvgPicture.asset(moreMembersIcon),
            //   onPressed: () async {
            //     final someValue = await _groupService.getMemberDetails(
            //         currentUserGroup: appState.currentUserGroup);

            //     // ---- (ui, member expenses ) ----
            //     await showMemberDetails(memberDetailList: someValue);
            //   },
            // ),
          ],
        ),
      ],
    );
  }

  Future<String?> showMemberDetails({required List? memberDetailList}) {
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
              scrollable: true,
              content: SizedBox(
                height: 400,
                width: 400,
                child: memberDetailList != null && memberDetailList.isNotEmpty
                    ? ListView.builder(
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
                              title: Text(
                                  '${memberDetailList[index]['memberName']}'),
                              subtitle: Text(
                                '${memberDetailList[index]['totalExpense']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          );
                        })
                    : const Text('Group Member does not exists_'),
              ));
        });
  }
}
