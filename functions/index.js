const functions = require("firebase-functions");

exports.processClaim = functions.firestore
    .document('claim/{id}')
    .onCreate((snap, context) => {
        const newValue = snap.data();
        const jobId = newValue.jobId;

        //on getting data https://firebase.google.com/docs/firestore/query-data/get-data

        const jobsRef = db.collection('job').doc(jobId);
        const doc = await jobsRef.get();

        if (!doc.exists) {
            console.log('No such document!');
        } else {
            console.log('Document data:', doc.data());
        }
    });

    /*
    const message = {
            data: {
                title: 'Claim accepted',
                body: 'Someone accepted your job request!'
            },
            token: registrationToken
        };

        getMessaging().send(message)
        .then((response) => {
            console.log('Successfully sent message:', response);
        })
        .catch((error) => {
            console.log('Error sending message:', error);
        }); 
*/
