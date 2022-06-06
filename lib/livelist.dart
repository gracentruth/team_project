import 'package:flutter/material.dart';

class livelistPage extends StatefulWidget {
  const livelistPage({Key? key}) : super(key: key);

  @override
  _livelistPageState createState() => _livelistPageState();
}

class _livelistPageState extends State<livelistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('라이브영상 기록'),
        centerTitle: true,
      )

    );
  }
}


