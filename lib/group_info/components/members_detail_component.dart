import 'package:flutter/material.dart';
import 'package:fraction/group_info/models/group_info_model.dart';
import 'package:provider/provider.dart';

class MemberExpenseDetail extends StatelessWidget {
  const MemberExpenseDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            // gridView
            child: Consumer<GroupInfoRepo>(
              builder: (context, groupInfoRepoState, child) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groupInfoRepoState.groupMembers.length,
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
                      title: Text(
                          groupInfoRepoState.groupMembers[index].memberName),
                      subtitle: Text(
                        groupInfoRepoState.groupMembers[index].memberExpense,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: (1 / .4)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
