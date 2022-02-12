import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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

  
  @override
  Widget build(BuildContext context) {
    return  GoogleMap(
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
    );
  }
}