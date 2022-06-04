import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:video_player/video_player.dart';

import 'Storage.dart';
import 'main.dart';

String docid = '';
String name = '';

dynamic pickedFile;
VideoPlayerController? controller;
Future<String> a = '' as Future<String>;

class LivePage extends StatefulWidget {
  LivePage({Key? key, required this.name2}) : super(key: key);
  String name2;

  @override
  _LivePageState createState() {
    name = name2;
    // a=FirebaseFirestore.instance.collection('video').doc(name).get().then((value){
    //    print(value.data()!['video'].toString());
    //    return value.data()!['video'].toString();
    //  });
    //
    //
    //  a.then((value) => print(a));
    return _LivePageState();
  }
}

class _LivePageState extends State<LivePage> {
  final Storage storage = Storage();

  // @override
  // void initState() {
  //   super.initState();
  //
  //   // Create and store the VideoPlayerController. The VideoPlayerController
  //   // offers several different constructors to play videos from assets, files,
  //   // or the internet.
  //   _controller = VideoPlayerController.network(
  //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  //   );
  //
  //   _initializeVideoPlayerFuture = _controller.initialize();
  // }

  void _incrementCounter() async {
    controller = null;
    setState(() {});
    setState(() async {
      pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);
      //  controller = VideoPlayerController.file(File(pickedFile!.path));

      FirebaseFirestore.instance.collection('video').doc(name).set({
        'video': '${name}_video',
      }, SetOptions(merge: true));
      //  controller!.play();
      await storage.uploadFile(pickedFile!.path, '${name}_video');

      //await Future.delayed(Duration(seconds: 5));

      String s = await storage.downloadURL('${name}_video');
      controller = await VideoPlayerController.network(s)
        ..initialize().then((_) {
          setState(() {});
        });
      controller?.play();
    });
  }

  final Stream<DocumentSnapshot> stream2 =
      FirebaseFirestore.instance.collection('video').doc(name).snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: stream2,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('오늘의 $name'), //snapshot.data!['video']
          ),
          body: Center(
              child: controller != null
                  ? Stack(
                      children: [
                        Expanded(
                          child: VideoPlayer(controller!),
                        ),
                        Column(
                          children: [
                            Container(
                              height: 690,
                            ),
                            ElevatedButton(
                              child: Text('오늘의 $name 다시보기'),
                              onPressed: () {
                                setState(() {
                                  controller?.play();
                                });
                              },
                            )
                          ],
                        )
                      ],
                    )
                  : CircularProgressIndicator()),

          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.camera),
          ),

          // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
