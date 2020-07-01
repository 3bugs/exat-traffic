import 'package:flutter/material.dart';

class ScreenProps {
  ScreenProps({
    @required this.id,
    @required this.showSearchBox,
    @required this.showBottomSheet,
    @required this.showDate,
    @required this.titleList,
    @required this.searchHintList,
    //@required this.image,
  });

  final int id;
  final bool showSearchBox;
  final bool showBottomSheet;
  final bool showDate;
  final List<String> titleList;
  final List<String> searchHintList;
  //final AssetImage image;

  String getTitle(int lang) {
    return titleList[lang];
  }

  String getSearchHint(int lang) {
    return searchHintList[lang];
  }
}