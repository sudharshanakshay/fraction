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
      {required inputGroupName, required nextClearOffTimeStamp}) async {
    try {
      GroupDatabase()
          .createGroup(
              groupName: inputGroupName,
              adminName: super.currentUserName,
              adminEmail: super.currentUserEmail,
              nextClearOffTimeStamp: nextClearOffTimeStamp)
          .then((String groupNameCreatedWithIdentity) {
        GroupDatabase().insertGroupNameToProfile(
            currentUserEmail: super.currentUserEmail,
            groupNameToAdd: groupNameCreatedWithIdentity);
      });
    } catch (e) {
      print(e);
    }
  }

  Stream getGroupDetials() {
    try {
      return GroupDatabase().getGroupDetials(groupName: super.currentUserGroup);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Stream getMyExpense() {
    try {
      return GroupDatabase().getMyExpense(
          currentUserEmail: super.currentUserEmail,
          groupName: super.currentUserGroup);
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future<List?> getMemberDetails() {
    try {
      return GroupDatabase()
          .getMemberDetails(currentUserGroup: super.currentUserGroup);
    } catch (e) {
      return Future.value();
    }
  }
}
