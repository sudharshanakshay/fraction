import {onDocumentWritten} from "firebase-functions/v2/firestore";
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
    const emailAddress = data?.emailAddress;
    const groupName = change.params.groupName;
    // const memberEmail = emailAddress.replace(".", "#");

    // const groupUpdataData = {
    //   "groupMembers"  : {
    //   }
    // };

    // db.doc("group/"+groupName).set({});

    const chatUpdateWith = {
      "lastExpenseDesc": data?.description,
      "lastExpenseTime": data?.timeStamp,
    };

    console.log(chatUpdateWith);

    db.doc("chat/"+emailAddress+"/chat/"+groupName)
      .set(chatUpdateWith, {merge: true});

    console.log("---- doc updated trigger ----");
    return "ok";
  });
