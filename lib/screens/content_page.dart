import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authentication_service.dart';
import '../widgets/app_toolbar.dart';
import 'add_screen.dart';
import 'item_list.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          title: AppToolbar(
            sectionName: 'Germanen-App',
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddScreen(),
            ),
          );
        },
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                ItemList(),
                Text("Hello ${FirebaseAuth.instance.currentUser?.displayName}"),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();
                  },
                  child: Text("Sign out"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
