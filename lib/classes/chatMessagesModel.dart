import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String id;
  String messageContent;
  String userId;
  DateTime timeStamp;
  String jobId;
  ChatMessage(
      {this.id = "",
      required this.messageContent,
      required this.userId,
      required this.timeStamp,
      required this.jobId});

  static ChatMessage fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    return ChatMessage(
        id: snap.id,
        messageContent: data["messageContent"] ?? "",
        userId: data["userId"] ?? "",
        timeStamp: data["timeStamp"].toDate(),
        jobId: data["jobId"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "messageContent": messageContent,
      "userId": userId,
      "timeStamp": timeStamp,
      "jobId": jobId
    };
  }
}
