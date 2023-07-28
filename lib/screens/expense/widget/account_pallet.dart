// import 'package:flutter/material.dart';

// class AccountPallet extends StatefulWidget {
//   const AccountPallet(
//       {super.key,
//       required this.streamSnapshot,
//       required this.index,
//       this.leading = false});

//   final AsyncSnapshot streamSnapshot;
//   final int index;
//   final bool leading;

//   @override
//   State<StatefulWidget> createState() => AccountPalletState();
// }

// class AccountPalletState extends State<AccountPallet> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Consumer<GroupServices>(
//         builder: (context, groupServiceState, child) => StreamBuilder(
//             stream: groupServiceState.getMemberDetails(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 2,
//                       color: getRandomColor(),
//                     ),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   padding: const EdgeInsets.all(10),
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: snapshot.data?.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return AccountPallet(
//                           streamSnapshot: snapshot, index: index);
//                     },
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2, childAspectRatio: (1 / .4)),
//                   ),
//                 );
//               } else {
//                 return Container();
//               }
//             }),
//       ),
//     );
    
    
    
//     Container(
//       decoration: BoxDecoration(
//         border: Border(
//             left: BorderSide(
//           width: 2,
//           color: Colors.blue.shade100,
//         )),
//         // borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         title:
//             Text('${widget.streamSnapshot.data[widget.index]['memberName']}'),
//         subtitle: Text(
//           '${widget.streamSnapshot.data[widget.index]['totalExpense']}',
//           style: const TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
