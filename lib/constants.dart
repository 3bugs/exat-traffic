library constants;

import 'package:flutter/material.dart';

class App {
  static const Color PRIMARY_COLOR = Color(0xFF47A1FD);
  static const Color ACCENT_COLOR = Color(0xFF446E9D);
  static const Color HEADER_GRADIENT_COLOR_START = Color(0xFF5574F7);
  static const Color HEADER_GRADIENT_COLOR_END = Color(0xFF60C3FF);
  static const Color BACKGROUND_COLOR = Color(0x04000000);
  static const double HORIZONTAL_MARGIN = 24.0;
  static const double BOX_BORDER_RADIUS = 12.0;
}

class NavBar {
  static const double HEIGHT = 77.0;
  static const double CENTER_ITEM_OUTER_SIZE = 90.0;
  static const double CENTER_ITEM_INNER_SIZE = 66.0;
}

class BottomSheet {
  static const Color DARK_BACKGROUND_COLOR = Color(0xFF2A2E43);
  static const double HEIGHT_INITIAL = 184.0;
  static const double HEIGHT_LAYER = 145.0;
  static const double HEIGHT_ROUTE_COLLAPSED = 102.0;
  static const double HEIGHT_ROUTE_EXPANDED = 335.0;
  static const Color LAYER_ITEM_BORDER_COLOR_OFF = Color(0xFF898989);
  static const Color LAYER_ITEM_BORDER_COLOR_ON = App.PRIMARY_COLOR;
}

class HomeScreen {
  static const double MAPS_VERTICAL_POSITION = 38.0;
  static const double SEARCH_BOX_VERTICAL_POSITION = 13.0;
  static const double MAP_TOOL_TOP_POSITION = 42.0;
  static const double SPACE_BEFORE_LIST = 16.0;
}

class LoginScreen {
  static const double HORIZONTAL_MARGIN = 40.0;
  static const double CENTER_BOX_VERTICAL_MARGIN = 20.0;
  static const double LOGO_SIZE = 210.0;
}

class CctvPlayerScreen {
  static const double HORIZONTAL_MARGIN = 22.0;
}

class RouteScreen {
  static const double INITIAL_MARKER_OPACITY = 0.5;
  static const double MARKER_ICON_WIDTH_SMALL = 56.0;
  static const double MARKER_ICON_WIDTH_LARGE = 78.0;
  static const double MARKER_ICON_WIDTH_CAR = 70.0;
}

class Font {
  static const double DEFAULT_SIZE_TH = 23.0;
  static const double DEFAULT_SIZE_EN = 16.0;
  static const double SMALLER_SIZE_TH = 21.0;
  static const double SMALLER_SIZE_EN = 14.0;
  static const double BIGGER_SIZE_TH = 26.0;
  static const double BIGGER_SIZE_EN = 18.0;
  static const double BIGGEST_SIZE_TH = 36.0;
  static const double BIGGEST_SIZE_EN = 24.0;
  static const double LIST_DATE_SIZE = 11.0;
  static const Color DEFAULT_COLOR = Color(0xFF585858);
  static const Color DIM_COLOR = Color(0xFFB2B2B2);
  static const SPACE_BETWEEN_TEXT_PARAGRAPH = 10.0;
}

class Api {
  static const String SERVER = "http://163.47.9.26";
}