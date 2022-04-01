import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/screens/user_list.dart';

import '../widgets/app_toolbar.dart';
import 'add_screen.dart';

class BeerListPage extends StatefulWidget {
  const BeerListPage({Key? key}) : super(key: key);

  @override
  _BeerListPageState createState() => _BeerListPageState();
}

class _BeerListPageState extends State<BeerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          title: AppToolbar(
            sectionName: 'Germanen App',
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.subject,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                UserList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
