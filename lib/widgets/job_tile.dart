import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/classes/user.dart';

import 'info.dart';

class JobTile extends StatefulWidget {
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
  State<JobTile> createState() => _JobTileState();
}

class _JobTileState extends State<JobTile> {
  String? image = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(widget.job.requestorId).get();
    if (snapshot.exists && (snapshot.data() as Map<String,dynamic>)['hasProfilePic'] == true){
      String url = await FirebaseStorage.instance
        .ref('pictures/${widget.job.requestorId}')
        .getDownloadURL();
        if(mounted){
          setState(() => image = url);
        }
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green[widget.c],
          ),
        child: ListTile(
          leading: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: (image!=null) ? NetworkImage(
                        image!
                      ) : (AssetImage("assets/defaultProfile.png") as ImageProvider)
                ),
            ),
          ),
          onTap: widget.onTap,
          title: Text(widget.job.title),
          // subtitle: Text("Distance: " + widget.dist.toString() + " km"),
          subtitle: Text("Due "+DateFormat.yMMMMd('en_US').add_jm().format(widget.job.appointmentTime)),
          trailing: ElevatedButton(
              onPressed: widget.openPopup,
              child: Text("More Info")),
        ),
      ),
    );
  }
}
