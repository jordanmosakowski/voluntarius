import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/widgets/job_tile.dart';
import 'package:intl/date_symbol_data_local.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng _initialcameraposition = const LatLng(37.3490496, -121.9388039);
  late GoogleMapController _controller;
  CollectionReference jobsRef = FirebaseFirestore.instance.collection("jobs");
  final Location _location = Location();
  final geo = Geoflutterfire();

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      print(l.latitude);
      print(l.longitude);
    });
  }

  List<String> jobs = ["Pylons", "Barrel Roll", "The Way", "a", "b", "c", "d"];
  List<String> descs = [
    "You must construct additional pylons",
    "Do a Barrel Roll",
    "Do you know da wae?",
    "a",
    "b",
    "c",
    "d"
  ];

  void clickTile(Job job) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(job.location.latitude, job.location.longitude),
            zoom: 19),
      ),
    );
  }

  double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = pi * 180 * (lat2 - lat1); // deg2rad below
    var dLon = pi * 180 * (lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(pi * 180 * (lat1)) *
            cos(pi * 180 * (lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    LocationData location = Provider.of<LocationData>(context);
    return MultiProvider(
      providers: [
        StreamProvider<List<Job>>.value(
            initialData: const [],
            value: geo
                .collection(collectionRef: jobsRef)
                .within(
                    center: geo.point(
                      latitude: location.latitude ?? 0,
                      longitude: location.longitude ?? 0,
                    ),
                    radius: 50,
                    field: "location")
                .map((docs) => docs.map((snap) {
                      return Job.fromFirestore(snap);
                    }).toList()))
      ],
      child: Builder(builder: (context) {
        List<Job> jobs = Provider.of<List<Job>>(context);
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition, zoom: 15),
                  // markers: {
                  //   const Marker(
                  //     markerId: MarkerId("SCDI"),
                  //     position: LatLng(37.3490496, -121.9388039),

                  //   )
                  // },
                  markers: jobs
                      .map((job) => Marker(
                          onTap: () {
                            print("Complete");
                            int index = jobs.indexOf(job);
                            print(_scrollController.position.maxScrollExtent);
                            double position =
                                _scrollController.position.maxScrollExtent /
                                    jobs.length;
                            _scrollController.animateTo(
                              position * index,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            );
                            showDialog(
                              context: context,
                              builder: (BuildContext) =>
                                  _buildPopupDialog(context, job),
                            );
                          },
                          markerId: MarkerId(job.id),
                          position: LatLng(
                              job.location.latitude, job.location.longitude)))
                      .toSet(),
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                ),
              ),
            ),
            Expanded(
                child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              children: [
                for (int i = 0; i < jobs.length; i++)
                  JobTile(
                    openPopup: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext) =>
                            _buildPopupDialog(context, jobs[i]),
                      );
                    },
                    onTap: () {
                      clickTile(jobs[i]);
                    },
                    c: (i % 2 + 1) * 100,
                    job: jobs[i],
                    dist: jobs[i].location.distance(
                          lat: location.latitude ?? 0,
                          lng: location.longitude ?? 0,
                        ),
                  )
              ],
            ))
          ],
        );
      }),
    );
  }

  Widget _buildPopupDialog(BuildContext context, Job job) {
    User? userData = Provider.of<User?>(context, listen: false);
    return AlertDialog(
      title: Text(job.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Description: " + job.description),
          Text("Hours Required: " + job.hoursRequired.toString()),
          Text("People Required: " + job.peopleRequired.toString()),
          Text("Appointment Time: " +
              DateFormat.yMMMMd('en_US').add_jm().format(job.appointmentTime))
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Done")),
        ElevatedButton(
            onPressed: () async {
              Claim claim = Claim(
                  id: "",
                  jobId: job.id,
                  userId: userData!.uid,
                  approved: false,
                  completed: false);
              await FirebaseFirestore.instance
                  .collection("claims")
                  .add(claim.toJson());
              Navigator.of(context).pop();
            },
            child: Text("Apply"))
      ],
    );
  }
}
