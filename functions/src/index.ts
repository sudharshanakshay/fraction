/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// import {onRequest} from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";
// import {onRequest} from "firebase-functions/v2/https";
import {onDocumentWritten} from "firebase-functions/v2/firestore";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request:any, response:any) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// trigger events expense is added.

exports.expenseTrigger =
onDocumentWritten("expense/{groupName}/{groupInstance}/{expenseDocId}",
  () => {
    return "hello, from expense trigger";
  });
