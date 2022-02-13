import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voluntarius/classes/rating.dart';
import 'package:voluntarius/classes/user.dart';

import '../classes/claim.dart';
import '../classes/job.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key, required this.j}) : super(key: key);
  final Job j;
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  void initState() {
    super.initState();
    loadVolunteers();
  }

  Icon star = Icon(Icons.star_border_outlined);
  List<Claim> claims = [];
  List<int> ratings = [];
  List<TextEditingController> hours = [];
  Future<void> loadVolunteers() async {
    claims = (await FirebaseFirestore.instance
            .collection("claims")
            .where("jobId", isEqualTo: widget.j.id)
            .get())
        .docs
        .map((doc) => Claim.fromFirestore(doc))
        .toList();
    ratings = List.filled(claims.length,3,growable: true);
    hours = [];
    for(Claim c in claims){
      hours.add(TextEditingController(text: widget.j.hoursRequired.toString()));
    }
    setState(() {});
    for (int i = 0; i < claims.length; i++) {
      UserData data = UserData.fromFirestore(await FirebaseFirestore.instance
          .collection("users")
          .doc(claims[i].userId)
          .get());
      claims[i].userData = data;
    }
    setState(() {});
  }

  void submit() async{

    User? user = FirebaseAuth.instance.currentUser;
    for(int i = 0; i < this.claims.length; i++){
      Rating rating = Rating(
        id: "", raterId: user!.uid,
        ratedId: claims[i].userId, rating: ratings[i].toDouble(),
      );
      await FirebaseFirestore.instance.collection("ratings").add(rating.toJson());
      //update the claim with the hours
      await FirebaseFirestore.instance.collection("claims").doc(claims[i].id).update({
        "hours": (double.tryParse(hours[i].text) ?? 0) + 1,
        "completed": true,
      });
      await FirebaseFirestore.instance.collection("jobs").doc(widget.j.id).update({
        "completed": true,
      });
    }
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate Volunteer"),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: ListView(
          children: [ //USER NAME
            for(int j=0; j<claims.length; j++)
              Column(
                children: [
                  Text(claims[j].userData?.name ?? "", style: TextStyle(fontSize: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      for (int i = 0; i < 5; i++)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              ratings[j] = i;
                            });
                          },
                          iconSize: 20,
                          icon: Icon(
                            ratings[j] >= i ? Icons.star : Icons.star_border_outlined,
                            color: ratings[j]>=i ? Colors.yellow[700] : Colors.grey,
                          ),
                          alignment: Alignment.center,
                        )
                      ]),
                  TextField(
                    controller: hours[j],
                    decoration: InputDecoration(
                      labelText: "Hours",
                      hintText: "Hours",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  Divider(),
                ],
              ),
            ElevatedButton(
              onPressed: submit, child: Text("Submit")
              )
            
          ],
        ),
      ),
    );
  }
}