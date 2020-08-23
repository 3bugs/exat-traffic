import 'package:shared_preferences/shared_preferences.dart';

import 'package:exattraffic/models/marker_categories/cctv_model.dart';

class MyPrefs {
  static const String PREF_CCTV_FAVORITE = "pref_cctv_favorite";
  static final MyPrefs _instance = MyPrefs._internal();

  factory MyPrefs() {
    return _instance;
  }

  MyPrefs._internal();

  Future<SharedPreferences> _getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> existCctvFavorite(CctvModel cctv) async {
    SharedPreferences prefs = await _getSharedPrefs();
    List<String> idList = prefs.getStringList(PREF_CCTV_FAVORITE);
    print("********** CCTV ID LIST: ${idList ?? 'NULL'}");
    if (idList != null) {
      for (String id in idList) {
        if (cctv.id == int.parse(id)) {
          return Future.value(true);
        }
      }
      return Future.value(false);
    } else {
      return Future.value(false);
    }
  }

  Future<void> addCctvFavorite(CctvModel cctv) async {
    SharedPreferences prefs = await _getSharedPrefs();
    List<String> idList = prefs.getStringList(PREF_CCTV_FAVORITE);
    print("********** CCTV ID LIST BEFORE ADDING: ${idList ?? 'NULL'}");
    if (idList == null) {
      idList = List();
    }
    idList.add(cctv.id.toString());
    prefs.setStringList(PREF_CCTV_FAVORITE, idList);
    print("********** CCTV ID LIST AFTER ADDING: $idList");
  }

  Future<void> removeCctvFavorite(CctvModel cctv) async {
    SharedPreferences prefs = await _getSharedPrefs();
    List<String> idList = prefs.getStringList(PREF_CCTV_FAVORITE);
    print("********** CCTV ID LIST BEFORE REMOVING: ${idList ?? 'NULL'}");
    if (idList != null) {
      assert(idList.contains(cctv.id.toString()));
      idList.remove(cctv.id.toString());
      prefs.setStringList(PREF_CCTV_FAVORITE, idList);
    }
    print("********** CCTV ID LIST AFTER REMOVING: ${idList ?? 'NULL'}");
  }
}