import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/classes/user.dart';

class Claim {
  String jobId;
  String userId;
  bool approved;
  bool completed;
  Job? job;
  UserData? userData;
  String id;
  double? hours;

  Claim(
      {required this.id,
      required this.jobId,
      required this.userId,
      required this.approved,
      required this.completed,
      this.hours,
      this.job});

  static Claim fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    Claim newClaim = Claim(
      id: snap.id,
      approved: data['approved'] ?? false,
      completed: data['completed'] ?? false,
      userId: data['userId'] ?? "",
      jobId: data['jobId'] ?? "",
      hours: (data['hours'] ?? 0).toDouble(),
    );
    // print(newClaim.jobId);
    return newClaim;
  }

  Future<void> getJob() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("jobs").doc(jobId).get();
    print("Claimed job");
    job = Job.fromFirestore(snapshot);
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'userId': userId,
      'approved': approved,
      'completed': completed,
      'hours': hours
    };
  }
}
