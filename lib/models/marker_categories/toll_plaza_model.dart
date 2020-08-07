import 'package:flutter/material.dart';

class TollPlazaModel {
  final String name;
  final String imageUrl;
  final int cost4Wheels;
  final int cost6To10Wheels;
  final int costOver10Wheels;
  final List<TollPlazaLaneModel> laneList;

  TollPlazaModel({
    @required this.name,
    @required this.imageUrl,
    @required this.cost4Wheels,
    @required this.cost6To10Wheels,
    @required this.costOver10Wheels,
    @required this.laneList,
  });
}

enum TollPlazaLaneType { cash, easyPass }

class TollPlazaLaneModel {
  final int number;
  final TollPlazaLaneType type;

  TollPlazaLaneModel({
    @required this.number,
    @required this.type,
  });

  @override
  String toString() {
    return "Lane: ${this.number}, Type: ${this.type}";
  }
}
