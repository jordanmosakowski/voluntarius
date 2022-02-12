import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/user.dart';

import '../widgets/text_field.dart';

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
                 showDialog(context: context,
           builder: (BuildContext)=> _buildPopupDialog(context,userData.name,userData.id),);
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
    Widget _buildPopupDialog(BuildContext context, String cName, String uid){
       final nameController = TextEditingController(text: cName);
    return  AlertDialog(
      title: Text("Enter New Name"),
      content:  Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
             VoluntariusTextField("Full Name", controller: nameController,),
        ],
      ),
      actions: [
         TextButton(onPressed: (){
          Navigator.of(context).pop();
        },
         child: const Text("Cancel")
         ),
         ElevatedButton(onPressed: () async{
          await FirebaseFirestore.instance.collection("users").doc(uid).update({
            "name": nameController.text
          });
          Navigator.of(context).pop();  
        },
         child: const Text("Submit")
         ),
      ],
    );
  }
  
}