import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

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
  bool dateset = false;
  init() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.fromDateTime(selectedDate);
  }

  Widget build(BuildContext context) {
    return Form(
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
          onChanged: (value) => setState(() => title = value),
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
          onChanged: (value) => setState(() => description = value),
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
          onChanged: (value) => setState(() => hoursRequired = value as int),
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
          onChanged: (value) => setState(() => peopleRequired = value as int),
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
                    },
                    child: Text("set location"),
                  ),
                  Text(
                      "location: ${location.toString()},${location.toString()}!"),
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
      });
  }

  _setPlace(BuildContext context) async {
    final LocationData? loc = await location.getLocation();

    if (loc != null && locationData != loc) {
      setState(() => locationData = loc);
    }
  }
}
