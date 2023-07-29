import 'package:cloud_firestore/cloud_firestore.dart';

class DevilCode {
  callDevil2({shouldCallGrouptotalValueUpdate = false}) {
    if (shouldCallGrouptotalValueUpdate) {
      FirebaseFirestore.instance
          .collection('group')
          .doc('akshaya')
          .get()
          .then((value) {
        final doc = value.data() as Map<String, dynamic>;
        final groupMembers = doc['groupMembers'] as Map<String, dynamic>;
        int totalExpense = 0;
        groupMembers.forEach((key, value) {
          print(value['totalExpense']);
          totalExpense += int.parse(value['totalExpense'].toString());
        });
        print(totalExpense.toString());
        FirebaseFirestore.instance
            .collection('group')
            .doc('akshaya')
            .update({'totalExpense': totalExpense});
      });
    }
  }

  callDevil1({shouldCallExpenseToGroupExpense = false}) {
    if (shouldCallExpenseToGroupExpense) {
      FirebaseFirestore.instance.collection('expense').get().then((value) {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            print(element.data());
            final data = {
              'cost': element.data()['cost'],
              'description': element.data()['description'],
              'emailAddress': element.data()['emailAddress'],
              'tags': [],
              'timeStamp': element.data()['timeStamp'],
              'userName': element.data()['userName'],
            };
            FirebaseFirestore.instance
                .collection('group')
                .doc('akshaya')
                .collection('expense')
                .doc(element.id)
                .set(data)
                .whenComplete(() {
              print('devil call success');
            });
          }
        }
      });
    }
  }
}
