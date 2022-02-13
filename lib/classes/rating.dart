import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  String raterId;
  String ratedId;
  double rating;
  String id;

  Rating(
      {required this.id,
      required this.raterId,
      required this.ratedId,
      required this.rating,});

  static Rating fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    return Rating(
        id: snap.id,
        raterId: data['raterId'],
        ratedId: data['ratedId'],
        rating: data['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewerId': raterId,
      'revieweeId': ratedId,
      'rating': rating,
    };
  }
}
