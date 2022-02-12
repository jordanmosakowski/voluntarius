import 'package:location/location.dart';

class Jobs {
  String descriptions;
  String requestorUID;
  int hoursRequired;
  int peopleRequired;
  int urgency;
  int creditsToEarn;
  DateTime appointmentTime;
  Location location;

  Jobs({
    required this.descriptions,
    required this.requestorUID,
    required this.hoursRequired,
    required this.peopleRequired,
    required this.urgency,
    required this.creditsToEarn,
    required this.appointmentTime,
    required this.location,
  });
}
