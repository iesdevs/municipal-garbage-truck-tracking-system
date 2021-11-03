import 'dart:async';

import 'package:device_id/device_id.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsHost extends StatefulWidget {
  @override
  State createState() => MapsHostState();
}

class MapsHostState extends State<MapsHost> {
  void showSnackBar(BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("done"),
    ));
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  LocationData currentLocation =
      LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0});
  StreamSubscription<LocationData> locationSubcription;

  Location location = new Location();
  String error;

  String _deviceid = 'Unknown';

  Future<void> initDeviceId() async {
    String deviceid;

    deviceid = await DeviceId.getID;

    if (!mounted) return;

    setState(() {
      _deviceid = deviceid;
    });
  }

  void UpdateDatabase() {
    databaseReference.child(_deviceid).set({
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude,
    });
  }

  @override
  void initState() {
    super.initState();
    initDeviceId();
    initPlatformState();
    locationSubcription = location.onLocationChanged().listen((result) {
      if (mounted)
        setState(() {
          currentLocation = result;
          _add(LatLng(currentLocation.latitude, currentLocation.longitude));
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(
                      currentLocation.latitude, currentLocation.longitude),
                  zoom: 17),
            ),
          );
        });
      UpdateDatabase();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void initPlatformState() async {
    LocationData my_location;
    try {
      my_location = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED')
        error = 'Permission Denied';
      else if (e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      my_location = null;
    }
    setState(() {
      currentLocation = my_location;
    });
  }

  void _add(latlong) {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: latlong,
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Host')),
        backgroundColor: Colors.grey[800],
        body: Builder(
            builder: (context) => Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: SizedBox(
                          width: double.infinity,
                          height: 650.0,
                          child: GoogleMap(
                            markers: Set<Marker>.of(markers.values),
                            initialCameraPosition: CameraPosition(
                                target: LatLng(currentLocation.latitude,
                                    currentLocation.longitude),
                                zoom: 17),
                            onMapCreated: _onMapCreated,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                            'Lat/Lng: ${currentLocation.latitude}/${currentLocation.longitude}'),
                      ),
                      Text("Device ID: $_deviceid"),
                    ],
                  ),
                )));
  }
}
