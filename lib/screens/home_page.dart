
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/screens/add_screen.dart';
import 'package:germanenapp/widgets/app_toolbar.dart';
import 'package:provider/provider.dart';

import '../authentication_service.dart';
import 'item_list.dart';
// @dart=2.9
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: AppToolbar(
          sectionName: 'Germanen-App',
      )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddScreen(),
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
                ElevatedButton(
                    onPressed:  () {

                    },
                    child: Text("Neu Laden"),
                ),
                Text("Hello ${FirebaseAuth.instance.currentUser.displayName}"),
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
/*
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
