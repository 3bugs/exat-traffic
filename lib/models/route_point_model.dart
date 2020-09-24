import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exattraffic/etc/utils.dart';
import 'route_data.dart';

class RoutePointModel {
  final int routeId;
  final double latitude;
  final double longitude;

  RoutePointModel({
    @required this.routeId,
    @required this.latitude,
    @required this.longitude,
  });

  factory RoutePointModel.fromList(Map<String, dynamic> point) {
    return RoutePointModel(
      routeId: point['id'],
      latitude: point['lat'].toDouble(),
      longitude: point['lng'].toDouble(),
    );
  }

  static List<RoutePointModel> _routePointList;
  static int currentRoute = 0;

  static List<RoutePointModel> get routePointList {
    if (_routePointList == null) {
      _routePointList = routeDataList.map((point) => RoutePointModel.fromList(point)).toList();
    }
    return _routePointList;
  }

  static void findCurrentRoute(List params) {
    Position currentPosition = params[0];
    Function callback = params[1];

    int beginTime = DateTime.now().millisecondsSinceEpoch;
    int count = 0;
    Map<int, int> routeCountMap = Map();
    //double sumDistance = 0.0;

    routePointList.forEach((routePoint) async {
      count++;

      /*double distanceMeters = await geolocator.distanceBetween(
        routePoint.latitude,
        routePoint.longitude,
        13.722565,
        100.552465,
      );*/
      double distanceMeters = getDistance(
        routePoint.latitude,
        routePoint.longitude,
        currentPosition.latitude,
        currentPosition.longitude,
      );
      //print('$count: $distanceMeters');

      //sumDistance += distanceMeters;

      if (distanceMeters <= 10) {
        int routeId = routePoint.routeId;
        if (!routeCountMap.containsKey(routeId)) {
          routeCountMap[routeId] = 0;
        }
        routeCountMap[routeId]++;
      }

      if (count >= RoutePointModel.routePointList.length) {
        if (routeCountMap.isEmpty) {
          currentRoute = 0;
        } else {
          int routeId = 0, routeCount = 0;
          routeCountMap.forEach((key, value) {
            if (routeId == 0 && routeCount == 0) {
              routeId = key;
              routeCount = value;
            } else {
              if (value > routeCount) {
                routeId = key;
                routeCount = value;
              }
            }
          });
          currentRoute = routeId;
        }

        int endTime = DateTime.now().millisecondsSinceEpoch;
        print(
            'ROUTE POINTS PROCESS TIME: ${((endTime - beginTime) / 1000).toStringAsFixed(2)} วินาที');
        //print('DISTANCE: $sumDistance, CURRENT ROUTE ID: $currentRoute');

        if (callback != null) {
          callback(currentRoute);
        }

        /*alert(
          context,
          "",
          "Total distance: $sumDistance, Duration: ${((endTime - beginTime) / 1000).toStringAsFixed(2)} วินาที",
        );*/
      }
    });
  }
}
