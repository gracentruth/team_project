import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'livepage.dart';
import 'storage.dart';

List<String> nameList2 = [];
List<String> videoList2 = [];

class livelistPage extends StatefulWidget {
  const livelistPage({Key? key}) : super(key: key);

  @override
  _livelistPageState createState() => _livelistPageState();
}

class _livelistPageState extends State<livelistPage> {
  final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F'];
  final List<int> colorCodes = <int>[600, 500, 400, 300, 200, 100];

  void messagesStream() async {
    nameList2 = [];
    videoList2 = [];
    await for (var snapshot
    in FirebaseFirestore.instance.collection('animal').snapshots()) {
      for (var message in snapshot.docs) {
        nameList2.add(message.get('name'));
        //nameList.add(message.get('name'));
      }
      setState(() {});
    }

    // await for (var snapshot in FirebaseFirestore.instance.collection('video').snapshots()) {
    //   for (var message in snapshot.docs) {
    //     videoList2.add(message.get('video'));
    //     //nameList.add(message.get('name'));
    //   }
    //   setState(() {
    //
    //   });
    // }

    print(nameList2.toString());
    //print(videoList2.toString());

  }

  @override
  void initState() {
    messagesStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    //nameList2=['1','2','3','4','5'];
    return Scaffold(
       appBar: AppBar(title: Text('실시간 영상 리스트')),

        body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 30),
            itemCount: nameList2.length,
            itemBuilder: (BuildContext context, int index) {
              //index가 궁금하면 요기다가 넣고 화면에 찍어보세요
              //print("itembuilder: ${index}");

              return Column(
                  children: [
              ListTile(
              title: Text('${nameList2[index]}'),
                trailing: TextButton(
                  child: Text('show video'),
                  onPressed: () async {

                    String s2='';
                    await FirebaseFirestore.instance.collection('video').doc(nameList2[index]).get().then((value)=>{
                      s2=value.data()!['video'].toString()
                    }
                    );

                    if(s2==''){
                      s2=await storage.downloadURL('default_video');
                    }else{
                      s2=await storage.downloadURL('${nameList2[index]}_video');
                    }

                    controller=await VideoPlayerController.network(s2)
                      ..initialize().then((_) {
                        setState(() {});
                      });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LivePage(
                                name2: nameList2[index]
                            )));

                  },
                ),

              ),
                    Divider(
                      thickness: 1,
                      height: 1,

                    )
              ]
              ,
              );
            }));
  }
}
