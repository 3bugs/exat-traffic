import 'package:shared_preferences/shared_preferences.dart';

import 'package:exattraffic/storage/string_list_prefs.dart';

class PlaceFavoritePrefs extends StringListPrefs {
  static const String KEY_PREF_PLACE_FAVORITE = "pref_place_favorite";

  PlaceFavoritePrefs() : super(KEY_PREF_PLACE_FAVORITE);

  Future<List<PlaceFavoriteModel>> getPlaceList() async {
    SharedPreferences prefs = await getSharedPrefs();
    List<String> idList = await getIdList();

    return idList.map<PlaceFavoriteModel>((placeId) {
      String placeName = prefs.getString(placeId);
      assert(placeName != null);
      return PlaceFavoriteModel(placeId, placeName);
    }).toList();
  }

  Future<PlaceFavoriteModel> getPlace(String placeId) async {
    if (await existId(placeId)) {
      SharedPreferences prefs = await getSharedPrefs();
      String placeName = prefs.getString(placeId);
      return PlaceFavoriteModel(placeId, placeName);
    } else {
      return null;
    }
  }

  Future<void> addPlace(PlaceFavoriteModel placeToAdd) async {
    addId(placeToAdd.placeId);
    SharedPreferences prefs = await getSharedPrefs();
    prefs.setString(placeToAdd.placeId, placeToAdd.placeName);
  }
}

class PlaceFavoriteModel {
  final String placeId;
  final String placeName;

  PlaceFavoriteModel(this.placeId, this.placeName);
}
