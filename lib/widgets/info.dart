import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/widgets/text_field.dart';

import '../pages/chat.dart';

class info extends StatelessWidget {
  const info({
    Key? key,
    required this.j,
  }) : super(key: key);

  final Job j;
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Description: " + j.description),
          Text("Hours Required: " + j.hoursRequired.toString()),
          Text("People Required: " + j.peopleRequired.toString()),
          Text("Appointment Time: " + j.appointmentTime.toString()),
          IconButton(
            onPressed: (){
              String url = "https://example.com";
              if(!kIsWeb){
                Share.share(url);
              }
              else{
                Clipboard.setData(ClipboardData(text: url));
                final snackBar = SnackBar(
                  content: const Text('Copied URL to Clipboard'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(Icons.ios_share)
          )
        ],
      );
  }
}