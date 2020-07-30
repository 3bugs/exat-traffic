import 'package:flutter/material.dart';

class RestAreaModel {
  RestAreaModel({
    @required this.name,
    @required this.imageUrl,
    @required this.hasParkingLot,
    @required this.hasToilet,
    @required this.hasGasStation,
    @required this.hasRestaurant,
    @required this.hasCafe,
  });

  final String name;
  final String imageUrl;
  final bool hasParkingLot;
  final bool hasToilet;
  final bool hasGasStation;
  final bool hasRestaurant;
  final bool hasCafe;
}