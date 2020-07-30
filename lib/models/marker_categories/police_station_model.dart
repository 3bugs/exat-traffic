import 'package:flutter/material.dart';

class PoliceStationModel {
  PoliceStationModel({
    @required this.name,
    @required this.imageUrl,
    @required this.phone,
  });

  final String name;
  final String imageUrl;
  final String phone;
}