const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

exports.processClaim = functions.firestore
    .document('claims/{id}')
    .onCreate(async(snap, context) => {
        const newValue = snap.data();
        const jobId = newValue.jobId;
        const jobsRef = db.collection('jobs').doc(jobId);
        const job = await jobsRef.get();

        if (!job.exists){
            console.log('Job not found');
        }else{
            const requestorId = job.data().requestorId;
            const userRef = db.collection('users').doc(requestorId);
            const user = await userRef.get();

            if(!user.exists){
                console.log('User not found');
            }else{
                console.log(user.data().notificationTokens.toString());
                const message = {
                    data: {
                        title: 'Job "'+job.data().title+'" Accepted',
                        body: 'Click to view and approve respondants'
                    },
                    notification: {
                        title: 'Job "'+job.data().title+'" Accepted',
                        body: 'Click to view and approve respondants'
                    },
                    tokens: user.data().notificationTokens
                };
        
                admin.messaging().sendMulticast(message)
                .then((response) => {
                    console.log(response.successCount+" messages sent succesfully");
                })
            }
        }
    });

exports.processChat = functions.firestore
.document('messages/{id}')
.onCreate(async(snap, context) => {
    const newValue = snap.data();
    const userId = newValue.userId;
    const jobId = newValue.jobId;
    const claimsRef = db.collection('claims').doc(jobId);
    const claim = await claimsRef.get();

    if (!claim.exists){
        console.log('Claim not found');
    }else{
        const user = job.data().userId;
        const requestorId = job.data().requestorId;
        const approved = job.data().approved;

        if(approved && user!=userId){
            console.log(user.data().notificationTokens.toString());
            const message = {
                data: {
                    title: 'New Message in '+job.data().title,
                    body: 'Click to view new messages'
                },
                notification: {
                    title: 'New Message in '+job.data().title,
                    body: 'Click to view new messages'
                },
                tokens: user.data().notificationTokens
            };
    
            admin.messaging().sendMulticast(message)
            .then((response) => {
                console.log(response.successCount+" messages sent succesfully");
            })
        }

        if(userId != requestorId){
            console.log(requestorId.data().notificationTokens.toString());
            const message = {
                data: {
                    title: 'New Message in '+job.data().title,
                    body: 'Click to view new messages'
                },
                notification: {
                    title: 'New Message in '+job.data().title,
                    body: 'Click to view new messages'
                },
                tokens: user.data().notificationTokens
            };
    
            admin.messaging().sendMulticast(message)
            .then((response) => {
                console.log(response.successCount+" messages sent succesfully");
            })
        }
    }
});