import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraction/database/expense.database.dart';
import 'package:fraction/database/group.database.dart';
import 'package:fraction/services/fraction_services.dart';

class ExpenseService extends FractionServices {
  Stream<QuerySnapshot> getExpenseCollection() {
    try {
      return ExpenseDatabase()
          .getExpenseCollection(currentGroupName: super.currentUserGroup);
    } catch (e) {
      print(e);
      return const Stream.empty();
    }
  }

  Stream<QuerySnapshot> getMyExpenses() {
    try {
      return ExpenseDatabase().getMyExpenses(
          currentGroupName: super.currentUserGroup,
          currentUserEmail: super.currentUserEmail);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future addExpense({required String description, required cost}) async {
    ExpenseDatabase()
        .addExpense(
            currentGroupName: super.currentUserGroup,
            currentUserEmail: super.currentUserEmail,
            description: description,
            cost: cost)
        .whenComplete(() {
      updateGroupMemberExpense(
        memberEmail: super.currentUserEmail,
        groupName: super.currentUserGroup,
        expenseDiff: int.parse(cost),
      );
    });
  }

  void deleteExpense({required docId, required cost}) {
    ExpenseDatabase()
        .deleteMyExpense(
            currentUserEmail: super.currentUserEmail,
            currentGroupName: super.currentUserGroup,
            docId: docId)
        .whenComplete(() {
      updateGroupMemberExpense(
          groupName: super.currentUserGroup,
          memberEmail: super.currentUserEmail,
          expenseDiff: -int.parse(cost));
    });
  }
}


//  ExpenseService() {
//     init();
//   }

//   bool _loggedIn = false;
//   bool get loggedIn => _loggedIn;

//   String _currentUserEmail = '';
//   String get currentUserEmail => _currentUserEmail;

//   String _currentUserGroup = '';
//   String get currentUserGroup => _currentUserGroup;

//   Future<void> init() async {
//     FirebaseAuth.instance.userChanges().listen((user) {
//       if (user != null) {
//         _loggedIn = true;
//         _currentUserEmail = user.email!;
//         print("current group value ${_currentUserGroup}");
//         if (_currentUserGroup.isEmpty) {
//           try {
//             FirebaseFirestore.instance
//                 .collection('profile')
//                 .doc(_currentUserEmail)
//                 .get()
//                 .then((DocumentSnapshot doc) {
//               final currentProfileDetails = doc.data() as Map<String, dynamic>;
//               for (String groupName in currentProfileDetails['groupNames']) {
//                 if (groupName.isNotEmpty) {
//                   print('---- printing group name from expense services ----');
//                   print(groupName);
//                   _currentUserGroup = groupName;
//                   notifyListeners();
//                   break;
//                 }
//               }
//             });
//           } catch (e) {
//             throw ('user has no group');
//           }

//           notifyListeners();
//         }
//       } else {
//         _loggedIn = false;
//       }
//       notifyListeners();
//     });
//   }

//   // ---- set currentGroupName variable ----
//   Future<void> setCurrentGroupName({required String currentGroupName}) async {
//     _currentUserGroup = currentGroupName;
//     notifyListeners();
//     print('current group -> $_currentUserGroup');
//   }