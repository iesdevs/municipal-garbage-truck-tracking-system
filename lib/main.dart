import 'package:flutter/material.dart';
import 'package:flutter_maps/googleMapScreen/google-map-screen.dart';
import 'package:flutter_maps/chooseUserScreen/choose-user-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green[800],
      ),
      home: MyHomePage(title: 'Live Tracking'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //title: Text(widget.title),
      //backgroundColor: Colors.black,
      //),
      body: Container(
        //use Container for back-image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pexels1.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                          width: double.infinity,
                height: 55,
                child: RaisedButton(
                  color: Colors.orange,
                  textColor: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  child: Text("Google Map screen"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoogleMapScreen()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
              SizedBox(
                          width: double.infinity,
                  height: 55,
                  child: RaisedButton(
                    color: Colors.orange,
                    textColor: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                    child: Text("Live tracking"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseUser()));
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
