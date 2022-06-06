import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:team_project/provider/dropDownProvider.dart';
import 'package:team_project/provider/loginProvider.dart';
import 'package:team_project/provider/profileProvider.dart';
import 'package:video_player/video_player.dart';
import 'appstate.dart';
//import 'chart.dart';
import 'profiledetail.dart';
import 'profilelist.dart';
import 'updateprofile.dart';
import 'app.dart';
import 'login.dart';
import 'mainpage.dart';
import 'package:provider/provider.dart';
//test
//




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => DropDownProvider()),
        ],
        child: ChangeNotifierProvider(
          create: (context) => ApplicationState(),
          builder: (context, _) => const MyApp(),
        ),
      ));
  }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) =>
                  new LoginPage())
              );
            }, child: Text('login')),
            // ElevatedButton(onPressed: () {
            //   Navigator.push(context, new MaterialPageRoute(
            //       builder: (context) =>
            //       new ProfileDetail(d:''))
            //   );
            // }, child: Text('profile detail')),
            ElevatedButton(onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) =>
                  new ProfileList())
              );
            }, child: Text('profile list')),

            ElevatedButton(onPressed: () {
              //Navigator.push(context, new MaterialPageRoute(
               //   builder: (context) =>
                 // new UpdateProfile())
             // );
            }, child: Text('update profile')),
            // ElevatedButton(onPressed: () {
            //   Navigator.push(context, new MaterialPageRoute(
            //       builder: (context) =>
            //       new chartPage())
            //   );
            // }, child: Text('chart page ')),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellow,
        selectedItemColor: Colors.black ,
        unselectedItemColor:Colors.black ,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: ''
          ),
        ],
        onTap: (index){
         // _idx = index;
        },
        //currentIndex: _idx,
      ),
    );
  }
}
