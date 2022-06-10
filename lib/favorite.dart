import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'mypage.dart';
//
class FavoritePage extends StatefulWidget {
  FavoritePage({required this.user});

  User user;

  @override
  _FavoritePageState createState() => _FavoritePageState(user: user);
}

class _FavoritePageState extends State<FavoritePage> {
  _FavoritePageState({required this.user});

  TextEditingController _search = TextEditingController();
  User user;

  String? downloadURL;

  Future getData(String path) async {
    try {
      await downloadURLExample(path);
      return downloadURL;
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample(String path) async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child(path)
        .getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좋아하는 동물 '),
      ),
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.yellow[100],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: '검색',
                    hintStyle: TextStyle(
                        fontSize: 15
                    ),
                  ),
                  controller: _search,
                ),
                SizedBox(height: 15,),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('user').doc(user.uid).snapshots(),
                    builder: (context, snapshots) {
                      List<dynamic> favorite = snapshots.data!.get('favorite') as List<dynamic>;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: favorite.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              ListTile(
                                title: Text(
                                  '${favorite[index]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),

                                // leading: Container(
                                //   height: 65,
                                //   width: 65,
                                //   decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       image: DecorationImage(
                                //           fit: BoxFit.fill,
                                //           image: NetworkImage(
                                //               'https://post-phinf.pstatic.net/MjAyMDAyMjlfMjY4/MDAxNTgyOTU0Nzg3MjQ4.PBMFV4WrSJmeSUJ56c4C7Vkz_SsQlJ1SByKU18kkJh0g.T7mQnadCWVtEZ448AGk_9kG1HFBAzdztXZcBjvSbduwg.JPEG/고양이_나이1.jpg?type=w1200'
                                //           )
                                //       )
                                //   ),
                                // ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    favorite.removeAt(index);
                                    FirebaseFirestore.instance.collection('user').doc(user.uid).update({
                                      'favorite' : favorite,
                                    });
                                  },
                                  child: Text('취소'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.yellow[100],
                                    onPrimary: Colors.black,
                                  ),
                                ),
                                onTap: () {},
                              ),
                              SizedBox(height: 30,),
                            ],
                          )
                      );
                    }
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}
