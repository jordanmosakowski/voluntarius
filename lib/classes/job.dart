import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String id;
  String description;
  String requestorId;
  int hoursRequired;
  int peopleRequired;
  String urgency;
  DateTime appointmentTime;
  GeoFirePoint location;
  String title;

  Job(
      {required this.id,
      required this.description,
      required this.requestorId,
      required this.hoursRequired,
      required this.peopleRequired,
      required this.title,
      required this.urgency,
      required this.appointmentTime,
      required this.location});

  static Job fromFirestore(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    return Job(
        id: snap.id,
        description: data["description"] ?? "",
        requestorId: data["requestorId"] ?? "",
        hoursRequired: data["hoursRequired"] ?? 0,
        peopleRequired: data["peopleRequired"] ?? 0,
        urgency: data["urgency"] ?? "",
        title: data['title'] ?? "",
        //TODO: Fix this importing
        appointmentTime: data["appointmentTime"].toDate(),
        location: GeoFirePoint(
          data['location']['geopoint'].latitude,
          data['location']['geopoint'].longitude,
        ));
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "requestorId": requestorId,
      "hoursRequired": hoursRequired,
      "peopleRequired": peopleRequired,
      "urgency": urgency,
      "title": title,
      "appointmentTime": appointmentTime,
      "location": location.data
    };
  }
}
