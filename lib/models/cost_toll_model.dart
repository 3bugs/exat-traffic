import 'package:flutter/material.dart';

import 'package:exattraffic/constants.dart' as Constants;

class CostTollModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int cost4Wheels;
  final int cost6To10Wheels;
  final int costOver10Wheels;
  bool selected;

  CostTollModel({
    @required this.id,
    @required this.name,
    @required this.latitude,
    @required this.longitude,
    @required this.cost4Wheels,
    @required this.cost6To10Wheels,
    @required this.costOver10Wheels,
    @required this.selected,
  });

  factory CostTollModel.fromJson(Map<String, dynamic> json) {
    return CostTollModel(
      id: json['id'],
      name: json['name'],
      latitude: json['lat'],
      longitude: json['lng'],
      cost4Wheels: json['cost_less4'],
      cost6To10Wheels: json['cost_4to10'],
      costOver10Wheels: json['cost_over10'],
      selected: false,
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
