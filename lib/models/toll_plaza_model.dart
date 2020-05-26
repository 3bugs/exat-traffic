import 'package:flutter/material.dart';

class TollPlazaModel {
  TollPlazaModel({
    @required this.name,
    @required this.image,
    @required this.isEntrance,
    @required this.isExit,
  });

  final String name;
  final AssetImage image;
  final bool isEntrance;
  final bool isExit;
}