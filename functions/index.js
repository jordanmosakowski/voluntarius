const functions = require("firebase-functions");

exports.processClaim = functions.firestore
    .document('claim/{id}')
    .onCreate(async(snap, context) => {
        const newValue = snap.data();
        const jobId = newValue.jobId;
        const jobsRef = db.collection('job').doc(jobId);
        const job = await jobsRef.get();

        if (!job.exists) {
            console.log('Job not found');
        } else {
            const requestorId = job.data().requestorId;
            const userRef = db.collection('user').doc(requestorId);
            const user = await userRef.get();

            if(!user.exists){
                console.log('User not found');
            }

            tokens = user.data().notificationTokens;

            for(i=0; i<tokens.length(); i++)
                const message = {
                    data: {
                        title: 'Claim accepted',
                        body: 'Someone accepted your job request!'
                    },
                    token: tokens[i]
                };
        
                getMessaging().send(message)
                .then((response) => {
                    console.log('Successfully sent message:', response);
                })
                .catch((error) => {
                    console.log('Error sending message:', error);
                }); 
        }
    });