import 'package:flutter/material.dart';

import 'language_model.dart';

class LocaleText {
  Map<LanguageName, String> _map = Map();

  LocaleText({
    @required thai,
    @required english,
    @required chinese,
    @required japanese,
    @required korean,
    @required lao,
    @required myanmar,
    @required vietnamese,
    @required khmer,
    @required malay,
    @required indonesian,
    @required filipino,
  }) {
    _map[LanguageName.thai] = thai;
    _map[LanguageName.english] = english;
    _map[LanguageName.chinese] = chinese;
    _map[LanguageName.japanese] = japanese;
    _map[LanguageName.korean] = korean;
    _map[LanguageName.lao] = lao;
    _map[LanguageName.myanmar] = myanmar;
    _map[LanguageName.vietnamese] = vietnamese;
    _map[LanguageName.khmer] = khmer;
    _map[LanguageName.malay] = malay;
    _map[LanguageName.indonesian] = indonesian;
    _map[LanguageName.filipino] = filipino;
  }

  String ofLanguage(LanguageName languageName) {
    return _map[languageName] ?? _map[LanguageName.english];
  }
}
