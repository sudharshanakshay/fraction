import 'package:flutter/material.dart';
import 'package:fraction/app_state.dart';
import 'package:fraction/expenses/services/expenses_service.dart';
import 'package:fraction/utils/color.dart';
import 'package:intl/intl.dart';

class ExpenseListTile extends StatefulWidget {
  const ExpenseListTile(
      {super.key,
      // required this.expenseDoc,
      required this.expenseDocId,
      required this.currentUserName,
      required this.currentUserEmail,
      required this.expenseServiceState,
      required this.appState,
      required this.emailAddress,
      required this.description,
      required this.cost,
      required this.tags,
      required this.timeStamp});

  // final QueryDocumentSnapshot expenseDoc;
  final String expenseDocId;
  final String currentUserName;
  final String currentUserEmail;
  final ExpenseService expenseServiceState;
  final ApplicationState appState;
  final String emailAddress;
  final String description;
  final String cost;
  final DateTime timeStamp;
  final List<String> tags;

  @override
  State<StatefulWidget> createState() => _ExpenseListTileState();
}

class _ExpenseListTileState extends State<ExpenseListTile> {
  final _descriptionTextController = TextEditingController();
  final _costTextController = TextEditingController();

  Future showExpenseDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return manageExpense();
        });
  }

  TextStyle titleListTileStyle =
      TextStyle(fontSize: 16, color: Colors.grey.shade800);

  TextStyle subListTileStyle =
      TextStyle(fontSize: 12, color: Colors.grey.shade600);

  TextStyle trailingListTileStyle =
      TextStyle(fontSize: 16, color: Colors.grey.shade800);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: widget.currentUserEmail == widget.emailAddress
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
                    width: 1.6,
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

                    if (widget.emailAddress == widget.currentUserEmail) {
                      showExpenseDialog();
                    }
                  },
                  // leading: const Icon(Icons.person),
                  title: Text(widget.description, style: titleListTileStyle),
                  // '${widget.streamSnapshot.data?.docs[widget.index]['description']}'),
                  //isThreeLine: true,
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(widget.currentUserName, style: subListTileStyle),
                      // widget.streamSnapshot.data?.docs[widget.index]['userName']),
                      // const Text(','),
                      const Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 0.04,
                        ),
                      ),
                      Text(
                        DateFormat.jm().format(widget.timeStamp),
                        style: subListTileStyle,
                      ),
                      // Text(DateFormat.yMMMd().format(widget
                      //     .streamSnapshot.data?.docs[widget.index]['timeStamp']
                      //     .toDate())),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.tags.isNotEmpty
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
                      Text(
                        '${widget.cost}/-',
                        style: trailingListTileStyle,
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
                              docId: widget.expenseDocId,
                              updatedDescription:
                                  _descriptionTextController.text,
                              updatedCost: _costTextController.text,
                              previousCost: int.parse(widget.cost),
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
                                expenseDocId: widget.expenseDocId,
                                emailAddress: widget.emailAddress,
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
