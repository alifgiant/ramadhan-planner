import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  Future<FirebaseUser> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth{
   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> signIn(String email, String password) async {
    FirebaseUser firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return firebaseUser;
  }

   @override
   Future<String> signUp(String email, String password) async{
     FirebaseUser firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
     return firebaseUser.uid;
   }

   @override
   Future<FirebaseUser> getCurrentUser() async {
     return await _firebaseAuth.currentUser();
   }

   @override
   Future<Function> sendEmailVerification() async{
     FirebaseUser user = await _firebaseAuth.currentUser();
     user.sendEmailVerification();
   }

   @override
   Future<bool> isEmailVerified() async{
     FirebaseUser user = await _firebaseAuth.currentUser();
     return user.isEmailVerified;
   }


}