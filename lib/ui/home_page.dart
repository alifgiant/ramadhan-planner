
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskist/ui/page_done.dart';
import 'package:taskist/ui/page_settings.dart';
import 'package:taskist/ui/page_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskist/service/authentication.dart';

class HomePage extends StatefulWidget {

  final BaseAuth auth;
  final FirebaseUser user;

  const HomePage({Key key, this.auth, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState(user);
}


class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  int _currentIndex = 1;
  final FirebaseUser _currentUser;

  _HomePageState(this._currentUser);

  List<Widget> _children;

  @override
  void initState() {
    super.initState();

    _children = [
      DonePage(
        user: _currentUser,
      ),
      TaskPage(
        user: _currentUser,
      ),
      SettingsPage(
        user: _currentUser,
      )
    ];

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        fixedColor: Colors.deepPurple,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.calendarCheck),
              title: new Text("")),
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.calendar), title: new Text("")),
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.slidersH), title: new Text(""))
        ],
      ),
      body: _children[_currentIndex],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}