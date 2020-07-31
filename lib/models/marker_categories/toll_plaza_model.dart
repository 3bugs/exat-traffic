import 'package:flutter/material.dart';

class TollPlazaModel {
  TollPlazaModel({
    @required this.name,
    @required this.imageUrl,
    @required this.cost4Wheels,
    @required this.cost6To10Wheels,
    @required this.costOver10Wheels,
  });

  final String name;
  final String imageUrl;
  final int cost4Wheels;
  final int cost6To10Wheels;
  final int costOver10Wheels;
}