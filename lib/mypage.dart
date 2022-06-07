import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_project/favorite.dart';
import 'package:team_project/mydetailpage.dart';

import 'eatchartpage.dart';
import 'livelist.dart';


String name='';
class MyPage extends StatefulWidget {

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 30,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Text(
                        '마이 페이지',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    )
                ),
                Divider(thickness: 3),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.pets, size: 50),
                                  SizedBox(width: 30),
                                  Container(
                                    width: 230,
                                    child: Row(
                                      children: [
                                        // StreamBuilder<DocumentSnapshot>(
                                        //     stream: FirebaseFirestore.instance.collection('user').doc(user.uid).snapshots(),
                                        //     builder: (context, snapshots) {
                                        //        name = snapshots.data!.get('name');
                                        //
                                        //       return Text(
                                        //         '${name}',
                                        //         style: TextStyle(
                                        //             fontSize: 20,
                                        //             fontWeight: FontWeight.bold
                                        //         ),
                                        //       );
                                        //     }
                                        //     ),
                                        SizedBox(width: 10,),
                                        Text(
                                          '집사',
                                          style: TextStyle(
                                              fontSize: 15
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) =>
                                          new MyDetailPage())
                                      );
                                    },
                                    icon: Icon(Icons.arrow_forward_ios),
                                  )
                                ],
                              ),
                            )
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => FavoritePage(user: FirebaseAuth.instance.currentUser!))
                                    );
                                  },
                                  backgroundColor: Colors.yellow[100],
                                  child: Icon(Icons.favorite, color: Colors.black,),
                                ),
                                Text('쵀애 펫')
                              ],
                            ),
                            SizedBox(width: 75),
                            Column(
                              children: [
                                FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => livelistPage(
                                            )));
                                  },
                                  backgroundColor: Colors.yellow[100],
                                  child: Icon(Icons.wifi, color: Colors.black,),
                                ),
                                Text('방송 기록')
                              ],
                            ),
                            SizedBox(width: 75),
                            Column(
                              children: [
                                FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => eatChartPage(
                                                n: name
                                            )));
                                  },
                                  backgroundColor: Colors.yellow[100],
                                  child: Icon(Icons.monetization_on, color: Colors.black,),
                                ),
                                Text('모금 기록')
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 3),
                Container(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('동네 설정하기'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('동네 설정하기'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('동네 설정하기'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('동네 설정하기'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('관심 종 설정하기'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 3,),
                Container(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('친구 초대'),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text('앱 설정'),
                        onTap: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        )
    );
  }
}
