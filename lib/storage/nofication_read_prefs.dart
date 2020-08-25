import 'package:exattraffic/storage/string_list_prefs.dart';

class NotificationReadPrefs extends StringListPrefs {
  static const String KEY_PREF_NOTIFICATION_READ = "pref_notification_read";

  NotificationReadPrefs() : super(KEY_PREF_NOTIFICATION_READ);
}