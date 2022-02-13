import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String messageContent;
  String userID;
  DateTime timeStamp;
  String jobID;
  ChatMessage(
      {required this.messageContent,
      required this.userID,
      required this.timeStamp,
      required this.jobID});

  static ChatMessage fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    return ChatMessage(
        messageContent: data["messageContent"] ?? "",
        userID: data["userID"] ?? "",
        timeStamp: data["timeStamp"],
        jobID: data["jobID"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "messageContent": messageContent,
      "userID": userID,
      "timeStamp": timeStamp,
      "jobID": jobID
    };
  }
}
