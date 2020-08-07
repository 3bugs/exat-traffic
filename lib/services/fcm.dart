import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:exattraffic/etc/utils.dart';

class MyFcm {
  final BuildContext context;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  MyFcm(this.context);

  configFcm() {
    _firebaseMessaging.subscribeToTopic('message_incident');
    _firebaseMessaging.subscribeToTopic('message_event');

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
        alert(context, "Firebase Cloud Messaging", message.toString());
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
  }

  // for FCM (handle background messages)
  // Note: the protocol of data and notification are in line with the fields defined by a RemoteMessage.
  // https://firebase.google.com/docs/reference/android/com/google/firebase/messaging/RemoteMessage
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print('+++++++++++++++++++++++++++++++++++++++++++++');
      print('+++++ FCM Background Data Message +++++++++++');
      print(data);
      print('---------------------------------------------');
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print('+++++++++++++++++++++++++++++++++++++++++++++');
      print('+++++ FCM Background Notification Message +++');
      print(notification);
      print('---------------------------------------------');
    }

    return null;
    // Or do other work.
  }
}