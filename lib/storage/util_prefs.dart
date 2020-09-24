import 'package:exattraffic/services/fcm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilPrefs extends ChangeNotifier {
  static const String KEY_PREF_FIRST_RUN_ALREADY = "pref_first_run_already";
  static const String KEY_PREF_USER_CONSENT = "pref_user_consent";
  static const String KEY_PREF_NOTIFICATION = "pref_notification";

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

  Future<bool> getNotificationStatus() async {
    SharedPreferences prefs = await getSharedPrefs();
    return prefs.getBool(KEY_PREF_NOTIFICATION) ?? true;
    /*if (prefs.containsKey(KEY_PREF_NOTIFICATION)) {
      return prefs.getBool(KEY_PREF_NOTIFICATION);
    } else {
      return false;
    }*/
  }

  Future<void> setNotificationStatus(bool status) async {
    SharedPreferences prefs = await getSharedPrefs();
    await prefs.setBool(KEY_PREF_NOTIFICATION, status);
    notifyListeners();
    MyFcm.setNotificationStatus(status);
  }
}