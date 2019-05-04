import 'package:firebase_messaging/firebase_messaging.dart';

class FcmNotification{
  final  _firebaseMessaging = FirebaseMessaging();

  void requestPermission(){
    _firebaseMessaging.requestNotificationPermissions();
  }

  void init(){
    requestPermission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
  }
}