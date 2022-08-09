import 'package:e_commerce_app_admin/database/db_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AuthService{
  static final _auth=FirebaseAuth.instance;
  static User? get user =>_auth.currentUser;


  static Future<bool> login(String email,String password) async{
    final  credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return DbHelper().isadmin(credential.user!.uid);
  }
  static Future<void> logout()=>_auth.signOut();


}