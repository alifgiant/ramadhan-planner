import 'package:flutter/material.dart';
import 'package:khatam_quran/quran/screens/about_screen.dart';
import 'package:khatam_quran/quran/screens/home_screen.dart';
import 'package:khatam_quran/quran/screens/settings_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => HomeScreen(),
    '/settings': (context) => SettingsScreen(),
    '/about': (context) => AboutScreen(),
  };
}
