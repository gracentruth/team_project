import 'package:flutter/material.dart';
import 'package:team_project/profilelist.dart';
import 'mainpage.dart';
import 'mypage.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

double currentLatitude = 0;
double currentLongitude = 0;

class HomePage extends StatefulWidget {
  HomePage({required this.mycurrentLatitude, required this.mycurrentLongitude});

  double mycurrentLatitude;
  double mycurrentLongitude;

  @override
  _HomePageState createState() {
    currentLatitude = mycurrentLatitude;
    currentLongitude = mycurrentLongitude;
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [MainPage(Latitude: currentLatitude, Longitude: currentLongitude,),ProfileList() , MyPage()];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavyBar(
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.redAccent,
              textAlign: TextAlign.center,
            ),

            BottomNavyBarItem(
              icon: Icon(Icons.pets),
              title: Text(
                'Animal',
              ),
              activeColor: Colors.pinkAccent,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.person),
              title: Text('MyPage'),
              activeColor: Colors.purpleAccent,
              textAlign: TextAlign.center,
            ),
          ],
          onItemSelected: _onTap,
          selectedIndex: _currentIndex,
          showElevation: true,
        )
    );
  }
}