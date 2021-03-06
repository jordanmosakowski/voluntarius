import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/main.dart';
import 'package:voluntarius/widgets/text_field.dart';

import '../pages/chat.dart';
import 'info.dart';

class ClmTile extends StatelessWidget {
  const ClmTile({
    Key? key,
    required this.c,
    required this.j,
    required this.cl,
  }) : super(key: key);
  final int c;
  final Job j;
  final Claim cl;
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
          // tileColor:

          subtitle: Text("Due "+DateFormat.yMMMMd('en_US').add_jm().format(j.appointmentTime)),
          title: Text(j.title),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext) => _buildPopupDialog(context, j),
            );
          },

          trailing: cl.approved
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          router.navigateTo(context, "/chat/${j.id}");
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => ChatPage(j)),
                          // );
                        },
                        icon: Icon(Icons.chat)),
                    IconButton(
                      onPressed: () async => await FirebaseFirestore.instance
                          .collection("claims")
                          .doc(cl.id)
                          .delete(),
                      icon: Icon(Icons.close),
                    )
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Awaiting Approval"),
                    IconButton(
                      onPressed: () async => await FirebaseFirestore.instance
                          .collection("claims")
                          .doc(cl.id)
                          .delete(),
                      icon: Icon(Icons.close),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, Job job) {
    return AlertDialog(title: Text(job.title), content: info(j: job), actions: [
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Done")),
    ]);
  }
}
