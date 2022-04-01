import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final CollectionReference _mainCollection = _firestore.collection('posts');
final CollectionReference _usersCollection = _firestore.collection('users');
final CollectionReference _beerCollection = _firestore.collection('beers');

class Database {
  static int? itemCount = -1;
  static String? userId;
  static bool exist = false;

  String? setUsernameFromDisplayName(String? displayName) {
    userId = displayName;
  }

  String? getDisplayName() {
    return FirebaseAuth.instance.currentUser?.displayName;
  }

  //downloadImage
  static Future<String> downloadImageUrl(String imageName) async {
    String downloadURL =
        await storage.ref('images/$imageName').getDownloadURL();
    return downloadURL;
  }

  //uploadFile
  static Future<String> uploadImageFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      UploadTask uploadTask = storage.ref('images/$fileName').putFile(file);
      return await (await uploadTask)
          .storage
          .ref('images/$fileName')
          .getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      debugPrint('ERROR ${e}');
      return "";
    }
  }

  static Future<void> _addPathToDatabase(
      String url, DocumentReference<Object?>? doc) async {
    try {
      if (doc != null) {
        await doc
            .update({
              'images': FieldValue.arrayUnion([url])
            })
            .whenComplete(() => print("Bilder hochgeladen"))
            .catchError((e) => print(e));
      }
    } catch (e) {
      debugPrint('Error addPathToDatabase');
    }
  }

  //unnecessary function for fetching all 'images/'
  Future<List<Map<String, dynamic>>> loadImages() async {
    List<Map<String, dynamic>> files = [];
    final firebase_storage.ListResult results =
        await storage.ref('images/').listAll();

    debugPrint('hasSize ${results}');
    final List<firebase_storage.Reference> allFiles = results.items;
    debugPrint('hasSize2 ${allFiles}');
    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      debugPrint('hasSize3 ${fileUrl}');
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
      });
    });
    return files;
  }

  //add item
  Future<void> addItem({
    required String title,
    required String description,
    required List<File> files,
  }) async {
    //Sting date = DateFormat('yyyy.MM.dd.Hms').format(DateTime.now());
    String date = DateTime.now().toString();
    debugPrint('date $date');

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
      "date": '$date',
      "userId": getDisplayName(),
      "images": [],
    };

    //get doc
    var doc = await _mainCollection
        .add(data)
        .whenComplete(() => print("übergeben an Firebase"));

    //save to right folder
    if (files.isNotEmpty) {
      files.forEach((file) async {
        //get last proper filepath
        var splitList = file.path.split('/');
        //safe Url List to db
        _addPathToDatabase(
            await uploadImageFile(
                file.path, '${doc.id}/${splitList[splitList.length - 1]}'),
            doc);
        debugPrint(
            'filepath ${file.path} file ${splitList[splitList.length - 1]}');
      });
    }
  }

  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReference =
        _mainCollection.doc(userId).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("überarbeitet in Firebase"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    return _mainCollection.orderBy('date').snapshots();
  }

  static Stream<QuerySnapshot> readBeers() {
    return _beerCollection.snapshots();
  }

  static bool checkUserIdExists({
    required String userId,
  }) {
    try {
      _usersCollection.doc(userId).get().then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }

  Future<void> deleteItem({
    required String date,
  }) async {
    var snapshot = await _mainCollection.where('date', isEqualTo: date).get();
    debugPrint('snapshot: ${snapshot.docs}');
    for (var doc in snapshot.docs) {
      await doc.reference
          .delete()
          .whenComplete(() => print("gelöscht in Firebase"))
          .catchError((e) => print(e));
    }
  }

  static Future<String> getSemproUri() async {
    String url = '';
    var snapshot = await _firestore.collection('sempros').orderBy('date').get();
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data = snapshot.docs[0].data();
      url = data['url'];
    }
    return url;
  }

  Future<void> submitBeerAmount(String value) async {
    String date = DateTime.now().toString();
    Map<String, dynamic> data = <String, dynamic>{
      "amount": int.parse(value),
      "date": '$date',
    };

    DocumentReference<Object?>? doc =
        await _beerCollection.doc('${getDisplayName()}');

    await doc
        .update({
          'beers': FieldValue.arrayUnion([data])
        })
        .whenComplete(() => print("Bilder hochgeladen"))
        .catchError((e) => print(e));
  }
}
