import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('Inhalte');

class Database{
  static String? userId;
  String? setUsernameFromDisplayname(String? displayname){
      userId= displayname;
  }
}