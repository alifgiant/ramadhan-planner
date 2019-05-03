//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//class AppNotification {
//  FlutterLocalNotificationsPlugin flutterNotifPlugin;
//
//  void init(SelectNotificationCallback onselect) {
//    var androidNotifSetting = new AndroidInitializationSettings('ic_launcher');
//    var iosNotifSetting = new IOSInitializationSettings();
//    var notifSetting =
//        new InitializationSettings(androidNotifSetting, iosNotifSetting);
//    flutterNotifPlugin = new FlutterLocalNotificationsPlugin();
//    flutterNotifPlugin.initialize(
//      notifSetting,
//    );
//  }
//
//  Future showNotificationWithDefaultSound() async {
//    String channelDescription = "notification for tadarus reminder";
//    String channelId = "1";
//    String channelName = "Tadarus channel";
//    var androidChannel = new AndroidNotificationDetails(
//        channelId, channelName, channelDescription);
//
//    var iosChannel = new IOSNotificationDetails();
//
//    var channelSpecifics = new NotificationDetails(androidChannel, iosChannel);
//    await flutterNotifPlugin.show(
//        0, 'new Post', 'How to show notification in flutter', channelSpecifics,
//        payload: 'Default sound ');
//  }
//}
