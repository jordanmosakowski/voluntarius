importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyCNsDYDw56cKNPymyLSQd737RVjR2HxVyM",
    authDomain: "voluntarius-h4h.firebaseapp.com",
    projectId: "voluntarius-h4h",
    storageBucket: "voluntarius-h4h.appspot.com",
    messagingSenderId: "432059990875",
    appId: "1:432059990875:web:5fb4e7c054806b2be6d07e",
    measurementId: "G-MWNQ1WHR0H"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});