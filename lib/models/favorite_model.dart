import 'package:flutter/material.dart';

import 'package:exattraffic/models/marker_model.dart';

enum FavoriteType {cctv, place}

class FavoriteModel {
  FavoriteModel({
    @required this.name,
    @required this.description,
    @required this.type,
    this.marker,
    this.placeId,
  });

  final String name;
  final String description;
  final FavoriteType type;
  final MarkerModel marker; // cctv favorite
  final String placeId; // place favorite
}