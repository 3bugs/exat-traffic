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

  Future<void> addPlace(PlaceFavoriteModel placeFavorite) async {
    addId(placeFavorite.placeId);
    SharedPreferences prefs = await getSharedPrefs();
    prefs.setString(placeFavorite.placeId, placeFavorite.placeName);
  }
}

class PlaceFavoriteModel {
  final String placeId;
  final String placeName;

  PlaceFavoriteModel(this.placeId, this.placeName);
}
