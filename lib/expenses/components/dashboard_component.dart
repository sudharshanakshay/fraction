import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/expenses/models/dashboard_model.dart';
import 'package:fraction/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardRepo>(
      builder: (context, dashboardRepoState, child) {
        return Consumer<ApplicationState>(
          builder: (context, appState, _) {
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
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
                        // first column where
                        // 1. TotalExpense &
                        // 2. My Expense is displayed.
                        dashboardExpenseDetail(
                            dashboard: dashboardRepoState.dashboard),

                        // second column where
                        // 1. nextClearOff data is displayed.
                        dashboardInfo(dashboard: dashboardRepoState.dashboard),
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }

  Column dashboardExpenseDetail({required DashboardRepoModel dashboard}) {
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
                dashboard.totalExpense,
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
            Text(
                // ---- (ui, My Expense) ----
                dashboard.myExpense,
                style: const TextStyle(fontSize: 14)),
          ],
        )
      ],
    );
  }

  Column dashboardInfo({required DashboardRepoModel dashboard}) {
    return Column(
      children: [
        Column(
          // ---- (ui, Next clear off) ----
          children: [
            const Text('Next clear off', style: TextStyle(fontSize: 12)),
            Text(DateFormat.MMMd().format(dashboard.nextClearOffDate),
                style: const TextStyle(fontSize: 16))
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/groupInfo');
              },
              // icon: SvgPicture.asset(_settingsIconPath),
              icon: const Icon(Icons.bar_chart_outlined),
            )
          ],
        ),
      ],
    );
  }

  // Future<String?> showMemberDetails({required List? memberDetailList}) {
  //   return showDialog<String>(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //             scrollable: true,
  //             content: SizedBox(
  //               height: 400,
  //               width: 400,
  //               child: memberDetailList != null && memberDetailList.isNotEmpty
  //                   ? ListView.builder(
  //                       itemCount: memberDetailList.length,
  //                       itemBuilder: (context, int index) {
  //                         return Container(
  //                           decoration: BoxDecoration(
  //                             border: Border(
  //                                 left: BorderSide(
  //                               width: 2,
  //                               color: Colors.blue.shade100,
  //                             )),
  //                             // borderRadius: BorderRadius.circular(12),
  //                           ),
  //                           child: ListTile(
  //                             title: Text(
  //                                 '${memberDetailList[index]['memberName']}'),
  //                             subtitle: Text(
  //                               '${memberDetailList[index]['totalExpense']}',
  //                               style: const TextStyle(fontSize: 20),
  //                             ),
  //                           ),
  //                         );
  //                       })
  //                   : const Text('Group Member does not exists_'),
  //             ));
  //       });
  // }
}
