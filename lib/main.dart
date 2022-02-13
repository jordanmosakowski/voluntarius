import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/user.dart';
import 'package:voluntarius/firebase_options.dart';
import 'package:voluntarius/pages/home.dart';
import 'package:voluntarius/pages/chat.dart';
import 'package:voluntarius/pages/jobs.dart';
import 'package:voluntarius/pages/map.dart';
import 'package:voluntarius/pages/profile.dart';
import 'package:voluntarius/pages/request.dart';
import 'package:voluntarius/pages/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'classes/job.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  int _selectedIndex = 0;
  @override
  static const List<Widget> _widgetOptions = <Widget>[
    MapPage(),
    JobsPage(),
    ProfilePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        StreamProvider<User?>.value(
            value: FirebaseAuth.instance.authStateChanges(), initialData: null),
      ],
      child: MaterialApp(
        title: 'Voluntarius',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          // textTheme: GoogleFonts.poppinsTextTheme(
          //   Theme.of(context)
          //       .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
          // ),
        ),
        home: Builder(builder: (context) {
          User? user = Provider.of<User?>(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Voluntarius",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600)),
              leading: new Image(
                  image: AssetImage('assets/whitetransparentbk.png'),
                  height: 30,
                  width: 50),
            ),
            body: Builder(
              builder: (context) {
                if (user == null) {
                  return SignInPage();
                }
                Stream<UserData> userData = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots()
                    .map((snap) => UserData.fromFirestore(snap));
                return MultiProvider(
                  providers: [
                    StreamProvider<LocationData>.value(
                      initialData: LocationData.fromMap(
                          {"latitude": 0.0, "longitude": 0.0}),
                      value: locationStream,
                    ),
                    StreamProvider<UserData>.value(
                        initialData: UserData(
                            id: "",
                            name: "",
                            notificationTokens: [],
                            averageStars: 0,
                            numReviews: 0),
                        value: userData),
                    StreamProvider<List<Job>>.value(
                        initialData: [],
                        value: FirebaseFirestore.instance
                            .collection("jobs")
                            .where("requestorId", isEqualTo: user.uid)
                            .snapshots()
                            .map((snap) => snap.docs
                                .map((doc) => Job.fromFirestore(doc))
                                .toList())),
                    StreamProvider<List<Claim>>.value(
                        initialData: [],
                        value: FirebaseFirestore.instance
                            .collection("claims")
                            .where("userId", isEqualTo: user.uid)
                            .snapshots()
                            .map((snap) => snap.docs
                                .map((doc) => Claim.fromFirestore(doc))
                                .toList()))
                  ],
                  child: _widgetOptions.elementAt(_selectedIndex),
                );
              },
            ),
            bottomNavigationBar: user != null
                ? BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.map), label: 'Local Jobs'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.list), label: 'Current Jobs'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.account_circle), label: 'Account'),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.green[800],
                    onTap: _onItemTapped,
                  )
                : null,
          );
        }),
      ),
    );
  }
}
