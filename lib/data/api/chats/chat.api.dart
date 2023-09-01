import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/data/api/utils/database.utils.dart';
import 'package:fraction/utils/tools.dart';

// create = create
// update = update
// read = get
// delete = delete

class ChatApi extends DatabaseUtils {
  late CollectionReference _chatcollectionRef;

  ChatApi() {
    _chatcollectionRef =
        FirebaseFirestore.instance.collection(chatsCollectionName);
  }

  Future<void> createChat(
      {required String currentUserEmail,
      required String newChatNameThatIsNewGroupNameId}) async {
    final data = {
      'groupName':
          Tools().sliptElements(element: newChatNameThatIsNewGroupNameId)[0],
      'lastExpenseDesc': 'null',
      // 'lastExpenseTime': Timestamp,
      'totalGroupExpense': 0
    };
    _chatcollectionRef
        .doc(currentUserEmail)
        .collection(chatsCollectionName)
        .doc(newChatNameThatIsNewGroupNameId)
        .set(data);
  }

  Stream<QuerySnapshot> getChatsCollection({required String currentUserEmail}) {
    return _chatcollectionRef
        .doc(currentUserEmail)
        .collection(chatsCollectionName)
        .snapshots();
  }

  Future<void> updateLastExpense(
      {required String currentUserEmail,
      required String chatNameThatIsGroupNameId,
      required String lastExpenseDesc,
      required Timestamp lastExpenseTime,
      required int totalGroupCost}) async {
    final data = {
      'groupName': Tools().sliptElements(element: chatNameThatIsGroupNameId)[0],
      'lastExpenseDesc': lastExpenseDesc,
      'lastExpenseTime': lastExpenseTime,
      'totalGroupExpense': totalGroupCost
    };
    _chatcollectionRef
        .doc(currentUserEmail)
        .collection(chatsCollectionName)
        .doc(chatNameThatIsGroupNameId)
        .update(data);
  }

  Future<void> deleteChat(
      {required String currentUserEmail, required String chatNameDocId}) async {
    _chatcollectionRef
        .doc(currentUserEmail)
        .collection(chatsCollectionName)
        .doc(chatNameDocId);
  }

  Future<void> initChatCollection({required String currentUserEmail}) async {
    final currentUserEmailR = currentUserEmail.replaceAll('.', '#');
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final listOfMyGroups = _firebaseFirestore
        .collection('group')
        .where('groupMembers.$currentUserEmailR', isNull: false)
        .get()
        .then((value) {
      for (var element in value.docs) {
        // createChat(
        //     currentUserEmail: currentUserEmail,
        //     newChatNameThatIsNewGroupNameId: element.id);
        // print(element.data()['expenseInstance'].toDate().toString());
        _firebaseFirestore
            .collection('expense')
            .doc(element.id)
            .collection(element.data()['expenseInstance'].toDate().toString())
            .orderBy('timeStamp', descending: true)
            .limit(1)
            .get()
            .then((lastExpenseOfIteratingGroup) {
          // print(lastExpenseOfIteratingGroup.docs);
          // print('\n');
          if (lastExpenseOfIteratingGroup.docs.isNotEmpty) {
            updateLastExpense(
                currentUserEmail: currentUserEmail,
                chatNameThatIsGroupNameId: element.id,
                lastExpenseDesc:
                    lastExpenseOfIteratingGroup.docs[0].data()['description'],
                lastExpenseTime: Timestamp.now(),
                totalGroupCost: element.data()['totalExpense']);
          } else {
            print('---- lastExpenseOfIteratingGroup doc empty ----');
          }
        });

        // updateLastExpense(currentUserEmail: currentUserEmail,
        //  chatNameThatIsGroupName: element.data()['groupName'], lastExpenseDesc: lastExpenseDesc, lastExpenseTime: lastExpenseTime, totalGroupCost: totalGroupCost)

        // print(element.id);
        // print('\n');
      }
    });

    // for (var element in listOfMyGroups) {
    //   print(element);
    // }
  }
}
