import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userData.name, 
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
                  print(userData.name);
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star),
              Text(
                " ${userData.averageStars} (${userData.numReviews} reviews)",
                style: TextStyle(
                  fontSize: 17
                )
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
              }, 
              child: Text("Sign Out")
            )
          )
        ],
      ),
    );
  }
}