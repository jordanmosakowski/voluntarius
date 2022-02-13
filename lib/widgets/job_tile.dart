import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/classes/user.dart';

class JobTile extends StatelessWidget {
  const JobTile({
    Key? key,
    required this.c,
    required this.job,
    required this.dist,
  }) : super(key: key);
  final int c;
  final Job job;
  final double dist;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.green[c],
      title: Text(job.title),
      subtitle: Text("Distance: " + dist.toString() + " mi"),
      trailing: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext) => _buildPopupDialog(context),
            );
          },
          child: Text("More Info")),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    User? userData = Provider.of<User?>(context);
    return AlertDialog(
      title: Text(job.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Description: " + job.description),
          Text("Hours Required: " + job.hoursRequired.toString()),
          Text("People Required: " + job.peopleRequired.toString()),
          Text("Appointment Time: " + job.appointmentTime.toString())
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Done")),
        ElevatedButton(
            onPressed: () async {
              Claim claim = Claim(
                  id: "", jobId: job.id, userId: userData!.uid, approved: false);
              await FirebaseFirestore.instance
                  .collection("claims")
                  .add(claim.toJson());
              Navigator.of(context).pop();
            },
            child: Text("Accept"))
      ],
    );
  }
}
