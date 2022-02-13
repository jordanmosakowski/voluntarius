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
    const claimsRef = db.collection('claims').where('jobId', '==', jobId);
    const claims = await claimsRef.get();

    const job = (await db.collection('jobs').doc(jobId).get()).data();
    if(userId != job.requestorId){
        const userRef = db.collection('users').doc(job.requestorId);
        const user = await userRef.get();
        const message = {
            data: {
                title: 'New Message in '+job.title,
                body: newValue.messageContent
            },
            notification: {
                title: 'New Message in '+job.title,
                body: newValue.messageContent
            },
            tokens: user.data().notificationTokens
        };

        admin.messaging().sendMulticast(message)
        .then((response) => {
            console.log(response.successCount+" messages sent succesfully");
        });
    }

    claims.forEach(async (claim) => {
        const user = claim.data().userId;
        const approved = claim.data().approved;

        if(approved && user!=userId){
            const userRef = db.collection('users').doc(user);
            const userInfo = await userRef.get();
            const message = {
                data: {
                    title: 'New Message in '+job.title,
                    body: newValue.messageContent
                },
                notification: {
                    title: 'New Message in '+job.title,
                    body: newValue.messageContent
                },
                tokens: userInfo.data().notificationTokens
            };

            admin.messaging().sendMulticast(message)
            .then((response) => {
                console.log(response.successCount+" messages sent succesfully");
            });
        }
    });
});

exports.processRating= functions.firestore
.document('ratings/{id}')
.onCreate(async(snap, context) => {
    const newValue = snap.data();
    const userId = newValue.ratedId;
    const userRef = db.collection('users').where('id', '==', userId);
    const user = await userRef.get();

    const currRating = user.data().ratings;
    const numReviews = user.data().numReviews;
    user.data().ratings = (newValue.rating+currRating)/(numReviews+1);
});