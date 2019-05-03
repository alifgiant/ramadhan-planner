import 'package:flutter/material.dart';
import 'package:khatam_quran/quran/screens/quran_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return QuranScreen();
  }
}
