import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  String raterId;
  String ratedId;
  double rating;
  String text;
  String id;

  Rating(
      {required this.id,
      required this.raterId,
      required this.ratedId,
      required this.rating,
      required this.text});

  static Rating fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    return Rating(
        id: snap.id,
        raterId: data['raterId'],
        ratedId: data['ratedId'],
        rating: data['rating'],
        text: data['text']);
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewerId': raterId,
      'revieweeId': ratedId,
      'rating': rating,
      'text': text
    };
  }
}
