import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/storage/util_prefs.dart';

class MyFcm {
  final BuildContext _context;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  MyFcm(this._context);

  configFcm() async {
    UtilPrefs utilPrefs = Provider.of<UtilPrefs>(_context, listen: false);

    if (await utilPrefs.getNotification()) {
      _firebaseMessaging.subscribeToTopic('message_incident');
      _firebaseMessaging.subscribeToTopic('message_event');
    } else {
      _firebaseMessaging.unsubscribeFromTopic('message_incident');
      _firebaseMessaging.unsubscribeFromTopic('message_event');
    }

    _firebaseMessaging.requestNotificationPermissions(); // จำเป็นสำหรับ ios

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {

        //onMessage: {notification: {title: EXAT TRAFFIC, body: อุบัติเหตุทางด่วน}, data: {title_en: Incident, title_th: อุบัติเหตุทางด่วน, lat: 13.8469852, lng: 100.5802715, route_id: 9, id_en: 33, id_th: 32, cate_id: 193, markers_id: 416}}

        print("onMessage: $message");
        //_showItemDialog(message);
        //alert(context, "Firebase Cloud Messaging", message.toString());

        if (message.containsKey('data')) {
          print('***** MESSAGE CONTAINS DATA *****');

          final Map<String, dynamic> dataMap = message['data'];
          final String titleTh = dataMap['title_th'];
          final String titleEn = dataMap['title_en'];
          alert(_context, "แจ้งเตือน", titleTh);
        } else {
          print('***** MESSAGE DOES NOT CONTAIN DATA *****');
        }
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