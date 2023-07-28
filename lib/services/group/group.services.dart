import 'dart:async';
import 'package:fraction/app_state.dart';
import 'package:fraction/database/group.database.dart';

class GroupServices extends ApplicationState {
  Future<void> joinCloudGroup({required newGroupName}) async {
    GroupDatabase()
        .insertMemberToGroup(
            currentGroupName: super.currentUserGroup,
            memberName: super.currentUserName,
            memberEmail: super.currentUserEmail)
        .whenComplete(() {
      GroupDatabase().insertGroupNameToProfile(
          currentUserEmail: super.currentUserEmail,
          groupNameToAdd: newGroupName);
    });
  }

  Future<void> createGroup(
      {required inputGroupName, required clearOffIntervalInDays}) async {
    try {
      GroupDatabase()
          .createGroup(
              groupName: inputGroupName,
              adminName: super.currentUserName,
              adminEmail: super.currentUserEmail,
              clearOffIntervalInDays: clearOffIntervalInDays)
          .then((String groupNameCreatedWithIdentity) {
        GroupDatabase().insertGroupNameToProfile(
            currentUserEmail: super.currentUserEmail,
            groupNameToAdd: groupNameCreatedWithIdentity);
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List?> getMemberDetails() {
    try {
      return GroupDatabase()
          .getMemberDetails(currentUserGroup: super.currentUserGroup);
    } catch (e) {
      return const Stream.empty();
    }
  }
}
