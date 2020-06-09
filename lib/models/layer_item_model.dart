import 'package:flutter/material.dart';

class LayerItemModel {
  LayerItemModel({
    @required this.text,
    @required this.textEn,
    @required this.iconOn,
    @required this.iconOff,
    @required this.iconWidth,
    @required this.iconHeight,
    @required this.isChecked,
    @required this.onClick,
  });

  final String text;
  final String textEn;
  final AssetImage iconOn;
  final AssetImage iconOff;
  final double iconWidth;
  final double iconHeight;
  bool isChecked;
  final Function onClick;
}