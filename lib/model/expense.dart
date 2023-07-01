class ExpenseModel {
  String groupId;
  String emailId;
  String description;
  String cost;
  String timestamp;

  ExpenseModel(
      {required this.groupId,
      required this.emailId,
      required this.description,
      required this.cost,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'emailId': emailId,
      'description': description,
      'cost': cost,
      'timestamp': timestamp
    };
  }

  @override
  String toString() {
    return '''
      Expense{ 
        groupId: $groupId, 
        emailId:$emailId, 
        description: $description, 
        cost: $cost,
        timestamp: $timestamp
        }
    ''';
  }
}
