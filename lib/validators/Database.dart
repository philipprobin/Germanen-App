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


  /// Check If Document Exists
  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await _mainCollection.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e
      ;
    }
  }

  String? setUsernameFromDisplayname(String? displayname){
      userId= displayname;
  }


  Future<String> setDocId(String title) async {
     var list = title.split(" ");
     var newDocId = "";

     //write max two words of title
     for(var i = 0; i< list.length; i++) {
       newDocId = newDocId+list[i];
       if(i==2){
         break;
       }
     }
     //append Number if docId exists
     exist = await checkIfDocExists(newDocId);
     for(var i = 0; exist; i++){
       newDocId=newDocId+"("+i.toString()+")";
       exist = await checkIfDocExists(newDocId);
     }
      return newDocId;
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

  static Future<bool>  checkUserIdExists({
    required String userId,
  })async {
    bool result = false;
    _usersCollection
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        debugPrint("userId:: ${doc
        ['userId']}");
        if(doc['userId'] == userId){
          result = true;
        }
      });
    });
    return result;

  }

  static Future<void> deleteItem({
    required String docId,
  })async{
    DocumentReference documentReference = _mainCollection.doc(userId).collection('items').doc(docId);

    await documentReference.delete().whenComplete(() => print("gelöscht in Firebase")).catchError((e) => print(e) );
  }
}