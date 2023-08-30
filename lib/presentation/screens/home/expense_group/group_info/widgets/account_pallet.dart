import 'package:flutter/material.dart';

class AccountPallet extends StatefulWidget {
  const AccountPallet(
      {super.key,
      required this.streamSnapshot,
      required this.index,
      this.leading = false});

  final AsyncSnapshot streamSnapshot;
  final int index;
  final bool leading;

  @override
  State<StatefulWidget> createState() => AccountPalletState();
}

class AccountPalletState extends State<AccountPallet> {
  @override
  Widget build(BuildContext context) {
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
        title:
            Text('${widget.streamSnapshot.data[widget.index]['memberName']}'),
        subtitle: Text(
          '${widget.streamSnapshot.data[widget.index]['totalExpense']}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
