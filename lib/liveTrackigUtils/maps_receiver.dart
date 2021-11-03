import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsReceiver extends StatefulWidget {
  final String deviceid;

  MapsReceiver({Key key, @required this.deviceid}) : super(key: key);

  @override
  State createState() => MapsReceiverState();
}

class MapsReceiverState extends State<MapsReceiver> {
  static final databaseReference = FirebaseDatabase.instance.reference();

  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;

  static GoogleMapController mapController;

  StreamSubscription subscription;

  LocationData currentLocation =
      LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0});
  StreamSubscription<LocationData> locationSubcription;

  Location location = new Location();
  String error;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    subscription =
        databaseReference.child(widget.deviceid).onValue.listen((event) {
      setState(() {
        currentLatitude = event.snapshot.value['latitude'];
        currentLongitude = event.snapshot.value['longitude'];
      });
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(event.snapshot.value['latitude'],
                  event.snapshot.value['longitude']),
              zoom: 17),
        ),
      );
      _add(LatLng(
          event.snapshot.value['latitude'], event.snapshot.value['longitude']));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
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
        appBar: AppBar(title: const Text('Receiver')),
        backgroundColor: Colors.grey[800],
        body: Padding(
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
                        target: LatLng(currentLatitude, currentLongitude),
                        zoom: 17),
                    onMapCreated: _onMapCreated,
                  ),
                ),
              ),
              Container(
                child: Text('Lat/Lng: $currentLatitude/$currentLongitude'),
              ),
              Text("Device ID: ${widget.deviceid}")
            ],
          ),
        ));
  }
}
