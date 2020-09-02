import 'package:exattraffic/models/language_model.dart';
import 'package:flutter/material.dart';

import 'locale_text.dart';

class ScreenProps {
  ScreenProps({
    @required this.id,
    this.showDate = false,
    this.showSearch = false,
    @required this.title,
    this.searchHint,
    //@required this.image,
  });

  final int id;
  final bool showDate;
  final bool showSearch;
  final LocaleText title;
  final LocaleText searchHint;
  //final AssetImage image;

  String getTitle(LanguageName lang) {
    return title.ofLanguage(lang);
  }

  String getSearchHint(LanguageName lang) {
    return searchHint.ofLanguage(lang);
  }
}