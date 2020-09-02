import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enum_to_string/enum_to_string.dart';

enum LanguageName {
  thai,
  english,
  chinese,
  japanese,
  korean,
  lao,
  myanmar,
  vietnamese,
  khmer,
  malay,
  indonesian,
  filipino
}

class LanguageModel extends ChangeNotifier {
  static const String KEY_PREF_LANGUAGE = "pref_language";
  static const String TH = "TH";
  static const String EN = "EN";

  final Map<LanguageName, String> _languageCodeMap = Map();
  LanguageName _lang;

  LanguageModel() {
    init();
  }

  init() async {
    _lang = await _getLanguageFromPrefs();

    _languageCodeMap[LanguageName.thai] = TH;
    _languageCodeMap[LanguageName.english] = EN;
    _languageCodeMap[LanguageName.chinese] = "CN";
    _languageCodeMap[LanguageName.japanese] = "JP";
    _languageCodeMap[LanguageName.korean] = "KR";
    _languageCodeMap[LanguageName.vietnamese] = "VN";
    _languageCodeMap[LanguageName.lao] = "LA";
    _languageCodeMap[LanguageName.myanmar] = "MM";
    _languageCodeMap[LanguageName.khmer] = "KH";
    _languageCodeMap[LanguageName.malay] = "MY";
    _languageCodeMap[LanguageName.indonesian] = "ID";
    _languageCodeMap[LanguageName.filipino] = "PH";
  }

  Future<SharedPreferences> _getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<LanguageName> _getLanguageFromPrefs() async {
    SharedPreferences prefs = await _getSharedPrefs();
    LanguageName lang = LanguageName.thai; // default: Thai
    if (prefs.containsKey(KEY_PREF_LANGUAGE)) {
      lang = EnumToString.fromString(LanguageName.values, prefs.getString(KEY_PREF_LANGUAGE));
    }
    return lang;
  }

  Future<bool> _setLanguageToPrefs(LanguageName languageName) async {
    SharedPreferences prefs = await _getSharedPrefs();
    return await prefs.setString(KEY_PREF_LANGUAGE, EnumToString.parse(languageName));
  }

  String get langCode {
    return _languageCodeMap[_lang] ?? EN;
  }

  LanguageName get lang => _lang;

  set lang(LanguageName value) {
    _setLanguageToPrefs(value);
    _lang = value;
    notifyListeners();
  }
}
