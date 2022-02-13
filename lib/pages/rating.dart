import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voluntarius/classes/user.dart';

import '../classes/claim.dart';
import '../classes/job.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key, required this.j}) : super(key: key);
  final Job j;
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RatingPage> {
  void initState() {
    super.initState();
    loadVolunteers();
  }

  Icon star = Icon(Icons.star_border_outlined);
  int rating = 4;
  List<Claim> claims = [];
  List<UserData> volunteers = [];
  Future<void> loadVolunteers() async {
    claims = (await FirebaseFirestore.instance
            .collection("claims")
            .where("jobId", isEqualTo: widget.j.id)
            .get())
        .docs
        .map((doc) => Claim.fromFirestore(doc))
        .toList();
    setState(() {});
    for (int i = 0; i < claims.length; i++) {
      UserData data = UserData.fromFirestore(await FirebaseFirestore.instance
          .collection("users")
          .doc(claims[i].userId)
          .get());
      claims[i].userData = data;
      volunteers[i] = data;
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate Volunteer"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Text("Hello"), //USER NAME
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (int i = 0; i < 5; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      rating = i;
                    });
                  },
                  iconSize: 80,
                  icon: Icon(
                      rating >= i ? Icons.star : Icons.star_border_outlined),
                  alignment: Alignment.center,
                ),
              )
          ]),
        ],
      ),
    );
  }
}

class QuerySnapshot {}
