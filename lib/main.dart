import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/user.dart';
import 'package:voluntarius/firebase_options.dart';
import 'package:voluntarius/pages/home.dart';
import 'package:voluntarius/pages/chat.dart';
import 'package:voluntarius/pages/map.dart';
import 'package:voluntarius/pages/profile.dart';
import 'package:voluntarius/pages/request.dart';
import 'package:voluntarius/pages/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    ChatPage(),
    ProfilePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context)
                .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
          ),
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text("Voluntarius")),
          body: Builder(
            builder: (context) {
              User? user = Provider.of<User?>(context);
              if (user == null) {
                return ChatPage();
              }
              Stream<UserData> userData = FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots()
                  .map((snap) => UserData.fromFirestore(snap));
              return MultiProvider(
                providers: [
                  StreamProvider<UserData>.value(
                      initialData: UserData(
                          id: "",
                          name: "",
                          notificationTokens: [],
                          averageStars: 0,
                          numReviews: 0),
                      value: userData)
                ],
                child: _widgetOptions.elementAt(_selectedIndex),
              );
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
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
          ),
        ),
      ),
    );
  }
}
