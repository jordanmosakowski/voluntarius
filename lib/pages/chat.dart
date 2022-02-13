// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/user.dart';

import '../classes/chatMessagesModel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // List<ChatMessage> messages = [];

  final fieldText = TextEditingController();
  var temporaryString = " ";
  var myFocusNode = FocusNode();
  var myUserID = "12345"; // GET USER ID!!!!

  void makeUserMessage(String a, String uid) {
    if (a != "") {
      FirebaseFirestore.instance.collection('messages').add(ChatMessage(
            messageContent: a,
            userId: uid,
            timeStamp: DateTime.now(),
            jobId: 'test',
          ).toJson());
      // setState(() {
      //   messages.add(ChatMessage(messageContent: a, userID: myUserID));
      // });
      fieldText.clear();
      temporaryString = "";
    }
    myFocusNode.requestFocus();
  }

  updateMessage(value) {
    temporaryString = value;
  }

  makeFriendMessage(String input) {
    setState(() {
      // messages.add(ChatMessage(
      //     messageContent: input,
      //     userId: "INCOMING USER ID!!!!!",
      //     jobId: '',
      //     timeStamp: DateTime.now())); //GET SENDER ID
    });
  }

  @override
  Widget build(BuildContext context) {
    User? userData = Provider.of<User?>(context);
    return MultiProvider(
      providers: [
        StreamProvider<List<ChatMessage>>.value(
            initialData: [],
            value: FirebaseFirestore.instance
                .collection("messages")
                .where("jobId", isEqualTo: "test")
                .orderBy("timeStamp")
                .snapshots()
                .map((snap) => snap.docs
                    .map((doc) => ChatMessage.fromFirestore(doc))
                    .toList()))
      ],
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Builder(
              builder: (context) {
                List<ChatMessage> messages =
                    Provider.of<List<ChatMessage>>(context);
                print(messages.length);
                return ListView.builder(
                  itemCount: messages.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 60),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 14, right: 14, top: 5, bottom: 5),
                      child: Align(
                        alignment: (messages[index].userId != userData!.uid
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: (messages[index].userId != userData!.uid
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
                      ),
                    );
                  },
                );
              },
            ),
            Align(
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
                        expands: false,
                        autofocus: true,
                        controller: fieldText,
                        focusNode: myFocusNode,
                        onSubmitted: (value) {
                          Future.delayed(Duration(milliseconds: 10), () {
                            makeUserMessage(value, userData!.uid);
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
                        makeUserMessage(temporaryString, userData!.uid);
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
            ),
          ],
        ),
      ),
    );
  }
}
