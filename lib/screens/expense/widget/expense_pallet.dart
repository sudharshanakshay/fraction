import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensePallet extends StatefulWidget {
  const ExpensePallet(
      {super.key,
      required this.streamSnapshot,
      required this.index,
      this.leading = false});

  final AsyncSnapshot<QuerySnapshot<Object?>> streamSnapshot;
  final int index;
  final bool leading;

  @override
  State<StatefulWidget> createState() => ExpensePalletState();
}

class ExpensePalletState extends State<ExpensePallet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(
              //eft: BorderSide(
              width: 2,
              // color: getRandomColor(),
              color: Colors.blue.shade100,
              //)
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          //height: 50,
          //color: Colors.amber[colorCodes[index % 3]],
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(
                '${widget.streamSnapshot.data?.docs[widget.index]['description']}'),
            //isThreeLine: true,
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    widget.streamSnapshot.data?.docs[widget.index]['userName']),
                const Text(','),
                const Flexible(
                  child: FractionallySizedBox(
                    widthFactor: 0.01,
                  ),
                ),
                Text(DateFormat.yMMMd().format(widget
                    .streamSnapshot.data?.docs[widget.index]['timeStamp']
                    .toDate())),
              ],
            ),

            trailing: Text(
              '${widget.streamSnapshot.data?.docs[widget.index]['cost']}/-',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ));
  }
}
