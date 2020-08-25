import 'package:exattraffic/storage/nofication_read_prefs.dart';
import 'package:flutter/material.dart';

class NotificationModel {
  NotificationModel({
    @required this.id,
    this.name,
    @required this.detail,
    @required this.routeId,
    @required this.routeName,
    @required this.latitude,
    @required this.longitude,
    @required this.createdAt,
    @required this.read,
  });

  final int id;
  final String name;
  final String detail;
  final int routeId;
  final String routeName;
  final double latitude;
  final double longitude;
  final String createdAt;
  bool read;

  /*factory NotificationModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> routeMap = json['route'];

    return NotificationModel(
      id: json['id'],
      detail: json['detail'],
      routeId: routeMap != null ? routeMap['id'] : null,
      routeName: routeMap != null ? routeMap['name'] : null,
      latitude: json['lat'],
      longitude: json['lng'],
      createdAt: json['created_at'],
      read: false,
    );
  }*/

  static Future<NotificationModel> fromJson(Map<String, dynamic> json) async {
    Map<String, dynamic> routeMap = json['route'];

    bool read = await NotificationReadPrefs().existId(json['id'].toString());

    return NotificationModel(
      id: json['id'],
      detail: json['detail'],
      routeId: routeMap != null ? routeMap['id'] : null,
      routeName: routeMap != null ? routeMap['name'] : null,
      latitude: json['lat'],
      longitude: json['lng'],
      createdAt: json['created_at'],
      read: read,
    );
  }

  void readIt() {
    NotificationReadPrefs().addId(this.id.toString());
    read = true;
  }
}