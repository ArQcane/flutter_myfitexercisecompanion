import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RunTrackerScreen extends StatefulWidget {
  static String routeName = "/runtracker";

  @override
  State<RunTrackerScreen> createState() => _RunTrackerScreenState();
}

class _RunTrackerScreenState extends State<RunTrackerScreen> {
  StreamSubscription? _locationSubscription;
  GoogleMapController? _controller;
  Location currentLocation = Location();
  Set<Marker> _markers ={};

  void getLocation() async{
    var location = await currentLocation.getLocation();

    if(_locationSubscription != null){
      _locationSubscription?.cancel();
    }

    _locationSubscription = currentLocation.onLocationChanged.listen((LocationData loc){
      _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: 12.0,
      )));
      print(loc.latitude);
      print(loc.longitude);
    });
  }

  void getCurrentLocation() async {
    try {
      var location = await currentLocation.getLocation();

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }


      _locationSubscription = currentLocation.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller!.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude ?? 0.0, newLocalData.longitude ?? 0.0),
              tilt: 0,
              zoom: 18.00)));
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void initState(){
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_locationSubscription != null){
      _locationSubscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:GoogleMap(
          zoomControlsEnabled: false,
          initialCameraPosition:CameraPosition(
            target: LatLng(0.0 , 0.0),
            zoom: 12.0,
          ),
          onMapCreated: (GoogleMapController controller){
            _controller = controller;
          },
          markers: _markers,
          myLocationEnabled: true,
        ) ,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching,color: Colors.white,),
        onPressed: (){
          getCurrentLocation();
        },
      ),
    );
  }
}