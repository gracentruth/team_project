
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:video_player/video_player.dart';

import 'Storage.dart';
import 'main.dart';


String docid='';


class LivePage extends StatefulWidget {
  LivePage({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  _LivePageState createState(){
    print('--------start----------');
    print(pickedFile);
    return _LivePageState();
  }
}

class _LivePageState extends State<LivePage> {


  final Storage storage = Storage();

  void _incrementCounter() async {
    setState(() async {
     pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);
     print('-----------------------');
     print(pickedFile);
     controller = VideoPlayerController.file(File(pickedFile!.path))

        ..initialize().then((_) {
          setState(() {});
        });

     FirebaseFirestore.instance
         .collection('animal')
         .add(<String, dynamic>{
       'controll': VideoPlayerController.file(File(pickedFile!.path)),
       'name': widget.name
     });

      print('****************');
      print(controller);
      controller!.play();
      print(controller == null);
     storage.uploadFile(pickedFile!.path,'${widget.name}video');
    });
  }


  @override
  Widget build(BuildContext context) {
    //_controller=VideoPlayerController.file(File(pickedFile!.path));
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.name),
      ),
      body: Center(
        child: controller != null
            ? Column(
          children: [
            Expanded(
              child: VideoPlayer(controller!),
            ),
            TextButton(onPressed: () {

            }, child: Text("Upload")),
          ],
        )
            : Container(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.camera),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
