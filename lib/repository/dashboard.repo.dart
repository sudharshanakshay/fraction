// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:fraction/services/group/group.services.dart';

// class DashboardRepo extends ChangeNotifier  {
//   String _groupName = 'hello this is group';
//   Stream _myExpense = Stream.empty();
//   String _groupExpense = '';
//   String _nextClearOff = '';

//   get myExpense => _myExpense;

//   get groupName => _groupName;

//   late GroupServices _groupServiceRef;

//   DashboardRepo() {
//     _groupServiceRef = GroupServices();

//     print('-------dashboard repo init-----------');

//     // GroupServices().broadCastMyTotalExpense().stream.listen((event) {
//     //   print('---- listening on event ----');
//     //   _groupName = event.toString();
//     // });
//   }

//   void main() {
//     print('---- main func called ----');
//     init();
//   }

//   init() async {
//     await _groupServiceRef.getMyTotalExpense().listen((event) {
//       print('---- listening on event ----');
//       _groupName = event.toString();
//       notifyListeners();
//     });
//   }
// }
