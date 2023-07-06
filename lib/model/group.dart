class GroupModel {
  String groupName;
  List<Object> groupMembers;

  GroupModel({required this.groupMembers, required this.groupName});

  GroupModel.fromJson(Map<String, Object?> json)
      : this(
          groupName: json['groupName']! as String,
          groupMembers: (json['groupMembers']! as List<Map<String, dynamic>>)
              .cast<String>(),
        );

  Map<String, dynamic> toMap() {
    return {'groupName': groupName, 'groupMembers': groupMembers};
  }

  Map<String, dynamic> toJson() {
    return {'groupName': groupName, 'groupMembers': groupMembers};
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

  Iterable<Object?> toList() {
    return groupMembers;
  }

  @override
  String toString() {
    return 'Group{groupName: $groupName, groupMember: $groupMembers}';
  }
}
