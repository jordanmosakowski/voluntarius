import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  List<String> notificationTokens;
  double averageStars;
  int numReviews;

  User(
      {required this.id,
      required this.notificationTokens,
      required this.averageStars,
      required this.numReviews});

  static User fromFirestore(DocumentSnapshot snap){
    Map<String,dynamic> data = snap.data() as Map<String, dynamic>;
    return User(
      id: snap.id,
      notificationTokens: data['notificationTokens'],
      averageStars: data['averageStars'],
      numReviews: data['numReviews']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'notificationTokens': notificationTokens,
      'averageStars': averageStars,
      'numReviews': numReviews
    };
  }
}
