import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth{
  Future<FirebaseUser> signInGoogle(Function onError);
  Future<FirebaseUser> signinAnon();

  Future<FirebaseUser> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();

  Future<void> sendResetEmail(String email);

}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Future<FirebaseUser> signInGoogle(Function onError) async {
    GoogleSignInAccount account = await _googleSignIn.signIn().catchError(
        onError);
    final GoogleSignInAuthentication googleAuth = await account.authentication;
    return _firebaseAuth.signInWithCredential(GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    )).catchError(onError);
  }

  @override
  Future<FirebaseUser> signinAnon() async {
    FirebaseUser firebaseUser = await _firebaseAuth.signInAnonymously();
    return firebaseUser;
  }

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

  @override
  Future<Function> sendResetEmail(String email) async{
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

}