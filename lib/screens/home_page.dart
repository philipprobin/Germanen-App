import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/screens/sempro/sempro_page.dart';

import '../utils/app_color.dart';
import 'users/beer_page.dart';
import 'content/content_page.dart';

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
      body: DoubleBackToCloseApp(
        child: _widgetOptions[currentIndex],
        snackBar: const SnackBar(
          content: Text('Zum beenden nochmal Tippen'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.primary,
        selectedItemColor: AppColor.secondary,
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
            icon: Icon(Icons.home_rounded),
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
