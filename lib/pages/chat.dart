// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/classes/user.dart';

import '../classes/chatMessagesModel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(this.jobId, {Key? key}) : super(key: key);
  final String jobId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // List<ChatMessage> messages = [];

  final fieldText = TextEditingController();
  final ScrollController _controller = ScrollController();
  var temporaryString = " ";
  var myFocusNode = FocusNode();

  void makeUserMessage(String a, String uid, String name) {
    if (a != "") {
      FirebaseFirestore.instance.collection('messages').add(ChatMessage(
            messageContent: a,
            userId: uid,
            userName: name,
            timeStamp: DateTime.now(),
            jobId: widget.jobId,
          ).toJson());
      fieldText.clear();
      temporaryString = "";
    }
    myFocusNode.requestFocus();
  }

  updateMessage(value) {
    temporaryString = value;
  }

  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("messages")
        .where("jobId", isEqualTo: widget.jobId)
        .orderBy("timeStamp")
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList())
        .asBroadcastStream();
    stream.listen((a) {
      Future.delayed(Duration(milliseconds: 50), () {
        if (_controller.hasClients) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        }
      });
    });
    //Load job
    FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          job = Job.fromFirestore(doc);
        });
      }
    });
  }

  late Stream<List<ChatMessage>> stream;

  Job? job;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return MultiProvider(
      providers: [
        StreamProvider<List<ChatMessage>>.value(initialData: [], value: stream),
        StreamProvider<UserData>.value(
            initialData: UserData(
                id: "",
                name: "",
                hasProfilePic: false,
                notificationTokens: [],
                averageStars: 0,
                numReviews: 0),
            value: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .snapshots()
                .map((snap) => UserData.fromFirestore(snap)))
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: <Widget>[
              Text(job?.title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Builder(
                builder: (context) {
                  List<ChatMessage> messages =
                      Provider.of<List<ChatMessage>>(context);
                  UserData userData = Provider.of<UserData>(context);
                  print(messages.length);
                  return ListView.builder(
                    controller: _controller,
                    itemCount: messages.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 60),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 5, bottom: 5),
                        child: Align(
                          alignment: (messages[index].userId != userData.id
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (messages[index].userId != userData.id)
                                Text(
                                    '   ${messages[index].userName}     ${DateFormat.jm('en_US').format(messages[index].timeStamp)}',
                                    style: TextStyle(fontSize: 16)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: (messages[index].userId != userData.id
                                      ? Colors.grey.shade200
                                      : Colors.green[200]),
                                ),
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                constraints: BoxConstraints(maxWidth: 1000),
                                child: Text(
                                  messages[index].messageContent,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Builder(builder: (context) {
                return Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontSize: 24,
                            ),
                            expands: false,
                            autofocus: true,
                            controller: fieldText,
                            focusNode: myFocusNode,
                            onSubmitted: (value) {
                              Future.delayed(Duration(milliseconds: 10), () {
                                UserData userData =
                                    Provider.of<UserData>(context, listen: false);
                                makeUserMessage(
                                    value, userData.id, userData.name);
                              });
                            },
                            onChanged: (value) {
                              updateMessage(value);
                            },
                            decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            UserData userData =
                                Provider.of<UserData>(context, listen: false);
                            makeUserMessage(
                                temporaryString, userData.id, userData.name);
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: Colors.green,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
