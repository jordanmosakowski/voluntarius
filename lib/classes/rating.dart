import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  String reviewerId;
  String revieweeId;
  double rating;
  String text;
  String id;

  Rating(
      {
      required this.id,  
      required this.reviewerId,
      required this.revieweeId,
      required this.rating,
      required this.text
      });
  
  static Rating fromFirestore(DocumentSnapshot snap){
    Map<String,dynamic> data = snap.data() as Map<String, dynamic>;
    return Rating(
      id: snap.id,
      reviewerId: data['reviewerId'],
      revieweeId: data['revieweeId'],
      rating: data['rating'],
      text: data['text']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
      'rating': rating,
      'text': text
    };
  }
}
