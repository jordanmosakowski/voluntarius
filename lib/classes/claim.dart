import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voluntarius/classes/job.dart';

class Claim {
  String jobId;
  String userId;
  bool approved;
  Job? job;
  String id;

  Claim({required this.id, required this.jobId, required this.userId, required this.approved});

  static Claim fromFirestore(DocumentSnapshot snap, bool loadJob){
    Map<String,dynamic> data = snap.data() as Map<String, dynamic>;
    Claim newClaim = Claim(
      id: snap.id,
      approved: data['approved'] ?? false,
      userId: data['userId'] ?? "",
      jobId: data['jobId'] ?? ""
    );
    FirebaseFirestore.instance.collection("jobs").doc(newClaim.jobId).get().then((snapshot) => {
      newClaim.job = Job.fromFirestore(snapshot)
    });
    return newClaim;
  }

  Map<String,dynamic> toJson(){
    return {
      'jobId': jobId,
      'userId': userId,
      'approved': approved
    };
  }
}
