import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  });

  final String currentUserName;
  final String currentUserEmail;
  final String memberEmail;
  final String cost;
  final String description;
  final Timestamp time;

  @override
  State<StatefulWidget> createState() => ExpensePalletState();
}

class ExpensePalletState extends State<ExpensePallet> {
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
              widthFactor: 0.8,
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
                      const Text(','),
                      const Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 0.01,
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
}
