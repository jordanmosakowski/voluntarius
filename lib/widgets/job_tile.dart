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
    required this.onTap,
    required this.c,
    required this.job,
    required this.dist,
    required this.openPopup,
  }) : super(key: key);
  final int c;
  final Job job;
  final double dist;
  final VoidCallback onTap;
  final VoidCallback openPopup;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green[c],
          ),
        child: ListTile(
          onTap: onTap,
          title: Text(job.title),
          subtitle: Text("Distance: " + dist.toString() + " km"),
          trailing: ElevatedButton(
              onPressed: openPopup,
              child: Text("More Info")),
        ),
      ),
    );
  }
}
