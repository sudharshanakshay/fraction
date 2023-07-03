class GroupModel {
  List<dynamic> groupNames;

  GroupModel({required this.groupNames});

  Map<String, dynamic> toMap() {
    return {'groupName': groupNames};
  }

  @override
  String toString() {
    return 'Group{groupName: $groupNames}';
  }
}
