import 'package:flutter/material.dart';

class RestAreaModel {
  RestAreaModel({
    @required this.name,
    @required this.image,
  });

  final String name;
  final AssetImage image;
}