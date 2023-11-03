import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/utils/constants.dart';

class FeedbackFormServices {
  late FirebaseFirestore _firebaseFirestore;

  FeedbackFormServices() {
    _firebaseFirestore = FirebaseFirestore.instance;
  }

  Future<String> addFeedback({required String feedback}) async {
    final data = {'feedback': feedback.trim()};

    return _firebaseFirestore.collection('feedbacks').add(data).then((value) {
      return Constants().success;
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      return Constants().failed;
    });
  }
}
