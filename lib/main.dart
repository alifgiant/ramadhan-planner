import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskist/service/authentication.dart';
import 'package:taskist/ui/root_page.dart';

Future<Null> main() async {
  runApp(new TaskistApp());
}
class TaskistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Taskist",
      home: new RootPage(auth: Auth()),
      theme: new ThemeData(primarySwatch: Colors.blue),
    );
  }
}