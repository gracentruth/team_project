import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_project/updateprofile.dart';
import 'package:video_player/video_player.dart';
import 'chatpage.dart';
import 'livepage.dart';
import 'storage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:like_button/like_button.dart';

int rice = 0;
String docid = '';
String name = '';
int age = 0;
String live = '';
int eat = 0;
String sex = '';
bool isFavorite2 = false;
List<dynamic> imagelist = [];

class ProfileDetail extends StatefulWidget {
  final String d;
  bool isFavorite;

  ProfileDetail({required this.d, required this.isFavorite});

  @override
  _ProfileDetailState createState() {
    docid = d;
    isFavorite2 = isFavorite;

    return _ProfileDetailState();
  }
}

class _ProfileDetailState extends State<ProfileDetail> {
  File? _image;
  final picker = ImagePicker();
  List? _outputs;
  String _fileName = 'logo.png';
  bool isVideo = false;

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    final ref = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final ref2 =
    await FirebaseFirestore.instance.collection('animal').doc(docid).get();
    List<dynamic> list = ref.data()!['favorite'];
    var name = ref2.data()!['name'];
    if (!isLiked) {
      list.add(name);
      print(list);
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'favorite': list});
    } else {
      list.remove(name);
      print(list);
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'favorite': list});
    }
    return !isLiked;
  }

  final CollectionReference animal =
  FirebaseFirestore.instance.collection('animal');

  final Stream<DocumentSnapshot> _stream =
  FirebaseFirestore.instance.collection('animal').doc(docid).snapshots();

  void _delete() async {
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    animal.doc(docid).delete();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return StreamBuilder<DocumentSnapshot>(
      stream: _stream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        imagelist = snapshot.data!['imagelist'];
        print(snapshot);
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: Text(snapshot.data!['name']),
              actions: [
                IconButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => UpdateProfile(
                      //         docId: docid,
                      //       ),
                      //     ));
                    },
                    icon: const Icon(Icons.create)),
                IconButton(
                    onPressed: () {
                      _delete();
                    },
                    icon: const Icon(Icons.delete))
              ],),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: storage.downloadURL(snapshot.data!['image']),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          print('----image=-----');
                          print(snapshot.data!);
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            child:
                            // Image.network(
                            //   snapshot.data!,
                            //   fit: BoxFit.fill,
                            // ),
                            PhotoView(
                              imageProvider: NetworkImage(
                                snapshot.data!,
                              ),
                            ),
                          );
                        }
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        return Container();
                      }),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      children: [
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  snapshot.data!['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                  ),
                                ),
                                Text(
                                    '/${snapshot.data!['sex']}'
                                ),
                                SizedBox(
                                  width: 170,
                                ),
                                LikeButton(
                                  isLiked: isFavorite2,
                                  onTap: onLikeButtonTapped,
                                ),
                                SizedBox(
                                  width: 10,
                                ),

                                IconButton(
                                  iconSize: 27,
                                  icon: Icon(Icons.chat),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                              doc: docid,
                                              name: snapshot.data!['name'],
                                            )));
                                  },
                                ),
                                //
                              ],
                            ),
                            Row(
                              children: [
                                //Text(''),
                                Container(
                                  width: 300,
                                  child: Text('${snapshot.data!['live']}'),
                                ),
                              ],
                            )
                          ],
                        ),

                        // IconButton(
                        //   iconSize: 27,
                        //   icon: Icon(Icons.chat),
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => ChatPage(
                        //               doc: docid,
                        //               name: snapshot.data!['name'],
                        //             )));
                        //   },
                        // ),
                        // //
                        // LikeButton(
                        //   isLiked: isFavorite2,
                        //   onTap: onLikeButtonTapped,
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            FloatingActionButton(
                              backgroundColor: Colors.red,
                              onPressed: () async {
                                String s2 = '';
                                await FirebaseFirestore.instance
                                    .collection('video')
                                    .doc(snapshot.data!['name'])
                                    .get()
                                    .then((value) => {
                                  s2 = value.data()!['video'].toString()
                                });
                                if (s2 == '') {
                                  s2 = await storage
                                      .downloadURL('default_video');
                                } else {
                                  s2 = await storage.downloadURL(
                                      '${snapshot.data!['name']}_video');
                                }

                                controller =
                                await VideoPlayerController.network(s2)
                                  ..initialize().then((_) {
                                    setState(() {});
                                  });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LivePage(
                                            name2: snapshot.data!['name'])));
                              },
                              heroTag: 'video1',
                              tooltip: 'Take a Video',
                              child: const Icon(Icons.videocam),
                            ),
                            Text('????????????')
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.rice_bowl,
                              ),
                              onPressed: () {
                                rice = snapshot.data!['eat'];
                                if (rice == 4) {
                                  rice = 0;
                                } else {
                                  rice = rice + 1;
                                }
                                animal.doc(docid).set({
                                  'Category': snapshot.data!['Category'],
                                  'age': snapshot.data!['age'],
                                  'desc': snapshot.data!['desc'],
                                  'eat': rice,
                                  'image': snapshot.data!['image'],
                                  'live': snapshot.data!['live'],
                                  'like': snapshot.data!['like'],
                                  'name': snapshot.data!['name'],
                                  'sex': snapshot.data!['sex'],
                                  'weight': snapshot.data!['weight'],
                                  'imagelist': snapshot.data!['imagelist'],
                                });
                              },
                            ),
                            Text('?????????')
                          ],
                        ),
                        SizedBox(width: 35),
                        Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                Container(
                                  color: snapshot.data!['eat'] >= 1
                                      ? Colors.red.shade400
                                      : Colors.grey,
                                  width: 50,
                                  height: 20,
                                ),
                                SizedBox(width: 1),
                                Container(
                                  color: snapshot.data!['eat'] >= 2
                                      ? Colors.red.shade400
                                      : Colors.grey,
                                  width: 50,
                                  height: 20,
                                ),
                                SizedBox(width: 1),
                                Container(
                                  color: snapshot.data!['eat'] >= 3
                                      ? Colors.red.shade400
                                      : Colors.grey,
                                  width: 50,
                                  height: 20,
                                ),
                                SizedBox(width: 1),
                                Container(
                                  color: snapshot.data!['eat'] >= 4
                                      ? Colors.red.shade400
                                      : Colors.grey,
                                  width: 50,
                                  height: 20,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Text(
                      '????????? ${snapshot.data!['name']}',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    // height:900,
                    child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, //1 ?????? ?????? ????????? item ??????
                            childAspectRatio: 1 / 1, //item ??? ?????? 1, ?????? 2 ??? ??????
                            mainAxisSpacing: 10, //?????? Padding
                            crossAxisSpacing: 10, //?????? Padding
                          ),
                          itemCount: imagelist.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            //item ??? ????????? ?????? ??????
                            print(index);
                            return index == imagelist.length
                                ? Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  color: Colors.grey,
                                  child: IconButton(
                                    icon: const Icon(Icons.add_a_photo),
                                    onPressed: () async {
                                      await getImage(ImageSource.camera);
                                      int listlength = imagelist.length;
                                      String imagename =
                                          '${snapshot.data!['name']}${listlength + 1}';
                                      storage.uploadFile(
                                          _image!.path, imagename);

                                      imagelist.add(imagename);
                                      animal.doc(docid).set({
                                        'Category':
                                        snapshot.data!['Category'],
                                        'age': snapshot.data!['age'],
                                        'desc': snapshot.data!['desc'],
                                        'eat': rice,
                                        'image': snapshot.data!['image'],
                                        'live': snapshot.data!['live'],
                                        'like': snapshot.data!['like'],
                                        'name': snapshot.data!['name'],
                                        'sex': snapshot.data!['sex'],
                                        'weight':
                                        snapshot.data!['weight'],
                                        'imagelist': imagelist,
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
                                : Container(
                              child: FutureBuilder(
                                  future: storage
                                      .downloadURL(imagelist[index]),
                                  //snapshot.data!['name']
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                        snapshot.hasData) {
                                      return Container(
                                        //width:180,
                                        // height: 300,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                          child: Image.network(
                                            snapshot.data!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    }
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    return Container();
                                  }),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path);
      _fileName = _image!.path; // ????????? ???????????? _image??? ??????
    });
    //await classifyImage(File(image!.path)); // ????????? ???????????? ?????? ?????? ?????? await??? ??????
    return _fileName;
  }
}
