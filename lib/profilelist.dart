import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'addprofile.dart';
import 'model/animal.dart';
import 'model/animal_List.dart';
import 'storage.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({Key? key}) : super(key: key);

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection('animal')
      .orderBy('name')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile list'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProfile()));
              }),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(16.0),
                    childAspectRatio: 8.0 / 9.0,
                    children:
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Animal(
                        image: document.id,
                        name: document['name'].toString(),
                        age: document['age'].toString(),
                        sex: document['sex'].toString(),
                        weight: document['weight'].toString(),
                        live: document['live'].toString(),
                        desc: document['desc'].toString(),
                        like: document['like'].toString(),
                        eat: document['eat'].toString(),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          } else {
            return Card();
          }
        },
      ),
    );
  }
}

class Animal extends StatelessWidget {
  const Animal({
    required this.image,
    required this.name,
    required this.age,
    required this.sex,
    required this.weight,
    required this.live,
    required this.desc,
    required this.like,
    required this.eat,
  });

  final image;
  final name;
  final age;
  final sex;
  final weight;
  final live;
  final desc;
  final like;
  final eat;

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
            child: FutureBuilder(
                future: storage.downloadURL(image),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Container(
                        child: Image.network(
                          snapshot.data!,
                          fit: BoxFit.fill,
                        ));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  return Container();
                }),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 50,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              " / " +
                                  age +
                                  "살 " +
                                  sex,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          live,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          desc,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                  size: 15,
                                ),
                                onPressed: () {}),
                            Text(
                              like,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.pink,
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.restaurant_rounded,
                                  color: Colors.green,
                                  size: 15,
                                ),
                                onPressed: () {}),
                            Text(
                              eat,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}