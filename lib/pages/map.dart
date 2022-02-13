import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/widgets/job_tile.dart';

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
      // _controller.animateCamera(
      //   // CameraUpdate.newCameraPosition(
      //   //   CameraPosition(target: LatLng(l.latitude ?? 0, l.longitude ?? 0),zoom: 15),
      //   //   ),
      // );
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
                    radius: 10,
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
              padding: const EdgeInsets.all(8),
              children: [
                for (int i = 0; i < jobs.length; i++)
                  JobTile(
                    c: (min(i, 7) + 1) * 100,
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
}
