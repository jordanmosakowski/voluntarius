import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/user.dart';
import 'package:voluntarius/firebase_options.dart';
import 'package:voluntarius/pages/home.dart';
import 'package:voluntarius/pages/chat.dart';
import 'package:voluntarius/pages/info.dart';
import 'package:voluntarius/pages/jobs.dart';
import 'package:voluntarius/pages/map.dart';
import 'package:voluntarius/pages/profile.dart';
import 'package:voluntarius/pages/rating.dart';
import 'package:voluntarius/pages/request.dart';
import 'package:voluntarius/pages/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluro/fluro.dart';
import 'classes/job.dart';
import 'package:url_strategy/url_strategy.dart';

final router = FluroRouter();

void main() async {
  Handler chatHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return ChatPage(params["id"][0]);
  });
  Handler infoHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return InfoPage(params["id"][0]);
  });
  Handler homeHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return HomePage();
  });
  Handler requestHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return RequestPage();
  });

  router.define("/", handler: homeHandler);
  router.define("/request", handler: requestHandler);
  router.define("/chat/:id", handler: chatHandler);
  router.define("/info/:id", handler: infoHandler);
  router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return HomePage();
    });

  WidgetsFlutterBinding.ensureInitialized();
  // if(!kIsWeb){
  //   final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  // }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  // setPathUrlStrategy();

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Location location = Location();

  late Stream<LocationData>? locationStream;

  @override
  initState() {
    super.initState();
    locationStream = location.onLocationChanged.asBroadcastStream();
    location.getLocation();
    locationStream!.listen((LocationData? l) {
      print("location updated ${l?.latitude} ${l?.longitude}");
    });
  }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<LocationData>.value(
          initialData: LocationData.fromMap(
              {"latitude": 37.34759885104362, "longitude": -121.93787108112451}),
          value: locationStream,
        ),
        StreamProvider<User?>.value(
            value: FirebaseAuth.instance.authStateChanges(), initialData: null),
      ],
      child: MaterialApp(
        onGenerateRoute: router.generator,
        title: 'Voluntarius',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          // textTheme: GoogleFonts.poppinsTextTheme(
          //   Theme.of(context)
          //       .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
          // ),
        ),
      )
    );
  }
}