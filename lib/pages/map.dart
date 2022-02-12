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