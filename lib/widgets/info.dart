import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
    return Container(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Description", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(j.description),
            Text("Hours Required", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(j.hoursRequired.toString()),
            Text("Number of People", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(j.peopleRequired.toString()),
            Text("Approximate Date & Time", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(DateFormat.yMMMMd('en_US').add_jm().format(j.appointmentTime)),



            // Text("Description: " + j.description.toString()),
            // Text("Hours Required: " + j.hoursRequired.toString()),
            // Text("People Required: " + j.peopleRequired.toString()),
            // Text("Appointment Time: " + DateFormat.yMMMMd('en_US').add_jm().format(j.appointmentTime)),
            // IconButton(
            //   onPressed: () async{
            //     final DynamicLinkParameters parameters = DynamicLinkParameters(
            //     uriPrefix: 'https://my-awesome-app.page.link',
            //     link: Uri.parse('https://voluntarius.web.app/info/${j.id}'),
            //     androidParameters: const AndroidParameters(
            //       packageName: "com.example.voluntarius",
            //       minimumVersion: 1,
            //     ),
            //     iosParameters: const IOSParameters(
            //       bundleId: "app.web.voluntarius",
            //       minimumVersion: '1',
            //     ),
            //   );

            //     final Uri uri = await FirebaseDynamicLinks.instance.buildLink(parameters);
            //     String url = uri.toString();
            //     if(!kIsWeb){
            //       Share.share(url);
            //     }
            //     else{
            //       Clipboard.setData(ClipboardData(text: url));
            //       final snackBar = SnackBar(
            //         content: const Text('Copied URL to Clipboard'),
            //       );
            //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //     }
            //   },
            //   icon: Icon(Icons.ios_share)
            // )
          ],
        ),
    );
  }
}