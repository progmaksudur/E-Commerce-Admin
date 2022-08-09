import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String userCollection='admins';
class DbHelper{

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool>isadmin(String adminId)async{
    final snapshot = await _db.collection(userCollection).doc(adminId).get();
    return snapshot.exists;
  }

}