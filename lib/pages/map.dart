import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:voluntarius/widgets/job_tile.dart';

class MapPage extends StatefulWidget {
  const MapPage({ Key? key }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  final LatLng _initialcameraposition = const LatLng(37.3490496, -121.9388039);
  late GoogleMapController _controller;
  final Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr)
  {
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

  List<String> jobs = ["Pylons", "Barrel Roll", "The Way"];
  List<String> descs =["You must construct additional pylons", "Do a Barrel Roll", "Do you know da wae:"];

  double getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = pi * 180 * (lat2-lat1);  // deg2rad below
    var dLon = pi * 180 * (lon2-lon1); 
    var a = 
      sin(dLat/2) * sin(dLat/2) +
      cos(pi * 180 * (lat1)) * cos(pi * 180 * (lat2)) * 
      sin(dLon/2) * sin(dLon/2)
      ; 
    var c = 2 * atan2(sqrt(a), sqrt(1-a)); 
    var d = R * c; // Distance in km
    return d;
  }
  
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialcameraposition, zoom: 15),
              markers: {
                const Marker(
                  markerId: MarkerId("SCDI"),
                  position: LatLng(37.3490496, -121.9388039),
                  
                )
              },
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
              for(int i=0; i<jobs.length; i++)
                JobTile(
                  c: (i+1) * 100,
                  Job: jobs[i], dist: 50, desc: descs[i],
                )
            ],
          )
        )
      ],
    );
  }

}