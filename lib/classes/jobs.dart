import 'package:location/location.dart';

class Job {
  String descriptions;
  String requestorUID;
  int hoursRequired;
  int peopleRequired;
  int urgency;
  int creditsToEarn;
  DateTime appointmentTime;
  Location location;

  Job({
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
