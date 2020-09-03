import 'package:flutter/material.dart';

import 'locale_text.dart';

class DrawerItemModel {
  DrawerItemModel({
    @required this.text,
    @required this.icon,
    @required this.onClick,
  });

  final LocaleText text;
  final AssetImage icon;
  final Function onClick;
}