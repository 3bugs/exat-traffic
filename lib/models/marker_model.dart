import 'package:flutter/material.dart';

import 'package:exattraffic/constants.dart' as Constants;

class MarkerModel {
  final int id;
  final String name;
  final int routeId;
  final String routeName;
  final double latitude;
  final double longitude;
  final int categoryId;
  final String streamMobile;
  final String streamWeb;
  /*final String imageType;
  final String imageSize;*/
  final String imagePath;
  final String direction;
  bool selected;
  bool notified;

  MarkerModel({
    @required this.id,
    @required this.name,
    @required this.routeId,
    @required this.routeName,
    @required this.latitude,
    @required this.longitude,
    @required this.categoryId,
    @required this.streamMobile,
    @required this.streamWeb,
    /*@required this.imageType,
    @required this.imageSize,*/
    @required this.imagePath,
    @required this.direction,
    @required this.selected,
    @required this.notified,
  });

  factory MarkerModel.fromJson(Map<String, dynamic> json) {
    return MarkerModel(
      id: json['id'],
      name: json['name'],
      routeId: json['route_id'],
      routeName: json['route_name'],
      latitude: json['lat'],
      longitude: json['lng'],
      categoryId: json['cate_id'],
      streamMobile: json['stream_mobile'],
      streamWeb: json['stream_web'],
      imagePath: json['image_path'],
      direction: json['direction'],
      selected: false,
      notified: false,
    );
  }

  @override
  String toString() {
    return '${this.name}';
  }
}

/*
{
  id: 2480,
  name: "ดินแดง (น.1-03)",
  lat: 13.7657813,
  lng: 100.5487698,
  cate_id: 24,
  part_toll: null,
  cost_less4: 50,
  cost_4to10: 75,
  cost_over10: 110
},
*/
