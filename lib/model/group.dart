class GroupModel {
  String _groupName;
  Map<String, dynamic> _groupMembers;

  String get groupName => _groupName;
  Map<String, dynamic> get groupMembers => _groupMembers;

  GroupModel(
      {required String groupName, required Map<String, dynamic> groupMembers})
      : _groupMembers = groupMembers,
        _groupName = groupName;

  GroupModel.fromJson(Map<String, Object?> json)
      : this(
          groupName: json['groupName']! as String,
          groupMembers: (json['groupMembers']! as Map<String, dynamic>),
        );

  Map<String, dynamic> toMap() {
    return {'groupName': _groupName, 'groupMembers': _groupMembers};
  }

  Map<String, dynamic> toJson() {
    return {
      'groupName': _groupName,
      'groupMembers': _groupMembers['groupMembers']
    };
  }

  Map<String, dynamic> toMemberEmails() {
    List memberEmailsList = [];
    for (Map<String, dynamic> memberObj in toMap()['groupMembers']) {
      print('---- memberEmailList ----');
      print(memberObj);
      memberEmailsList.add(memberObj['userEmail']);
    }
    return {'memberEmails': memberEmailsList};
  }

  List<dynamic> toMemberEmailsList() {
    List memberEmailsList = [];
    for (Map<String, dynamic> memberObj in toMap()['groupMembers']) {
      memberEmailsList.add(memberObj['userEmail']);
    }
    return memberEmailsList;
  }

  List toList() {
    List memberObjList = [];
    _groupMembers.forEach((key, value) {
      memberObjList.add(value);
    });

    return memberObjList;
  }

  @override
  String toString() {
    return 'Group:{groupName: $_groupName, groupMember: $_groupMembers}';
  }
}
