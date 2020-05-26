import 'package:flutter/material.dart';

class DrawerItemModel {
  DrawerItemModel({
    @required this.text,
    @required this.icon,
    @required this.onClick,
  });

  final String text;
  final AssetImage icon;
  final Function onClick;
}