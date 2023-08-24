import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/services/expense/expense.services.dart';
import 'package:fraction/utils/color.dart';
import 'package:intl/intl.dart';

class ExpensePallet extends StatefulWidget {
  const ExpensePallet({
    super.key,
    required this.expenseDoc,
    required this.currentUserName,
    required this.currentUserEmail,
    required this.expenseServiceState,
    required this.appState,
  });

  final QueryDocumentSnapshot expenseDoc;
  final String currentUserName;
  final String currentUserEmail;
  final ExpenseService expenseServiceState;
  final ApplicationState appState;

  @override
  State<StatefulWidget> createState() => _ExpensePalletState();
}

class _ExpensePalletState extends State<ExpensePallet> {
  final _descriptionTextController = TextEditingController();
  final _costTextController = TextEditingController();

  Future showExpenseDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return manageExpense();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            widget.currentUserEmail == widget.expenseDoc['emailAddress']
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    //eft: BorderSide(
                    width: 2,
                    // color: getRandomColor(),
                    color: Colors.blue.shade100,
                    //)
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                //height: 50,
                //color: Colors.amber[colorCodes[index % 3]],
                child: ListTile(
                  onLongPress: () {
                    _descriptionTextController.text =
                        widget.expenseDoc['description'];
                    _costTextController.text =
                        widget.expenseDoc['cost'].toString();

                    if (widget.expenseDoc['emailAddress'] ==
                        widget.currentUserEmail) {
                      showExpenseDialog();
                    }
                  },
                  // leading: const Icon(Icons.person),
                  title: Text(widget.expenseDoc['description'],
                      style: const TextStyle(fontSize: 16)),
                  // '${widget.streamSnapshot.data?.docs[widget.index]['description']}'),
                  //isThreeLine: true,
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(widget.currentUserName,
                          style: const TextStyle(fontSize: 12)),
                      // widget.streamSnapshot.data?.docs[widget.index]['userName']),
                      // const Text(','),
                      const Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 0.04,
                        ),
                      ),
                      Text(
                          DateFormat.jm()
                              .format(widget.expenseDoc['timeStamp'].toDate()),
                          style: const TextStyle(fontSize: 12)),
                      // Text(DateFormat.yMMMd().format(widget
                      //     .streamSnapshot.data?.docs[widget.index]['timeStamp']
                      //     .toDate())),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.expenseDoc['tags'].length != 0
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                    color: AppColors().tags,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Text('updated'),
                              ),
                            )
                          : Container(),
                      // if (widget.expenseDoc['tags'].length != 0)

                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   scrollDirection: Axis.horizontal,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: widget.expenseDoc['tags'].length,
                      //   itemBuilder: (context, index) {
                      //     return Padding(
                      //       padding: const EdgeInsets.only(right: 8.0),
                      //       child: SizedBox(
                      //         height: 6.0,
                      //         child: Container(
                      //           padding: const EdgeInsets.symmetric(
                      //               horizontal: 4.0),
                      //           decoration: BoxDecoration(
                      //               color: AppColors().tags,
                      //               borderRadius: BorderRadius.circular(12)),
                      //           child: Text(
                      //             widget.expenseDoc['tags'][index],
                      //           ),

                      //         ),
                      //       ),
                      //     );
                      // },
                      // ),
                      Text(
                        '${widget.expenseDoc['cost']}/-',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget manageExpense() {
    return AlertDialog(
      title: const Text('Edit Expense'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _descriptionTextController,
                decoration: const InputDecoration(
                  label: Text('Item Name'),
                )),
            TextField(
                controller: _costTextController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Item Cost'),
                ))
          ],
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('cancel')),
                FilledButton(
                    onPressed: () async {
                      const snakBar =
                          SnackBar(content: Text('updating expense ...'));
                      ScaffoldMessenger.of(context).showSnackBar(snakBar);
                      widget.expenseServiceState
                          .updateExpense(
                              docId: widget.expenseDoc.id,
                              updatedDescription:
                                  _descriptionTextController.text,
                              updatedCost: _costTextController.text,
                              previousCost: widget.expenseDoc['cost'],
                              currentUserEmail:
                                  widget.appState.currentUserEmail,
                              currentUserGroup:
                                  widget.appState.currentUserGroup,
                              currentExpenseInstance:
                                  widget.appState.currentExpenseInstance)
                          .whenComplete(() => Navigator.pop(context));
                    },
                    child: const Text('update')),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                TextButton(
                  onPressed: () async {
                    await confirmDeleteExpense().then((msg) {
                      if (msg == 'OK') {
                        widget.expenseServiceState
                            .deleteExpense(
                                expenseDoc: widget.expenseDoc,
                                currentUserEmail:
                                    widget.appState.currentUserEmail,
                                currentUserGroup:
                                    widget.appState.currentUserGroup,
                                currentExpenseInstance:
                                    widget.appState.currentExpenseInstance)
                            .whenComplete(() => Navigator.pop(context));
                      }
                    });
                  },
                  child: const Text('delete expense ?'),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Future<String?> confirmDeleteExpense() {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete Alert'),
              content: const Text('do you want to delete expense ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  @override
  void dispose() {
    _costTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }
}
