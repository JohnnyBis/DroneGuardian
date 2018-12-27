const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendMissionNotification = functions.firestore.document("Missions/{mission}").onCreate((docSnap, context) => {

    const pilotUid = docSnap.data()['Pilot'];
    console.log(pilotUid);

    return admin.firestore().doc('Users/' + pilotUid).get().then(pilotDoc => {
      const token = pilotDoc.get("Token");
      console.log(token);

      const payload = {
        notification: {
          title: "New mission!",
          body: "You have a new mission from a client. Open the app now.",
          icon: "default",
          sound : "default"
        }
      }

      return admin.messaging().sendToDevice(token, payload).then(response => {
        return console.log(response.results[0].error);
      })
    })
})
