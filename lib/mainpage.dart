import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:team_project/profiledetail.dart';
import 'package:team_project/speech.dart';

import 'getLocaation.dart';
import 'mypage.dart';

class MainPage extends StatefulWidget {
  MainPage({required this.Latitude, required this.Longitude});

  double Latitude;
  double Longitude;

  @override
  _MainPageState createState() =>
      _MainPageState(currentLatitude: Latitude, currentLongitude: Longitude);
}

class _MainPageState extends State<MainPage> {
  _MainPageState(
      {required this.currentLatitude, required this.currentLongitude});

  GetLocation location = GetLocation();
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _search = TextEditingController();
  Location currentLocation = Location();
  Set<Marker> _markers = {};
  List<double> liveList = [];

  double currentLatitude;
  double currentLongitude;

  @override
  void initState() {
    super.initState();
    getLocation();
    //getMarker();
  }

  getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    currentLatitude = position.latitude;
    currentLongitude = position.longitude;
  }

  // getMarker() async {
  //   FirebaseFirestore.instance.collection("animal").doc(docid).get().then((DocumentSnapshot ds){
  //     location.marker(ds.data['live']);
  //     print(title);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.yellow[100],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: '동네 검색',
                hintStyle: TextStyle(fontSize: 15),
              ),
              controller: _search,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                height: 400,
                child: currentLatitude != 0 && currentLongitude != 0
                    ? GoogleMap(
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLatitude, currentLongitude),
                          zoom: 18,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      )
                    : Text('loading')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic_none, size: 30),
        onPressed: toggleRecording,
      ),
    );
  }

  Future toggleRecording() => Speech.toggleRecording(
        onResult: (text) => setState(() {
          _search.text = text;
        }),
      );
}
