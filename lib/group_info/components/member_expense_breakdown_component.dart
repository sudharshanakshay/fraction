// similar to 'members_details_component'
// but, calculated expense is displayed.

import 'package:flutter/material.dart';
import 'package:fraction/group_info/models/member_expense_breakdown_model.dart';

class MemberExpenseBreakdownComponent extends StatelessWidget {
  const MemberExpenseBreakdownComponent({
    required this.groupMembers,
    super.key,
  });

  final List<MemberExpenseBreakdownModel> groupMembers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            // gridView
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupMembers.length,
              itemBuilder: (BuildContext context, int index) {
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
                    title: Text(groupMembers[index].memberName),
                    subtitle: Text(
                      groupMembers[index].memberExpenditureSummary,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: (1 / .4)),
            ),
          ),
        ],
      ),
    );
  }
}
