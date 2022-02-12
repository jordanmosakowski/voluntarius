import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String id;
  List<String> notificationTokens;
  double averageStars;
  int numReviews;
  String name;

  UserData(
      {required this.id,
      required this.name,
      required this.notificationTokens,
      required this.averageStars,
      required this.numReviews});

  static UserData fromFirestore(DocumentSnapshot snap){
    Map<String,dynamic> data = snap.data() as Map<String, dynamic>;
    return UserData(
      id: snap.id,
      name: data['name'],
      notificationTokens: data['notificationTokens'].cast<String>(),
      averageStars: data['averageStars'].toDouble(),
      numReviews: data['numReviews']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'notificationTokens': notificationTokens,
      'averageStars': averageStars,
      'numReviews': numReviews,
      "name": name,
    };
  }
}
