import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:fraction/groups/models/groups_model.dart';
import 'package:provider/provider.dart';

class ExpensesHistory extends StatelessWidget {
  const ExpensesHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('View History'),
      ),
      body: Consumer<GroupsRepo>(
        builder: (context, groupState, child) => FutureBuilder(
            future: FirebaseFunctions.instance
                .httpsCallable('getExpenseInstances')
                .call(),
            builder: (context, getExpenseInstancesResult) {
              if (!getExpenseInstancesResult.hasError &&
                  getExpenseInstancesResult.data != null) {
                Map<String, dynamic> data =
                    getExpenseInstancesResult.data as Map<String, dynamic>;
                return Text(data['isError']);
              }
              return Text(getExpenseInstancesResult.error.toString());
            }),
      ),
    );
  }
}


// return ListView.builder(
                  //   itemCount: snapshot.data!.data()? ['history']!.length,
                  //   itemBuilder: (_, index) => Text(
                  //       snapshot.data!.data()?['history'][index].toString() ??
                  //           'null'),
                  // );