import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/models/route_point_model.dart';
import 'package:exattraffic/services/fcm.dart';
import 'package:exattraffic/storage/util_prefs.dart';

// todo: READ https://www.didierboelens.com/2019/01/futures-isolates-event-loop/

class RouteTrackingManager {
  BuildContext _context;
  StreamSubscription<Position> _positionStreamSubscription;

  RouteTrackingManager(this._context) {
    _setupLocationUpdate();
  }

  void _setupLocationUpdate() {
    const LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.medium,
      //distanceFilter: 500,
      timeInterval: 10000,
    );

    Stream<Position> positionStream;
    try {
      positionStream = Geolocator().getPositionStream(locationOptions);
      if (positionStream != null) {
        _positionStreamSubscription = positionStream.listen((Position position) {
          _handlePositionChanged(position);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _handlePositionChanged(Position currentPosition) {
    compute(RoutePointModel.findCurrentRoute, [
      currentPosition,
      _handleRouteFound, // not working
    ]);

    // handle route found ใช้วิธี delay 15 วินาที
    Future.delayed(Duration(seconds: 15), () async {
      UtilPrefs utilPrefs = Provider.of<UtilPrefs>(_context, listen: false);
      if (await utilPrefs.getNotificationStatus()) {
        MyFcm.subscribeRoute(RoutePointModel.currentRoute);
      }
    });
  }

  static void _handleRouteFound(int currentRoute) async {
    print('--- CURRENT ROUTE ID: $currentRoute');

    // บรรทัดนี้ error เพราะไม่สามารถรัน native code ใน isolate ได้
    //MyFcm.subscribeRoute(currentRoute);

    /*UtilPrefs utilPrefs = Provider.of<UtilPrefs>(RouteTracking.context, listen: false);
    if (await utilPrefs.getNotificationStatus()) {
      MyFcm.subscribeRoute(currentRoute);
    }*/
  }

  void cancel() {
    _positionStreamSubscription.cancel();
  }
}
