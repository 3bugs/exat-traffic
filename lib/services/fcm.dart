import 'dart:convert';

import 'package:exattraffic/models/language_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/storage/util_prefs.dart';

/*
route_1 = ทางพิเศษเฉลิมมหานคร
route_8 = ทางพิเศษเฉลิมมหานครส่วนต่อขยายเอส 1
route_9 = ทางพิเศษฉลองรัช
route_13 = ทางพิเศษบูรพาวิถี
route_19 = ทางพิเศษศรีรัช
route_27 = ทางพิเศษกาญจนาภิเษก
route_29 = ทางพิเศษอุดรรัถยา
route_31 = ทางพิเศษศรีรัช-วงแหวนรอบนอก
outside_route = นอกสายทาง
 */

/*
{title_en: ., title_th: ., lat: 13.8469852, lng: 100.5802715, route_id: 0, id_en: 57, id_th: 56, cate_id: 193, markers_id: 0}
 */
class MyFcm {
  static const int ROUTE_NOT_SPECIFIED = 0;
  static const int ROUTE_CHALERM = 1;
  static const int ROUTE_CHALERM_S1 = 8;
  static const int ROUTE_CHALONG = 9;
  static const int ROUTE_BURAPA = 13;
  static const int ROUTE_SRIRACH = 19;
  static const int ROUTE_KANCHANA = 27;
  static const int ROUTE_UDORN = 29;
  static const int ROUTE_SRIRACH_OUTER_RING = 31;

  /*static const String TOPIC_ROUTE_NOT_SPECIFIED = "outside_route";
  static const String TOPIC_ROUTE_CHALERM = "route_1";
  static const String TOPIC_ROUTE_CHALERM_S1 = "route_8";
  static const String TOPIC_ROUTE_CHALONG = "route_9";
  static const String TOPIC_ROUTE_BURAPA = "route_13";
  static const String TOPIC_ROUTE_SRIRACH = "route_19";
  static const String TOPIC_ROUTE_KANCHANA = "route_27";
  static const String TOPIC_ROUTE_UDORN = "route_29";
  static const String TOPIC_ROUTE_SRIRACH_OUTER_RING = "route_31";*/

  final BuildContext _context;
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  MyFcm(this._context);

  static String _getRouteTopic(int routeId) {
    return routeId == 0 ? 'outside_route' : 'route_$routeId';
  }

  static Future<String> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // สำหรับเรียกมาจาก RouteTrackingManager
  static void subscribeRoute(int routeId) {
    _unsubscribeAll();
    _subscribeRouteTopic(_getRouteTopic(ROUTE_NOT_SPECIFIED));
    print('FCM SUBSCRIBE TOPIC ${_getRouteTopic(ROUTE_NOT_SPECIFIED)}');

    if (routeId != 0) {
      _subscribeRouteTopic(_getRouteTopic(routeId));
      print('FCM SUBSCRIBE TOPIC ${_getRouteTopic(routeId)}');
    }
  }

  static void _unsubscribeAll() {
    _unsubscribeRouteTopic(_getRouteTopic(ROUTE_NOT_SPECIFIED));
    _unsubscribeRouteTopic(_getRouteTopic(ROUTE_CHALERM));
    _unsubscribeRouteTopic(_getRouteTopic(ROUTE_CHALERM_S1));
    _unsubscribeRouteTopic(_getRouteTopic(ROUTE_CHALONG));
    _unsubscribeRouteTopic(_getRouteTopic(ROUTE_BURAPA));
    _unsubscribeRouteTopic(_getRouteTopic(ROUTE_SRIRACH));
    _unsubscribeRouteTopic(_getRouteTopic(ROUTE_KANCHANA));
    _unsubscribeRouteTopic(_getRouteTopic(ROUTE_UDORN));
    _unsubscribeRouteTopic(_getRouteTopic(ROUTE_SRIRACH_OUTER_RING));
  }

  static void _subscribeRouteTopic(String routeTopic) {
    _firebaseMessaging.subscribeToTopic(routeTopic);
  }

  static void _unsubscribeRouteTopic(String routeTopic) {
    _firebaseMessaging.unsubscribeFromTopic(routeTopic);
  }

  static void setNotificationStatus(bool isOn) {
    if (isOn) {
      _subscribeRouteTopic(_getRouteTopic(ROUTE_NOT_SPECIFIED));
    } else {
      _unsubscribeAll();
    }
  }

  configFcm() async {
    UtilPrefs utilPrefs = Provider.of<UtilPrefs>(_context, listen: false);
    setNotificationStatus(await utilPrefs.getNotificationStatus());

    _firebaseMessaging.requestNotificationPermissions(); // จำเป็นสำหรับ ios

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //onMessage: {notification: {title: EXAT TRAFFIC, body: อุบัติเหตุทางด่วน}, data: {title_en: Incident, title_th: อุบัติเหตุทางด่วน, lat: 13.8469852, lng: 100.5802715, route_id: 9, id_en: 33, id_th: 32, cate_id: 193, markers_id: 416}}

        print("onMessage: $message");
        //_showItemDialog(message);
        //alert(context, "Firebase Cloud Messaging", message.toString());

        if (message.containsKey('data')) {
          print('***** MESSAGE CONTAINS DATA *****');

          try {
            final Map<String, dynamic> dataMap = Map<String, dynamic>.from(message['data']);
            final String titleTh = dataMap['title_th'];
            final String titleEn = dataMap['title_en'];

            LanguageModel language = Provider.of<LanguageModel>(_context, listen: false);
            alert(
              _context,
              "",
              (language == null || language.lang == LanguageName.thai) ? titleTh : titleEn,
            );
          } catch (e) {
            print('ERROR: ${e.toString()}');
          }
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
