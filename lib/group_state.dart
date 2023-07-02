import 'package:flutter/material.dart';
import 'package:fraction/database/profile.database.dart';
import 'package:fraction/model/profile.dart';

import 'database/group.database.dart';

class GroupState extends ChangeNotifier {
  GroupState() {
    // init();
  }
  final _currentUserGroupNames = '';
  String get currentUserGroupNames => _currentUserGroupNames;
  // String _currentUserEmail = '';
  // String get currentUserEmail => _currentUserEmail;

  // init() async {
  //   await getGroupNamesFromLocalDatabase()
  //       .then((ProfileModel profileModel) {
  //   });
  // }
}
