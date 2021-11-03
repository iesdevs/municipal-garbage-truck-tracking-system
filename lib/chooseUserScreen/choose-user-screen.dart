import 'package:flutter/material.dart';
import 'package:flutter_maps/liveTrackigUtils/maps_host.dart';
import 'package:flutter_maps/liveTrackigUtils/choose_device.dart';
import 'package:flutter_maps/liveTrackigUtils/coordinates_model.dart';

class ChooseUser extends StatelessWidget {
  CoordinatesModel coordinatesModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Flutter')),
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pexels3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.orange,
                    textColor: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    child: Text("Share my realtime location"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapsHost()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                SizedBox(
                    width: 200,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.orange,
                      textColor: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      child: Text("Get realtime location"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseDevice()),
                        );
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
