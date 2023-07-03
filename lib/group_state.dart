import 'package:flutter/material.dart';
import 'package:fraction/model/group.dart';
import 'database/group.database.dart';

class GroupState extends ChangeNotifier {
  GroupState() {
    init();
  }
  final List<String> _groupNames = [];
  List<String> get groupNames =>
      _groupNames.isEmpty ? ['please create group'] : _groupNames;

  init() async {
    await getGroupNamesFromLocalDatabase()
        .then((GroupModel groupModel) => groupModel.groupNames);
  }
}
