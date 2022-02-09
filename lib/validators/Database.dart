import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import  'package:intl/intl.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('posts');
final CollectionReference _usersCollection = _firestore.collection('users');


class Database{
  static int? itemCount=-1;
  static String? userId;
  static bool exist = false;



  String? setUsernameFromDisplayname(String? displayname){
      userId= displayname;
  }



  //add item
  static Future<void> addItem({
    required String title,
    required String description,
  })async{

    String date = DateFormat('dd.MM.yyyy').format(DateTime.now());

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
      "date": '$date',
      "userId": FirebaseAuth.instance.currentUser.displayName,
    };
    await _mainCollection.add(data).whenComplete(() => print("übergeben an Firebase")).catchError((e) => print(e));
  }


  static Future<void> updateItem({
    required String title,
    required String desciption,
    required String docId,
  })async{
    DocumentReference documentReference = _mainCollection.doc(userId).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": desciption,
    };

    await documentReference.set(data).whenComplete(() => print("überarbeitet in Firebase")).catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems()  {
    return _mainCollection.snapshots();
  }

  static bool  checkUserIdExists({
    required String userId,
  }){
    try {

       _usersCollection.doc(userId).get().then((doc) {

        exist = doc.exists;
        debugPrint('docname ${doc.data().length} and $userId exist? $exist');
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }

  }

  static Future<void> deleteItem({
    required String docId,
  })async{
    DocumentReference documentReference = _mainCollection.doc(userId).collection('items').doc(docId);

    await documentReference.delete().whenComplete(() => print("gelöscht in Firebase")).catchError((e) => print(e) );
  }
}