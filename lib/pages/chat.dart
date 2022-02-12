// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../classes/chatMessagesModel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> messages = [];

  final fieldText = TextEditingController();
  var temporaryString = " ";
  var myFocusNode = FocusNode();
  var myUserID = "12345"; // GET USER ID!!!!

  void makeUserMessage(String a) {
    if (a != "") {
      setState(() {
        messages.add(ChatMessage(messageContent: a, userID: myUserID));
      });
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
      messages.add(ChatMessage(
          messageContent: input,
          userID: "INCOMING USER ID!!!!!")); //GET SENDER ID
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 60),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].userID != myUserID
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].userID != myUserID
                          ? Colors.grey.shade200
                          : Colors.green[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      messages[index].messageContent,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
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
                      autofocus: true,
                      controller: fieldText,
                      focusNode: myFocusNode,
                      onSubmitted: (value) {
                        Future.delayed(Duration(milliseconds: 10), () {
                          makeUserMessage(value);
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
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      makeUserMessage(temporaryString);
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
    );
  }
}
