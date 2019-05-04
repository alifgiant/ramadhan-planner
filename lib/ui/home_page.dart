
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khatam_quran/quran/screens/home_screen.dart';
import 'package:khatam_quran/service/authentication.dart';
import 'package:khatam_quran/ui/page_done.dart';
import 'package:khatam_quran/ui/page_task.dart';

class HomePage extends StatefulWidget {

  final BaseAuth auth;
  final FirebaseUser user;

  const HomePage({Key key, this.auth, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState(user);
}


class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  int _currentIndex = 1;
//  AppNotification notification = new AppNotification();
  final FirebaseUser _currentUser;

  List<Widget> _children;


  _HomePageState(this._currentUser);

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
      HomeScreen(),
    ];

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future notificationCallback(String payload) async{
    showDialog(context: context,
        builder: (_) => new AlertDialog(
            title: const Text("Here is your payload"),
            content: new Text("Payload : $payload")
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        fixedColor: Color(4283326968),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.calendarCheck),
              title: new Text("")),
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.calendar), title: new Text("")),
          BottomNavigationBarItem(
              icon: new Icon(FontAwesomeIcons.quran), title: new Text(""))
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