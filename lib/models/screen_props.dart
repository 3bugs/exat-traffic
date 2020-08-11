import 'package:flutter/material.dart';

class ScreenProps {
  ScreenProps({
    @required this.id,
    this.showDate = false,
    this.showSearch = false,
    @required this.titleList,
    this.searchHintList = const [],
    //@required this.image,
  });

  final int id;
  final bool showDate;
  final bool showSearch;
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