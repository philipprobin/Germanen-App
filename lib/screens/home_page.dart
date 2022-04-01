import 'package:flutter/material.dart';
import 'package:germanenapp/screens/sempro_page.dart';

import 'beer_list_page.dart';
import 'content_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;
  List<Widget> _widgetOptions = <Widget>[
    SemproPage(),
    ContentPage(),
    BeerListPage(),

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        showUnselectedLabels: true,
        onTap: (index) => setState(() => currentIndex = index),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chrome_reader_mode_outlined,
            ),
            label: 'SemPro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'adH',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sports_bar,
            ),
            label: 'Oetti',
          ),
        ],
      ),
    );
  }
}