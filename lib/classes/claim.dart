import 'package:cloud_firestore/cloud_firestore.dart';

class Claim {
  String jobId;
  String userId;
  bool approved;
  String id;

  Claim({required this.id, required this.jobId, required this.userId, required this.approved});

  static Claim fromFirestore(DocumentSnapshot snap){
    Map<String,dynamic> data = snap.data() as Map<String, dynamic>;
    return Claim(
      id: data['id'],
      approved: data['approved'] ?? false,
      userId: data['userId'] ?? "",
      jobId: data['jobId'] ?? ""
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'jobId': jobId,
      'userId': userId,
      'approved': approved
    };
  }
}
