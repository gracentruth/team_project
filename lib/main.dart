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
import 'package:flutter_native_splash/flutter_native_splash.dart';
//test
//

VideoPlayerController? controller2;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
  FlutterNativeSplash.remove();
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