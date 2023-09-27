import {
  onDocumentCreated,
  // onDocumentUpdated,
  onDocumentWritten,
} from "firebase-functions/v2/firestore";
import {setGlobalOptions} from "firebase-functions/v2";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";

setGlobalOptions({maxInstances: 10});

initializeApp();

const db = getFirestore();

exports.expenseTrigger =
onDocumentWritten("expense/{groupName}/{groupInstance}/{expenseDocId}",
  (change) => {
    const data = change.data?.after.data();
    // const previousData = change.data?.before.data();

    // group & chat collections need to updated whenever expense doc is changed.

    // update group.groupMembers.memberExpense
    // const emailAddress = data?.emailAddress;
    const groupName = change.params.groupName;
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
      .set({"lastExpenseId": change.params.expenseDocId}, {merge: true});

    console.log("---- doc updated trigger ----");
    return "ok";
  });
// ---- when a chat-group is create,
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

// ---- when a chat-group is updated,
// what happens to groupMembers collection ----

// exports.onExpenseGroupIsUpdated = onDocumentUpdated("", (event){});

// ---- when a chat-group is deleted,
//  what happens to groupMembers collection ----
