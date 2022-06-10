import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:team_project/Storage.dart';
import 'package:team_project/profiledetail.dart';
import 'package:team_project/speech.dart';

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

  Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection('animal')
      .orderBy('name')
      .snapshots();

  // GetLocation location = GetLocation();
  Completer<GoogleMapController> _controller = Completer();
  final ScrollController _scrollController = ScrollController();
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
    getMarker();
  }

  getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    currentLatitude = position.latitude;
    currentLongitude = position.longitude;
  }

  getMarker() async {
    await for (var snapshot
    in FirebaseFirestore.instance.collection('animal').snapshots()) {
      for (var message in snapshot.docs) {
        _markers.add(Marker(
          markerId: MarkerId(message.id),
          position:
          LatLng(message.data()['live_start'], message.data()['live_end']),
          infoWindow: InfoWindow(
            onTap: () async {
              bool isFavorite;
              final ref = await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get();
              List<dynamic> list = ref.data()!['favorite'];
              if(list.contains(message.data()['name'])) {isFavorite = true;}
              else {isFavorite = false;}
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDetail(
                    d: message.id,
                    isFavorite: isFavorite,
                  ),
                ),
              );
            },
            title: message.data()['name'],
            snippet: "${message.data()['sex']} / \n${message.data()['Category']}",
          ),
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        ));
      }
    }
    print(_markers.length);
  }

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
              height: 600,
              width: 400,
              child: currentLatitude != 0 && currentLongitude != 0
                  ? GoogleMap(
                markers: _markers,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(currentLatitude, currentLongitude),
                  zoom: 18,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              )
                  : Text('loading'),
            ),
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

class Animal extends StatelessWidget {
  const Animal({
    required this.id,
    required this.image,
    required this.name,
  });

  final id;
  final image;
  final name;

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
              aspectRatio: 18 / 11,
              child: Row(
                children: [
                  FutureBuilder(
                      future: storage.downloadURL(image),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                padding: EdgeInsets.all(0.0),
                                width: 200,
                                child: Image.network(snapshot.data!,
                                    fit: BoxFit.fill),
                              ));
                        }
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        return Container();
                      }),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 150,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                Text(
                                  live,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    bool isFavorite;
                                    final ref = await FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(FirebaseAuth
                                        .instance.currentUser!.uid)
                                        .get();
                                    List<dynamic> list =
                                    ref.data()!['favorite'];
                                    if (list.contains(name)) {
                                      isFavorite = true;
                                    } else {
                                      isFavorite = false;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileDetail(
                                          d: id,
                                          isFavorite: isFavorite,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'more',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    // padding: const EdgeInsets.all(0.0),
                                    minimumSize: const Size(5, 3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
