const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.processClaim = functions.firestore
    .document('claim/{id}')
    .onCreate(async(snap, context) => {
        const newValue = snap.data();
        const jobId = newValue.jobId;
        const jobsRef = db.collection('job').doc(jobId);
        const job = await jobsRef.get();

        if (!job.exists){
            console.log('Job not found');
        }else{
            const requestorId = job.data().requestorId;
            const userRef = db.collection('user').doc(requestorId);
            const user = await userRef.get();

            if(!user.exists){
                console.log('User not found');
            }else{
                const message = {
                    data: {
                        title: 'Job '+job.data().title+' Accepted',
                        body: 'Click to view and approve respondants'
                    },
                    tokens: user.data().notificationTokens
                };
        
                admin.messaging().sendMulticast(message)
                .then((response) => {
                    console.log(response.succesCount+" messages sent succesfully");
                })
            }
        }
    });