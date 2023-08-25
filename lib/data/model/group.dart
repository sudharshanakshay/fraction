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

  List toMemberEmailsList() {
    List memberEmailList = [];
    _groupMembers.forEach((key, value) {
      memberEmailList.add(value['memberEmail']);
    });

    return memberEmailList;
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
