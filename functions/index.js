const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.announcement = functions.firestore
    .document("announcements/{docId}")
    .onCreate((snapshot, context) => {
      const newValue = snapshot.data();

      const topicId = newValue["topicId"];
      const storeName = newValue["storeName"];

      const notificationBody = newValue["message"];

      const payload = {
        notification: {
          title: storeName,
          body: notificationBody,
        },
        data: {
          body: notificationBody,
        },
      };

      admin.messaging().sendToTopic(topicId, payload);
    });
