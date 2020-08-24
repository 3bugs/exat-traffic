import 'package:flutter/material.dart';

class EmergencyNumberModel {
  final String name;
  final String number;
  final String details;
  final int routeId;
  final double latitude;
  final double longitude;

  EmergencyNumberModel({
    @required this.name,
    @required this.number,
    @required this.details,
    @required this.routeId,
    @required this.latitude,
    @required this.longitude,
  });

  factory EmergencyNumberModel.fromJson(Map<String, dynamic> json) {
    return EmergencyNumberModel(
      number: json['tel_num'],
      name: json['name'],
      details: json['detail'],
      routeId: json['route_id'],
      latitude: json['lat'],
      longitude: json['lng'],
    );
  }

  @override
  String toString() {
    return 'EmergencyNumberModel [name: ${this.name}, number: ${this.number}, routeId: ${this.routeId}]';
  }
}
