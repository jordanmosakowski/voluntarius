import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/widgets/text_field.dart';

class ReqTile extends StatelessWidget {
  const ReqTile({
    Key? key,
    required this.c,
    required this.j,
  }) : super(key: key);
  final int c;
  final Job j;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.green[c],
      title: Text(j.title),
      trailing: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext) => _buildJobPopupDialog(context),
            );
          },
          child: Text("Options")),
    );
  }

  Widget _buildJobPopupDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Job"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text("Title: " + j.title),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext) => _buildNestedPopupDialog(
                          context, j.title, j.id, "title", j),
                    );
                  },
                  child: Icon(Icons.edit)),
            ],
          ),
          Row(
            children: [
              Text("Description: " + j.description),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext) => _buildNestedPopupDialog(
                          context, j.description, j.id, "description", j),
                    );
                  },
                  child: Icon(Icons.edit)),
            ],
          ),
          Row(
            children: [
              Text("Hours Required: " + j.hoursRequired.toString()),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext) => _buildNestedPopupDialog(
                          context,
                          j.hoursRequired.toString(),
                          j.id,
                          "hoursRequired",
                          j),
                    );
                  },
                  child: Icon(Icons.edit)),
            ],
          ),
          Row(
            children: [
              Text("People Required: " + j.peopleRequired.toString()),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext) => _buildNestedPopupDialog(
                          context,
                          j.peopleRequired.toString(),
                          j.id,
                          "peopleRequired",
                          j),
                    );
                  },
                  child: Icon(Icons.edit)),
            ],
          ),

          // ElevatedButton(onPressed: onPressed, child: child)(child: Text("Hours Required: " + j.hoursRequired.toString())),
          // ElevatedButton(onPressed: onPressed, child: child)(child: Text("People Required: " + j.peopleRequired.toString())),
          // ElevatedButton(onPressed: onPressed, child: child)(child: Text("Appointment Time: " + j.appointmentTime.toString()))
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Done"))
      ],
    );
  }

  Widget _buildNestedPopupDialog(
      BuildContext context, String fieldval, String jid, String prop, Job _j) {
    final nameController = TextEditingController(text: fieldval);

    return AlertDialog(
      title: Text('Enter New ${prop[0].toUpperCase()}${prop.substring(1)}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VoluntariusTextField(
            'new ${prop}',
            controller: nameController,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("jobs")
                  .doc(jid)
                  .update({
                "${prop}": (double.tryParse(nameController.text) != null)
                    ? double.tryParse(nameController.text)
                    : nameController.text
              });
              Navigator.of(context).pop();
              Navigator.of(context).pop();

              ///sdiufgsd9ugfiu
            },
            child: const Text("Submit")),
      ],
    );
  }
}
