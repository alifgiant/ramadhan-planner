import 'dart:async';

import 'package:flutter/material.dart';
import 'package:khatam_quran/quran/screens/quran_bookmarks_screen.dart';
import 'package:khatam_quran/quran/screens/quran_juz_screen.dart';
import 'package:khatam_quran/quran/screens/quran_sura_screen.dart';

class QuranListScreen extends StatefulWidget {
  final int currentTabIndex;

  QuranListScreen({
    @required this.currentTabIndex,
  });

  @override
  State<StatefulWidget> createState() {
    return _QuranListScreenState();
  }
}

class _QuranListScreenState extends State<QuranListScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> listWidgets;

  StreamSubscription changeLocaleSubsciption;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listWidgets = [
      QuranSuraScreen(),
      QuranJuzScreen(),
      QuranBookmarksScreen(),
    ];

    return listWidgets[widget.currentTabIndex];
  }
}
