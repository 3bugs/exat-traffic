import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilPrefs extends ChangeNotifier {
  static const String KEY_PREF_FIRST_RUN_ALREADY = "pref_first_run_already";
  static const String KEY_PREF_USER_CONSENT = "pref_user_consent";

  UtilPrefs();

  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> isFirstRun() async {
    SharedPreferences prefs = await getSharedPrefs();
    return !prefs.containsKey(KEY_PREF_FIRST_RUN_ALREADY);
  }

  Future<void> setFirstRunAlready() async {
    SharedPreferences prefs = await getSharedPrefs();
    prefs.setBool(KEY_PREF_FIRST_RUN_ALREADY, true);
  }

  Future<bool> userConsent() async {
    SharedPreferences prefs = await getSharedPrefs();
    return prefs.containsKey(KEY_PREF_USER_CONSENT);
  }

  Future<void> setUserConsentAlready() async {
    SharedPreferences prefs = await getSharedPrefs();
    prefs.setBool(KEY_PREF_USER_CONSENT, true);
  }
}