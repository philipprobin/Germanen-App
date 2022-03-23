import 'package:flutter/material.dart';
import 'package:germanenapp/screens/sempro_page.dart';

import 'content_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    ContentPage(),
    SemproPage(),
    //Text('Home'),
    //Text('Sempro'),
  ];

  void _onItemTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        showUnselectedLabels: false,
        onTap: _onItemTap,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'adH'),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/brochure_grey.png',
              height: 25,
            ),
            label: 'SemPro',
            activeIcon: Image.asset(
              'assets/brochure_red.png',
              height: 25,
            ),
          ),
        ],
      ),
    );
  }
}

/*
body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        showUnselectedLabels: false,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'adH'),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/brochure_grey.png',
              height: 25,
            ),
            label: 'SemPro',
            activeIcon: Image.asset(
              'assets/brochure_red.png',
              height: 25,
            ),
          ),
        ],
      ),


class MytemList extends StatelessWidget {
  const MytemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Database.readItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SnackBar(
              content: const Text('Failed'),
            );
          }
          else if (snapshot.hasData || snapshot.data != null) {
            return ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                   return Container(
                     height: 100,
                     color: Colors.red,
                   );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: 16.0,),
                itemCount: snapshot.data!.docs.length
            );
          }
          return Container(
          );
        }
    );
  }
}

 */
