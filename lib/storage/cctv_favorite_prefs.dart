import 'package:exattraffic/storage/string_list_prefs.dart';

class CctvFavoritePrefs extends StringListPrefs {
  static const String KEY_PREF_CCTV_FAVORITE = "pref_cctv_favorite";

  CctvFavoritePrefs() : super(KEY_PREF_CCTV_FAVORITE);
}