import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskist/service/authentication.dart';
import 'package:taskist/ui/page_login_signup.dart';
import 'package:taskist/ui/home_page.dart';

class RootPage extends StatefulWidget {

  final BaseAuth auth;

  const RootPage({Key key, this.auth}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RootPageState();

}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  FirebaseUser _user;

  @override
  void initState() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _user = user;
        print('CURRENT USER : $user');
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
    super.initState();
  }

  void _onLoggedIn(FirebaseUser user) {
    setState(() {
      _user = user;
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      });
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED :
        print('AUTH STATE NOT DETERMIND}');
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN :
        print('AUTH STATE NOT LOGGED IN}');
        return new LoginSignupPage(
          auth: widget.auth,
          onSignIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN :
        print('AUTH STATE LOGGED IN }');
        if ( _user != null && _user.uid.isNotEmpty) {
          return new HomePage(auth: widget.auth, user: _user);
        } else
          return _buildWaitingScreen();
        break;
      default :
        return _buildWaitingScreen();
    }
  }

}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN
}
