import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/widgets/info.dart';

class InfoPage extends StatefulWidget {
  const InfoPage(this.jobId, { Key? key }) : super(key: key);
  final String jobId;

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  Job? job;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).get().then((doc) {
      if (doc.exists) {
        setState(() {
          job = Job.fromFirestore(doc);
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    User? userData = Provider.of<User?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(job?.title ?? 'Info',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
      ),
      body: job!=null ? ListView(
        children: [
          info(j: job!),
          ElevatedButton(
            onPressed: () async {
              Claim claim = Claim(
                  id: "",
                  jobId: job!.id,
                  userId: userData!.uid,
                  approved: false,
                  completed: false);
              await FirebaseFirestore.instance
                  .collection("claims")
                  .add(claim.toJson());
              Navigator.of(context).pop();
            },
            child: Text("Apply"))
        ],
      ) : Container()
    );
  }
}