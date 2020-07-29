import 'package:flutter/material.dart';

class CctvModel {
  CctvModel({
    @required this.name,
    @required this.imageUrl,
    @required this.streamUrl,
  });

  final String name;
  final String imageUrl;
  final String streamUrl;
}