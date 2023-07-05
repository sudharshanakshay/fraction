class GroupModel {
  List<dynamic> groupMembers;

  GroupModel({required this.groupMembers});

  GroupModel.fromJson(Map<String, Object?> json)
      : this(
          groupMembers: (json['groupMembers']! as List).cast<String>(),
        );

  Map<String, dynamic> toMap() {
    return {'groupName': groupMembers};
  }

  Map<String, dynamic> toJson() {
    return {'groupName': groupMembers};
  }

  Iterable<Object?> toList() {
    return groupMembers as Iterable<Object>;
  }

  @override
  String toString() {
    return 'Group{groupName: $groupMembers}';
  }
}
