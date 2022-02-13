import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  String userId;
  int rating;
  RatingModel({
    required this.userId,
    required this.rating,
  });

  static RatingModel fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    return RatingModel(
      userId: data["userId"] ?? "",
      rating: data["rating"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "rating": rating,
    };
  }
}
