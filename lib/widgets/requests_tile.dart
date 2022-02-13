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

  List<Claim> claims = [];

  Future<void> loadVolunteers() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("claims")
        .where("jobId", isEqualTo: widget.j.id)
        .get();
    setState(() {
      claims = query.docs.map((doc) => Claim.fromFirestore(doc)).toList();
    });
    for (int i = 0; i < claims.length; i++) {
      UserData data = UserData.fromFirestore(await FirebaseFirestore.instance
          .collection("users")
          .doc(claims[i].userId)
          .get());
      claims[i].userData = data;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.j.title),
      subtitle: Text(widget.j.description),
      children: <Widget>[
        //dropdowns
        ListTile(
          ///CHATTT
          // tileColor: Colors.green[widget.c],
          title: Text("Chat"),
          leading: Icon(Icons.chat),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage(widget.j)),
            );
          },
        ),
        ListTile(
          //chat!!
          // tileColor: Colors.green[widget.c],
          title: Text("Volunteers"),
          leading: Icon(Icons.person),
          // isThreeLine: true,
          subtitle: Column(children: [
            ...claims.map((Claim claim) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(children: [
                    Text(claim.userData?.name ?? claim.userId),
                    Container(width: 10),
                    if (!claim.approved)
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.green,
                          ),
                          padding: EdgeInsets.all(3.0),
                          child: Text(
                            " Approve ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection("claims")
                              .doc(claim.id)
                              .update({"approved": true});
                          setState(() {
                            claim.approved = true;
                            print("Appoved");
                          });
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.green,
                          ),
                          padding: EdgeInsets.all(3.0),
                          child: Text(
                            claim.approved ? " Remove " : " Reject ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection("claims")
                              .doc(claim.id)
                              .delete();
                          setState(() {
                            claims.remove(claim);
                            print("Removed");
                          });
                        },
                      ),
                    ),
                  ]),
                ))
          ]),
        ),
        ExpansionTile(
          // tileColor: Colors.green[widget.c],
          title: Text("Options"),
          leading: Icon(Icons.settings),
           children: [
          Row(
            children: [
             
              IconButton(
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
                  icon: Icon(Icons.edit)),
                   Text("Title: " + widget.j.title),
            ],
          ),
          Row(
            children: [
             
              IconButton(
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
                 icon: Icon(Icons.edit)),
                   Text("Description: " + widget.j.description),
            ],
          ),
          Row(
            children: [
             
              IconButton(
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
                  icon: Icon(Icons.edit)),
                   Text("Hours Required: " + widget.j.hoursRequired.toString()),
            ],
          ),
          Row(
            children: [
             
              IconButton(
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
                  icon: Icon(Icons.edit)),
                   Text("People Required: " + widget.j.peopleRequired.toString()),
            ],
          ),
           ]
        ),
       ListTile(
          ///CHATTT
          // tileColor: Colors.green[widget.c],
          title: Text("Comptete Job"),
          leading: Icon(Icons.check_box),

          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => completePage;),
            // );
          },
        ),
      ],
    );
  }

  Widget _buildJobPopupDialog(BuildContext context) {
    return ExpansionTile(
      title: Text("Edit Job"),
       
          // ElevatedButton(onPressed: onPressed, child: child)(child: Text("Hours Required: " + j.hoursRequired.toString())),
          // ElevatedButton(onPressed: onPressed, child: child)(child: Text("People Required: " + j.peopleRequired.toString())),
          // ElevatedButton(onPressed: onPressed, child: child)(child: Text("Appointment Time: " + j.appointmentTime.toString()))
      
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

              ///sdiufgsd9ugfiu
            },
            child: const Text("Submit")),
      ],
    );
  }
}
