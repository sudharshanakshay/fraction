class GroupModel {
  List<String> groupName;

  GroupModel({required this.groupName});

  Map<String, dynamic> toMap() {
    return {'groupName': groupName};
  }

  @override
  String toString() {
    return 'Group{groupName: $groupName}';
  }
}
