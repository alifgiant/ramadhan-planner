import 'package:flutter/material.dart';

class Background{
  Widget buildImageBackground() {
    return new Container(
      height: 250,
      decoration: new BoxDecoration(
        image: new DecorationImage(
            image: new AssetImage("assets/images/bgpattern.png"),
            fit: BoxFit.cover
        ),
      ),
      child: null /* add child content here */,
    );
  }
}