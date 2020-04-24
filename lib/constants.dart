library constants;

import 'package:exattraffic/etc/utils.dart';
import 'package:flutter/cupertino.dart';

class App {
  static const Color PRIMARY_COLOR = Color(0xFF47A1FD);
  static const Color HEADER_GRADIENT_COLOR_START = Color(0xFF5574F7);
  static const Color HEADER_GRADIENT_COLOR_END = Color(0xFF60C3FF);
  static final double HORIZONTAL_MARGIN = getPlatformSize(24.0);
  static final double BOX_BORDER_RADIUS = getPlatformSize(12.0);
}

class NavBar {
  static final double HEIGHT = getPlatformSize(77.0);
  static final double CENTER_ITEM_OUTER_SIZE = getPlatformSize(90.0);
  static final double CENTER_ITEM_INNER_SIZE = getPlatformSize(66.0);
}

class HomeScreen {
  static final double MAPS_VERTICAL_POSITION = getPlatformSize(42.0);
  static final double SEARCH_BOX_VERTICAL_POSITION = getPlatformSize(16.0);
}

class LoginScreen {
  static final double HORIZONTAL_MARGIN = getPlatformSize(40.0);
  static final double CENTER_BOX_VERTICAL_MARGIN = getPlatformSize(20.0);
  static final double LOGO_SIZE = getPlatformSize(210.0);
}