import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final CollectionReference _mainCollection = _firestore.collection('posts');
final CollectionReference _usersCollection = _firestore.collection('users');
final CollectionReference _beerCollection = _firestore.collection('beers');
final CollectionReference _semproCollection = _firestore.collection('sempros');

final CollectionReference _documentsCollection = _firestore.collection('documents');
final CollectionReference _commentsCollection =
    _firestore.collection('comments');

class Database {
  static int? itemCount = -1;
  static String? userId;
  static bool exist = false;
  static final int shift = 5;


  static String encrypt(String plainText) {
    String cipherText = "";
    for (int i = 0; i < plainText.length; i++) {
      int charCode = plainText.codeUnitAt(i);
      charCode = (charCode + shift) % 65536; // 65536 is the number of Unicode characters
      cipherText += String.fromCharCode(charCode);
    }
    return cipherText;
  }

  static String decrypt(String cipherText) {
    String plainText = "";
    for (int i = 0; i < cipherText.length; i++) {
      int charCode = cipherText.codeUnitAt(i);
      charCode = (charCode - shift + 65536) % 65536; // 65536 is the number of Unicode characters
      plainText += String.fromCharCode(charCode);
    }
    return plainText;
  }

  void setUsernameFromDisplayName(String? displayName) {
    userId = displayName;
  }

  static String? getDisplayName() {
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
    String folder,
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      UploadTask uploadTask = storage.ref('$folder/$fileName').putFile(file);
      return await (await uploadTask)
          .storage
          .ref('$folder/$fileName')
          .getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      debugPrint('ERROR ${e}');
      return "";
    }
  }

  //adds url of image in storage in the right doc
  static Future<void> _addPathToDatabase(String displayName, String folder,
      String url, DocumentReference<Object?>? doc) async {
    try {
      //path is set to Users collection
      if (folder == "profile_pictures" && doc != null) {
        //upload to users collection
        await doc
            .update({"image": url})
            .whenComplete(() => print("Bilder hochgeladen"))
            .catchError((e) => print(e));
      } else if (doc != null) {
        //if not any profile picture its a post
        await doc
            .update({
              folder: FieldValue.arrayUnion([url])
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
    required String description,
    required List<File> files,
  }) async {
    //Sting date = DateFormat('yyyy.MM.dd.Hms').format(DateTime.now());
    String date = DateTime.now().toString();
    debugPrint('date $date');

    Map<String, dynamic> data = <String, dynamic>{
      "description": encrypt(description),
      "date": encrypt('$date'),
      "userId": encrypt(getDisplayName()!),
      "images": [],
      "likes": [],
      "docId": ""
    };

    //get doc
    var doc = await _mainCollection
        .add(data)
        .whenComplete(() => print("übergeben an Firebase"));

    //save to right folder
    uploadFilesSetPaths("", "images", doc, files);

    //set docId
    var snapshot = await _mainCollection.where('date', isEqualTo: encrypt(date)).get();
    debugPrint('snapshot: ${snapshot.docs}');
    for (var doc in snapshot.docs) {
      doc.reference.update({'docId': doc.id});
    }
  }

  static Future<void> uploadFilesSetPaths(String displayName, String folder,
      DocumentReference<Object?> doc, List<File> files) async {
    if (files.isNotEmpty) {
      files.forEach((file) async {
        //get last proper filepath
        var splitList = file.path.split('/');
        //safe Url List to db
        _addPathToDatabase(
            displayName,
            folder,
            await uploadImageFile(folder, file.path,
                '${doc.id}/${splitList[splitList.length - 1]}'),
            doc);
        debugPrint(
            'filepath ${file.path} file ${splitList[splitList.length - 1]}');
      });
    } else {
      //if list is empty delete: image = ""
      _addPathToDatabase(displayName, folder, "", doc);
    }
  }

  static Future<void> updateItem({
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReference =
        _mainCollection.doc(userId).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
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

  static Future<QuerySnapshot<Object?>> readSempros() {
    return _semproCollection.get();
  }

  static Stream<QuerySnapshot> readBeers() {
    return _beerCollection.orderBy('totalBeers').snapshots();
  }

  static Future<DocumentSnapshot> readUser(String? userId) {
    return _usersCollection.doc(userId).get();
  }

  static Stream<QuerySnapshot> readComments(
    String postId,
  ) {
    debugPrint(
        "Database readComments ${_commentsCollection.where('postId', isEqualTo: postId).snapshots()}");
    return _commentsCollection.where('postId', isEqualTo: postId).snapshots();
    //order .orderBy('timestamp', descending: true)
  }

  static Stream<DocumentSnapshot> readUserBeers(String? userId) {
    return _beerCollection.doc(userId).snapshots();
  }

  static Future<DocumentSnapshot> readPassword() {
    return _documentsCollection.doc("germanen_passwort").get();
  }


  //create set and get users amount
  static void updateTotalBeerAmount(String userId, String beerType) async {
    //users type users, paidBeer
    DocumentReference<Object?>? documentReference =
        _beerCollection.doc(userId);

    DocumentSnapshot<Object?>? documentSnapshot =
        await _beerCollection.doc(userId).get();

    if (documentSnapshot.exists) {
      debugPrint('snap exists');
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      var beers = data![beerType];
      int totalAmountOfBeers = 0;
      for (var entry in beers) {
        if (entry['amount'] != null) {
          totalAmountOfBeers += entry['amount'] as int;
        }
      }
      if (beerType == 'beers') {
        await documentReference.update(
            {'totalBeers': totalAmountOfBeers}).catchError((e) => print(e));
      }
      if (beerType == 'paidBeers') {
        debugPrint('pay beers');
        await documentReference.update(
            {'totalPaidBeers': totalAmountOfBeers}).catchError((e) => print(e));
      }
    }
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
    required String postId,
  }) async {
    var doc = await _mainCollection.doc(postId).get();
    await doc.reference
        .delete()
        .whenComplete(() => print("gelöscht in Firebase"))
        .catchError((e) => print(e));
  }

  static Future<void> setLike({
    required String postId,
    required bool isLiked,
    required String userId,
  }) async {
    var doc = await _mainCollection.doc(postId).get();
    try {
      isLiked
          ? await doc.reference.update({
              'likes': FieldValue.arrayRemove([userId])
            })
          : await doc.reference.update({
              'likes': FieldValue.arrayUnion([userId])
            });
    } catch (e) {
      await doc.reference.set({
        'likes': FieldValue.arrayUnion([userId])
      });
    }
  }

  static Future<int> getLike({
    required String postId,
  }) async {
    var doc = await _mainCollection.doc(postId).get();
    var likes = [];
    if (doc.exists) {
      Map<String, dynamic> data = doc.get('likes');
      likes = data['likes'];
    }
    return likes.length;
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

  Future<void> submitBeerAmount(String value, String userId) async {
    String date = DateTime.now().toString();
    Map<String, dynamic> data = <String, dynamic>{
      "amount": int.parse(value),
      "date": '$date',
    };

    DocumentReference<Object?>? doc = await _beerCollection.doc('${userId}');

    await doc.update({
      'beers': FieldValue.arrayUnion([data])
    }).catchError((e) => print(e));
  }

  Future<void> payBeers(String userId) async {
    String date = DateTime.now().toString();

    DocumentSnapshot<Object?>? doc = await _beerCollection.doc(userId).get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      var beers = data!['beers'];
      int totalAmountOfBeers = 0;
      for (var entry in beers) {
        if (entry['amount'] != null) {
          totalAmountOfBeers += entry['amount'] as int;
          debugPrint('amount ${entry['amount']} date ${entry['date']}');
        }
      }

      DocumentReference<Object?>? documentReference =
          _beerCollection.doc(userId);

      //transfer to paidArray
      await documentReference
          .update({'paidBeers': FieldValue.arrayUnion(data['beers'])})
          .whenComplete(() => print("beers paid"))
          .catchError((e) => print(e));

      //add paydate with amount
      Map<String, dynamic> payday = <String, dynamic>{
        "totalAmountPaid": totalAmountOfBeers,
        "onDate": '$date',
      };

      await documentReference
          .update({
            'paidBeers': FieldValue.arrayUnion([payday])
          })
          .whenComplete(() => print("paydate"))
          .catchError((e) => print(e));

      //set Beers array to zero
      await documentReference
          .update({'beers': FieldValue.arrayRemove(beers)})
          .whenComplete(() => print("paydate"))
          .catchError((e) => print(e));
    }
    Database.updateTotalBeerAmount(userId, 'beers');
    Database.updateTotalBeerAmount(userId, 'paidBeers');
  }

  static Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static void handleSignUpError(String type, String e, BuildContext context) {
    String messageToDisplay;
    debugPrint('exception $e');
    switch (e) {
      case 'email-already-in-use':
        messageToDisplay = 'Diese E-Mail wird schon verwendet';
        break;
      case 'invalid-email':
        messageToDisplay = 'Die E-Mail ist ungültig';
        break;
      case 'operation-not-allowed':
        messageToDisplay = 'Diese Operation ist nicht erlaubt';
        break;
      case 'weak-password':
        messageToDisplay = 'Das Passwort ist zu schwach';
        break;
      case 'user-not-found':
        messageToDisplay = 'Falsche E-Mail';
        break;
      case 'wrong-password':
        messageToDisplay = 'Falsches Passwort';
        break;

      default:
        messageToDisplay = e;
        break;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('$type fehlgeschlagen'),
              content: Text(messageToDisplay),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            ));
  }

  static uploadComment(String userId, String comment, String postId) async {
    String date = DateTime.now().toString();
    debugPrint('date $date');

    Map<String, dynamic> data = <String, dynamic>{
      "userId": Database.encrypt(userId),
      "comment": Database.encrypt(comment),
      "timestamp": Database.encrypt('$date'),
      "postId": postId,
    };

    //upload
    await _commentsCollection
        .add(data)
        .whenComplete(() => print("übergeben an Firebase"));
  }
}
