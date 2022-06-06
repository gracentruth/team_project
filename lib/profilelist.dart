import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_project/profiledetail.dart';



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
                    crossAxisCount: 1,
                    padding: const EdgeInsets.all(0.0),
                    childAspectRatio: 15.0 / 9.5,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Animal(
                        id: document.id,
                        image: document['image'].toString(),
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
    required this.id,
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

  final id;
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
                            child:Container(
                              padding: EdgeInsets.all(0.0),
                              width:200,

                              child:Image.network(

                                  snapshot.data!,
                                  fit: BoxFit.fill
                              ),
                            )

                          );
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
                                    Text(
                                      " / " + age + "살 " + sex,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
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
                                // Text(
                                //   desc,
                                //   style: const TextStyle(
                                //     fontSize: 13,
                                //     color: Colors.black,
                                //   ),
                                // ),
                                Row(
                                  children: [

                                    IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.pink,
                                          size: 17,
                                        ),
                                        onPressed: () {}),
                                    // Text(
                                    //   like,
                                    //   style: const TextStyle(
                                    //     fontSize: 17,
                                    //     color: Colors.pink,
                                    //   ),
                                    // ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.restaurant_rounded,
                                          color: Colors.green,
                                          size: 17,
                                        ),
                                        onPressed: () {}),
                                    Text(
                                      eat,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () async {
                                    bool isFavorite;
                                    final ref = await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get();
                                    List<dynamic> list = ref.data()!['favorite'];
                                    if(list.contains(name)) {isFavorite = true;}
                                    else {isFavorite = false;}
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
