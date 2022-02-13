import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
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
NOPAST
*/
class _RequestPageState extends State<RequestPage> {
  Job? job;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.green),
        body: SafeArea(child: reqForm()));
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
  Location location = new Location();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  GeoFirePoint? fireloc;
  bool dateset = false, locset = false;
  init() {
    super.initState();
    // _setPlace(context);
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.fromDateTime(selectedDate);
  }

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    LocationData locationData = Provider.of<LocationData>(context);
    return Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Job Title',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter text';
                  }

                  return null;
                },
                onChanged: (value) => setState(() {
                  title = value;
                  print(value);
                }),
                inputFormatters: [new LengthLimitingTextInputFormatter(25)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter job description',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter text';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  description = value;
                  print(value);
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Hours required',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter number';
                  }
                  return null;
                },
                onChanged: (value) =>
                    setState(() => hoursRequired = int.tryParse(value) ?? 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter people required',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter number';
                  }
                  return null;
                },
                onChanged: (value) =>
                    setState(() => peopleRequired = int.tryParse(value) ?? 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Approx. Date and Time: ",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 16),
                          child: InkWell(
                            child: Text(
                              '${DateFormat.yMMMMd('en_US').format(selectedDate)}',
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () => _selectDate(context),
                          ),
                        ),
                        Container(width: 30),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 16),
                          child: InkWell(
                            child: Center(
                                child: Text(
                              '${DateFormat.jm().format(selectedDate)}',
                              style: TextStyle(fontSize: 18),
                            )),
                            onTap: () => _selectTime(context),
                          ),
                        ),
                      ],
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center),
            ),
            // Padding(
            //     padding: const EdgeInsets.only(top: 20.0),
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           ElevatedButton(
            //             onPressed: () {
            //               //in the future set location with map view
            //               _setPlace(context);
            //               print("set loc");
            //             },
            //             child: Text("set location"),
            //           ),
            //           Text(
            //               "location: ${locationData?.longitude ?? 0},${locationData?.latitude ?? 0}!"),
            //         ])),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        //submit
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
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
                        child: const Text('Submit Request'),
                      ),
                    ])),
          ],
        ));
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        dateset = true;
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
    // final LocationData? loc = await location.getLocation();

    // print('longitude:${loc!.longitude}');
    // if (loc != null && locationData != loc) {
    //   setState(() {
    //     locationData = loc;
    //     locset = true;
    //   });
    // }
  }

  _makeJob(BuildContext context) async {
    User? user = Provider.of<User?>(context, listen: false);
    LocationData locationData =
        Provider.of<LocationData>(context, listen: false);
    final fireloc =
        GeoFirePoint(locationData.latitude ?? 0, locationData.longitude ?? 0);
        // GeoFirePoint(37.3520526,-121.942183);
    final Job rjob = Job(
        id: "",
        title: title,
        description: description,
        requestorId: user?.uid ?? "",
        hoursRequired: hoursRequired,
        peopleRequired: peopleRequired,
        completed: false,
        appointmentTime: selectedDate,
        location: fireloc);
    await FirebaseFirestore.instance.collection('jobs').add(rjob.toJson());
    Navigator.of(context).pop();
    print("Done");
  }
}
