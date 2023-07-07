import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountPallet extends StatefulWidget {
  const AccountPallet(
      {super.key,
      required this.streamSnapshot,
      required this.index,
      this.leading = false});

  final AsyncSnapshot<DocumentSnapshot<Object?>> streamSnapshot;
  final int index;
  final bool leading;

  @override
  State<StatefulWidget> createState() => AccountPalletState();
}

class AccountPalletState extends State<AccountPallet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.blue.shade100,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
                '${widget.streamSnapshot.data?['groupMembers'][widget.index]['userName']}'),
            subtitle: Text(
              '${widget.streamSnapshot.data?['groupMembers'][widget.index]['totalExpense']}',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ));
  }
}
