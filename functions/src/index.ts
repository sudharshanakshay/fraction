import {
  onDocumentCreated,
  // onDocumentDeleted,
  // onDocumentUpdated,
  onDocumentWritten,
} from "firebase-functions/v2/firestore";
import {setGlobalOptions} from "firebase-functions/v2";
import {initializeApp} from "firebase-admin/app";
import {FieldValue, getFirestore} from "firebase-admin/firestore";

setGlobalOptions({maxInstances: 10});

initializeApp();

const db = getFirestore();

// when an expense is modified
// 1. make changes to "members" sub-collection in "group" collection
exports.expenseWritten =
onDocumentWritten("expense/{groupName}/{groupInstance}/{expenseDocId}",
  (event) => {
    const data = event.data?.after.data();
    const document = event.data?.after.data();
    const previousValues = event.data?.before.data();


    if (previousValues == undefined) {
      // new expense has been created.

    } else if (document == undefined) {
      // existing expense has been deleted.
      // use previous data "previousValues".

      const groupName = event.params.groupName;

      const expenseCost = previousValues["cost"];
      const emailAddress = previousValues["emailAddress"];

      const updateGroupMemberData = {
        "memberExpense": FieldValue.increment(-expenseCost),
      };

      db.doc("group/"+groupName+"/members/"+emailAddress)
        .set(updateGroupMemberData, {merge: true});
    } else {
      // expense has been updated.
    }

    // const previousData = change.data?.before.data();

    // group & chat collections need to updated whenever expense doc is changed.

    // update group.groupMembers.memberExpense
    // const emailAddress = data?.emailAddress;
    const groupName = event.params.groupName;
    // const memberEmail = emailAddress.replace(".", "#");

    // const groupUpdataData = {
    //   "groupMembers"  : {
    //   }
    // };

    // db.doc("group/"+groupName).set({});

    const chatUpdateWith = {
      "lastUpdatedDesc": data?.description,
      "lastUpdatedTime": data?.timeStamp,
    };

    console.log(chatUpdateWith);

    // db.doc("chat/"+emailAddress+"/chat/"+groupName)
    //   .set(chatUpdateWith, {merge: true});

    db.doc("group/"+groupName)
      .set({"lastExpenseId": event.params.expenseDocId}, {merge: true});

    console.log("---- doc updated trigger ----");
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
