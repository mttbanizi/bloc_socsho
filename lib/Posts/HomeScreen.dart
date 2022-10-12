// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';

import 'buttonScreens/Likebuttonscreens .dart';
import 'buttonScreens/Plusbuttonscreens .dart';
import 'buttonScreens/accountbuttonscreens .dart';
import 'buttonScreens/homebuttonscreens.dart';
import 'buttonScreens/searchbuttonscreens.dart';
// import 'package:instagram/bottomIconScreen/accountBottomIconScreen.dart';
// import 'package:instagram/bottomIconScreen/homeBottomIconScreen.dart';
// import 'package:instagram/bottomIconScreen/likeBottomIconScreen.dart';
// import 'package:instagram/bottomIconScreen/plusBottomIconScreen.dart';
// import 'package:instagram/bottomIconScreen/searchBottomIconScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State {
  int _currentTab = 0;
  List page;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page = [
      HomeButtonIconScreens(),
      SearchButtonIconScreens(),
      LikeButtonIconScreens(),
      AccountButtonIconScreens(),
      PlusButtonIconScreens(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var _bottomItems = new BottomNavigationBar(
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 30,
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
        items: [
          new BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.black,
            ),
          ),
          new BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          new BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.favorite,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.black,
            ),
          ),
          new BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.account_circle,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.account_circle,
              color: Colors.black,
            ),
          ),
          new BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.add_box,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.add_box,
              color: Colors.black,
            ),
          ),
        ]);
    // TODO: implement build
    return new Scaffold(
      bottomNavigationBar: _bottomItems,
      body: page[_currentTab],
    );
  }
}
