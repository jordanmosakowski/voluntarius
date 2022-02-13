import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/job.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

/*
User can click button to create a new listing
Submitted to Cloud Firestore Database with following data:
Location
Urgency (today, next 3 days, this week, this month)
Title (enforce a character limit)
Longer Description
Document/picture upload?
Estimated time to complete
Requestor ID (grab Firebase UID)
*/
class _RequestPageState extends State<RequestPage> {
  Job? job;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.cyan),
        body: Container(
          child: Column(
            children: [reqForm()],
          ),
        ));
  }
}

class reqForm extends StatefulWidget {
  @override
  _reqFormState createState() => _reqFormState();
}

class _reqFormState extends State<reqForm> {
  String title = "";
  String description = "";
  String requestorId = "";
  int hoursRequired = 0;
  int peopleRequired = 0;
  String urgency = "";
  Location location = new Location();
  LocationData? locationData;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  GeoFirePoint? fireloc;
  bool dateset = false, locset = false;
  init() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.fromDateTime(selectedDate);
  }

  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter Job Title',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'enter text';
                }
                return null;
              },
              onChanged: (value) => setState(() {
                title = value;
                print(value);
              }),
              inputFormatters: [new LengthLimitingTextInputFormatter(25)],
            ),
            TextFormField(
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Enter job description',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'enter text';
                }
                return null;
              },
              onChanged: (value) => setState(() {
                description = value;
                print(value);
              }),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                hintText: 'hours required',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'enter number';
                }
                return null;
              },
              onChanged: (value) =>
                  setState(() => hoursRequired = int.parse(value)),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                hintText: 'Enter people required',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'enter number';
                }
                return null;
              },
              onChanged: (value) =>
                  setState(() => peopleRequired = int.parse(value)),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text("Choose Date"),
              ),
              Text("Selected Date: $selectedDate!"),
            ]),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'urgency',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'enter text';
                }
                return null;
              },
              onChanged: (value) => setState(() => urgency = value),
              inputFormatters: [new LengthLimitingTextInputFormatter(25)],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _setPlace(context);
                          print("set loc");
                        },
                        child: Text("set location"),
                      ),
                      Text(
                          "location: ${locationData?.longitude ?? 0},${locationData?.latitude ?? 0}!"),
                    ])),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        //submit
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              dateset &&
                              locset) {
                            _makeJob(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          } else {
                            print('dateset:${(dateset) ? "true" : "false"}');
                            print('locset:${(locset) ? "true" : "false"}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('incomplete form')),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ])),
          ],
        ));
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
      _selectTime(context);
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? selected =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (selected != null && selected != selectedTime)
      setState(() {
        selectedTime = selected;
        String dt = selectedDate.toString();
        String d = dt.substring(0, dt.indexOf(' '));
        String t = selectedTime.toString();
        t = t.substring(t.indexOf('(') + 1, t.length - 1);
        t = "${t}:00";
        selectedDate = DateTime.parse('${d} ${t}');
        dateset = true;
      });
  }

  _setPlace(BuildContext context) async {
    final LocationData? loc = await location.getLocation();
    print('longitude:${loc!.longitude}');
    if (loc != null && locationData != loc) {
      setState(() {
        locationData = loc;
        locset = true;
      });
    }
  }

  _makeJob(BuildContext context) async {
    User? user = Provider.of<User?>(context, listen: false);
    final fireloc =
        GeoFirePoint(locationData?.latitude ?? 0, locationData?.longitude ?? 0);
    final Job rjob = Job(
        id: "",
        title: title,
        description: description,
        requestorId: user?.uid ?? "",
        hoursRequired: hoursRequired,
        peopleRequired: peopleRequired,
        urgency: urgency,
        appointmentTime: selectedDate,
        location: fireloc);
    await FirebaseFirestore.instance.collection('jobs').add(rjob.toJson());
    print("Done");
  }
}
