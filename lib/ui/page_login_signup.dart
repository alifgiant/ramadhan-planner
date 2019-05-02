import 'package:flutter/material.dart';
import 'package:taskist/service/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginSignupPage extends StatefulWidget {

  const LoginSignupPage({Key key, this.auth, this.onSignIn}) : super(key: key);

  final BaseAuth auth;
  final Function(FirebaseUser) onSignIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  bool _isLoading = false;
  String _email;
  String _password;
  String _errorMessage;
  FormMode _formMode;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
      ),
      body: Stack(
        children: <Widget>[_showBody(), _showCircularProgress()],
      ),
    );
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.only(top: 70.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }

  Widget _showBody() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            _showLogo(),
            _showEmailInput(),
            _showPasswordInput(),
            _showPrimaryButton(),
            _showSecondaryButton(),
            _showErrorMessage()
          ],
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading != null && _isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(height: 0.0, width: 0.0);
    }
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 100.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.only(top: 45.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: _formMode == FormMode.LOGIN
              ? new Text('Login',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white))
              : new Text('Signup',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: _validateAndSubmit,
        ));
  }

  _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (_validateAndSave()) {
      String userID = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          FirebaseUser user = await widget.auth.signIn(_email, _password);
          userID = user.uid;
          print('Signed in : $userID');
          if ( userID != null && userID.isNotEmpty ){
            widget.onSignIn(user);
          }
        } else {
          userID  = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          print('Signed up : $userID');
          _changeFormToLogin();
        }
      } catch (e) {
        print('Error $e');
        setState(() {
          _isLoading = false;
          if ( _ios() ){
            _errorMessage = e.details;
          } else {
            _errorMessage = e.message;
          }
        });
      }
    } else {}
  }

  bool _ios(){
    return Theme.of(context).platform == TargetPlatform.iOS;
}

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
        child: _formMode == FormMode.LOGIN
            ? new Text(
                'Create an account',
                style:
                    new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
              )
            : new Text(
                'Have an account ? Sign in',
                style:
                    new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
              ),
        onPressed: _formMode == FormMode.LOGIN
            ? _changeFormToSignUp
            : _changeFormToLogin);
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Text(_errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}

enum FormMode { LOGIN, SIGNUP }
