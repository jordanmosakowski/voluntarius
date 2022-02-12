import 'package:location/location.dart';

class Jobs {
  String descriptions;
  String requestor_UID;
  int hours_required;
  int people_required;
  int urgency;
  int credit_to_earn;
  DateTime appointment_time;
  Location location;

  Jobs({
    required this.descriptions,
    required this.requestor_UID,
    required this.hours_required,
    required this.people_required,
    required this.urgency,
    required this.credit_to_earn,
    required this.appointment_time,
    required this.location,
  });
}
