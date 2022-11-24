import 'package:flutter/material.dart';
import 'package:mymovies/Page/home-page.dart';
import 'package:mymovies/page/profile-page.dart';
import 'package:mymovies/page/search-page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  List<Widget> tabs = <Widget>[
    const HomePage(),
    const SearchPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
        ],
        onTap: ((value) {
          setState(() {
            _currentIndex = value;
          });
        }),
      ),
    );
  }
}
