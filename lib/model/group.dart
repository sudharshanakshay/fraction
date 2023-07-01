class Group {
  String? groupName;

  Group({required this.groupName});

  Map<String, dynamic> toMap() {
    return {'groupName': groupName};
  }

  @override
  String toString() {
    return 'Group{groupName: $groupName}';
  }
}
