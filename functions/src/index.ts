import {
  onDocumentCreated,
  // onDocumentDeleted,
  // onDocumentUpdated,
  onDocumentWritten,
} from "firebase-functions/v2/firestore";
import {setGlobalOptions} from "firebase-functions/v2";
import {initializeApp} from "firebase-admin/app";
import {FieldValue, getFirestore} from "firebase-admin/firestore";
import {onCall} from "firebase-functions/v2/https";

setGlobalOptions({maxInstances: 10});

initializeApp();

const db = getFirestore();

// when an expense is modified
// 1. make changes to "members" sub-collection in "group" collection
exports.expenseWritten =
onDocumentWritten("expense/{groupName}/{groupInstance}/{expenseDocId}",
  (event) => {
    const document = event.data?.after.data();
    const previousValues = event.data?.before.data();
    const groupName = event.params.groupName;

    if (previousValues == undefined && document != undefined) {
      // new expense has been created.
      const expenseCost = document["cost"];
      const emailAddress = document["emailAddress"];

      // update 'members' collection doc with
      const updateGroupMemberData = {
        "memberExpense": FieldValue.increment(expenseCost),
      };
      db.doc("group/"+groupName+"/members/"+emailAddress)
        .set(updateGroupMemberData, {merge: true});

      // update 'group' collection's 'totalExpense' &
      // last expense for faster retrival.
      const updateGroupDocWith = {
        "totalExpense": FieldValue.increment(expenseCost),
        "lastUpdatedDesc": document.description,
        "lastUpdatedTime": document.timeStamp,
      };
      db.doc("group/"+groupName)
        .set(updateGroupDocWith, {merge: true});
    } else if (document == undefined && previousValues != undefined) {
      // existing expense has been deleted.
      // use previous data "previousValues".

      const expenseCost = previousValues["cost"];
      const emailAddress = previousValues["emailAddress"];

      // update 'members' collection doc with
      const updateGroupMemberData = {
        "memberExpense": FieldValue.increment(-expenseCost),
      };
      db.doc("group/"+groupName+"/members/"+emailAddress)
        .set(updateGroupMemberData, {merge: true});

      // update 'group' collection's 'totalExpense' &
      // last expense for faster retrival.
      const updateGroupDocWith = {
        "totalExpense": FieldValue.increment(-expenseCost),
        "lastUpdatedDesc": "deleted",
        "lastUpdatedTime": Date.now(),
      };
      db.doc("group/"+groupName)
        .set(updateGroupDocWith, {merge: true});
    } else if (document != undefined && previousValues != undefined) {
      // expense has been updated.
      const emailAddress = previousValues["emailAddress"];

      const previousExpenseCost = previousValues["cost"];
      const updatedExpenseCost = document["cost"];

      // check if there is any change in the cost.
      if (previousExpenseCost - updatedExpenseCost != 0) {
        const updateGroupMemberData = {
          "memberExpense": FieldValue
            .increment(updatedExpenseCost-previousExpenseCost),
        };

        db.doc("group/"+groupName+"/members/"+emailAddress)
          .set(updateGroupMemberData, {merge: true});
      }

      // update 'group' collection's 'totalExpense' &
      // last expense for faster retrival.
      const updateGroupDocWith = {
        "totalExpense": FieldValue
          .increment(updatedExpenseCost-previousExpenseCost),
        "lastUpdatedDesc": document?.description,
        "lastUpdatedTime": Date.now(),
      };
      db.doc("group/"+groupName)
        .set(updateGroupDocWith, {merge: true});
    }

    return "ok";
  });

// ---- when a group collection is create,
//  what happens to groupMembers collection? ----

exports.onChatGroupIsCreated =
onDocumentCreated("group/{groupName}", (event)=>{
  const snapShot = event.data;
  if (!snapShot) {
    console.log("No data associated with the event");
    return;
  }

  const data = snapShot.data();

  // const chatUpdateWith = {
  //   "groupName": data.groupName,
  //   "lastUpdatedDesc": "new group",
  //   "lastUpdatedTime": data.createdOn,
  //   "totalGroupExpense": data.totalExpense
  // };

  const groupMemberRelation = {
    "groupId": event.params.groupName,
    "userId": data.createdBy,
    "role": "admin",
  };

  db.collection("groupMembers").add(groupMemberRelation);
  // .set(chatUpdateWith, {merge: true});
});

// ---- when a group collection is updated,
// what happens to groupMembers collection ----

// exports.onExpenseGroupIsUpdated = onDocumentUpdated("", (event){});

// ---- when a group collection is deleted,
//  what happens to groupMembers collection ----


// when an expense has been deleted
// 1. make changes to "members" sub-collection in "group" collection
// exports.expenseDeleted =
// onDocumentDeleted("expense/{groupName}/{expenseInstance}/{expenseDocId}",
//   (event) => {
//     const groupName = event.params.groupName;
//     const snapShot = event.data?.data();

//     if (snapShot != undefined) {
//       const expenseCost = snapShot["cost"];
//       const emailAddress = snapShot["emailAddress"];

//       const updateGroupMemberData = {
//         "memberExpense": FieldValue.increment(-expenseCost),
//       };

//       db.doc("group/"+groupName+"/members/"+emailAddress)
//         .set(updateGroupMemberData, {merge: true});
//     }
//   });

// when an expense has been updated
// 1.

exports.groupClearUpOnDeleteByAdmin = onCall((request)=>{
  const groupNameToDelete = request.data.groupName;

  db.doc("group/"+groupNameToDelete).delete();
});
