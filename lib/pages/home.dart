import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/classes/user.dart';
import 'package:voluntarius/pages/jobs.dart';
import 'package:voluntarius/pages/map.dart';
import 'package:voluntarius/pages/profile.dart';
import 'package:voluntarius/pages/sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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


  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
          User? user = Provider.of<User?>(context);
          return Scaffold(
            appBar: user != null ? AppBar(
              title: const Text("Voluntarius",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600)),
              leading: new Image(
                  image: AssetImage('assets/whitetransparentbk.png'),
                  height: 30,
                  width: 50),
            ) : null,
            body: SafeArea(
              child: Builder(
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
                      StreamProvider<UserData>.value(
                          initialData: UserData(
                              id: "",
                              name: "",
                              notificationTokens: [],
                              averageStars: 0,
                              hasProfilePic: false,
                              numReviews: 0),
                          value: userData),
                      StreamProvider<List<Job>>.value(
                          initialData: [],
                          value: FirebaseFirestore.instance
                              .collection("jobs")
                              .where("requestorId", isEqualTo: user.uid).where("completed", isEqualTo: false)
                              .snapshots()
                              .map((snap) => snap.docs
                                  .map((doc) => Job.fromFirestore(doc))
                                  .toList())),
                      StreamProvider<List<Claim>>.value(
                          initialData: [],
                          value: FirebaseFirestore.instance
                              .collection("claims")
                              .where("userId", isEqualTo: user.uid).where("completed", isEqualTo: false)
                              .snapshots()
                              .map((snap) => snap.docs
                                  .map((doc) => Claim.fromFirestore(doc))
                                  .toList()))
                    ],
                    child: _widgetOptions.elementAt(_selectedIndex),
                  );
                },
              ),
            ),
            bottomNavigationBar: user != null
                ? BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.map), label: 'Find Jobs'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.list), label: 'My Jobs'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.account_circle), label: 'Account'),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.green[800],
                    onTap: _onItemTapped,
                  )
                : null,
          );
        });
  }
}
