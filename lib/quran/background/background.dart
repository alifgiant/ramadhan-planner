import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Background {
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

  Widget buildPrivacyPolicy() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: new InkWell(
          child: new Text('Privacy Policy'),
          onTap: () => _launchURL()
      ),
    );
  }

  _launchURL() async {
    const url = 'https://khatam-quran.flycricket.io/privacy.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}