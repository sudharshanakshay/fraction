class ProfileModel {
  String currentUserName;
  String currentUserEmail;

  ProfileModel({required this.currentUserName, required this.currentUserEmail});

  Map<String, dynamic> toMap() {
    return {
      'currentUserName': currentUserName,
      'currentUserEmail': currentUserEmail,
    };
  }

  @override
  String toString() {
    return 'Profile{currentUserName: $currentUserName, currentUserEmail: $currentUserEmail}';
  }
}