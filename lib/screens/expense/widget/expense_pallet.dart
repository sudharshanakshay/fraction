import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/services/expense/expense.services.dart';
import 'package:intl/intl.dart';

class ExpensePallet extends StatefulWidget {
  const ExpensePallet({
    super.key,
    required this.currentUserName,
    required this.currentUserEmail,
    required this.memberEmail,
    required this.description,
    required this.cost,
    required this.time,
    required this.expenseServiceState,
    required this.expenseDocId,
  });

  final String currentUserName;
  final String currentUserEmail;
  final String memberEmail;
  final String cost;
  final String description;
  final Timestamp time;
  final ExpenseService expenseServiceState;
  final String expenseDocId;

  @override
  State<StatefulWidget> createState() => ExpensePalletState();
}

class ExpensePalletState extends State<ExpensePallet> {
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
        mainAxisAlignment: widget.currentUserEmail == widget.memberEmail
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
                    _descriptionTextController.text = widget.description;
                    _costTextController.text = widget.cost;
                    // print(widget.memberEmail);
                    // print(widget.currentUserEmail);
                    if (widget.memberEmail == widget.currentUserEmail) {
                      showExpenseDialog();
                    }
                  },
                  // leading: const Icon(Icons.person),
                  title: Text(widget.description,
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
                      Text(DateFormat.jm().format(widget.time.toDate()),
                          style: const TextStyle(fontSize: 12)),
                      // Text(DateFormat.yMMMd().format(widget
                      //     .streamSnapshot.data?.docs[widget.index]['timeStamp']
                      //     .toDate())),
                    ],
                  ),

                  trailing: Text(
                    '${widget.cost}/-',
                    style: const TextStyle(fontSize: 16),
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _descriptionTextController,
              decoration: const InputDecoration(
                label: Text('Item Name'),
              )),
          TextField(
              controller: _costTextController,
              decoration: const InputDecoration(
                label: Text('Item Cost'),
              ))
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('cancel')),
        FilledButton(
            onPressed: () async {
              const snakBar = SnackBar(content: Text('updating expense ...'));
              ScaffoldMessenger.of(context).showSnackBar(snakBar);
              print(widget.expenseDocId);
              widget.expenseServiceState
                  .updateExpense(
                      docId: widget.expenseDocId,
                      updatedDescription: _descriptionTextController.text,
                      updatedCost: _costTextController.text,
                      previousCost: widget.cost)
                  .whenComplete(() => Navigator.pop(context));
            },
            child: const Text('update')),
      ],
    );
  }
}
