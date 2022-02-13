import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/classes/user.dart';
import 'package:voluntarius/pages/chat.dart';
import 'package:voluntarius/widgets/text_field.dart';

class ReqTile extends StatefulWidget {
  const ReqTile({
    Key? key,
    required this.c,
    required this.j,
  }) : super(key: key);
  final int c;
  final Job j;

  @override
  _ReqTileState createState() => _ReqTileState();
}

class _ReqTileState extends State<ReqTile> {
  @override
  void initState() {
    super.initState();
    loadVolunteers();
  }

  List<UserData> userData = [];

  Future<void> loadVolunteers() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("claims")
        .where("jobId", isEqualTo: widget.j.id)
        .get();
    List<Claim> claims =
        query.docs.map((doc) => Claim.fromFirestore(doc)).toList();
    for (int i = 0; i < claims.length; i++) {
      UserData data = UserData.fromFirestore(await FirebaseFirestore.instance
          .collection("users")
          .doc(claims[i].userId)
          .get());
      userData.add(data);
    }
    setState(() {
      print(userData.map((u) => u.name).join("\n"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.j.title),
      children: <Widget>[
        //dropdowns
        ListTile(
          ///CHATTT
          // tileColor: Colors.green[widget.c],
          title: Text("Chat"),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage(widget.j.id)),
            );
          },
        ),
        ListTile(
          //chat!!
          // tileColor: Colors.green[widget.c],
          title: Text("Volunteers"),
          // isThreeLine: true,
          subtitle: Text(userData.map((d) => d.name).join("\n")),
        ),
        ListTile(
          // tileColor: Colors.green[widget.c],
          title: Text("Options"),
          onTap: () => _buildJobPopupDialog(context),
        )
      ],
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
              Text("Title: " + widget.j.title),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext) => _buildNestedPopupDialog(
                          context,
                          widget.j.title,
                          widget.j.id,
                          "title",
                          widget.j),
                    );
                  },
                  child: Icon(Icons.edit)),
            ],
          ),
          Row(
            children: [
              Text("Description: " + widget.j.description),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext) => _buildNestedPopupDialog(
                          context,
                          widget.j.description,
                          widget.j.id,
                          "description",
                          widget.j),
                    );
                  },
                  child: Icon(Icons.edit)),
            ],
          ),
          Row(
            children: [
              Text("Hours Required: " + widget.j.hoursRequired.toString()),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext) => _buildNestedPopupDialog(
                          context,
                          widget.j.hoursRequired.toString(),
                          widget.j.id,
                          "hoursRequired",
                          widget.j),
                    );
                  },
                  child: Icon(Icons.edit)),
            ],
          ),
          Row(
            children: [
              Text("People Required: " + widget.j.peopleRequired.toString()),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext) => _buildNestedPopupDialog(
                          context,
                          widget.j.peopleRequired.toString(),
                          widget.j.id,
                          "peopleRequired",
                          widget.j),
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
