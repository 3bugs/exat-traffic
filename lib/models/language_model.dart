import 'package:flutter/material.dart';

class LanguageModel extends ChangeNotifier {
  int _lang = 0;

  int get lang => _lang;

  void nextLang() {
    _lang = ++_lang % 3;
    notifyListeners();
  }
}