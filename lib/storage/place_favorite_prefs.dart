import 'package:shared_preferences/shared_preferences.dart';

import 'package:exattraffic/storage/string_list_prefs.dart';
import 'package:exattraffic/models/favorite_model.dart';

class PlaceFavoritePrefs extends StringListPrefs {
  static const String KEY_PREF_PLACE_FAVORITE = "pref_place_favorite";

  final List<PlaceFavoriteModel> _list = List();

  PlaceFavoritePrefs() : super(KEY_PREF_PLACE_FAVORITE) {
    updateList();
  }

  //List<PlaceFavoriteModel> get list => _list;

  updateList() async {
    _list.clear();
    _list.addAll(await getPlaceList());
    notifyListeners();
  }

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
    await addId(placeToAdd.placeId);
    SharedPreferences prefs = await getSharedPrefs();
    prefs.setString(placeToAdd.placeId, placeToAdd.placeName);
    await updateList();
  }

  Future<void> removePlace(String placeId) async {
    await removeId(placeId);
    await updateList();
  }

  List<FavoriteModel> getFavoriteList() {
    //List<PlaceFavoriteModel> placeList = await PlaceFavoritePrefs().getPlaceList();
    List<PlaceFavoriteModel> placeList = _list;
    List<FavoriteModel> placeFavoriteList = placeList
        .map<FavoriteModel>((placeFavorite) => FavoriteModel(
              name: placeFavorite.placeName,
              description: "สถานที่",
              //"${cctvMarker.latitude}, ${cctvMarker.longitude}",
              type: FavoriteType.place,
              placeId: placeFavorite.placeId,
            ))
        .toList();
    return placeFavoriteList;
  }
}

class PlaceFavoriteModel {
  final String placeId;
  final String placeName;

  PlaceFavoriteModel(this.placeId, this.placeName);
}
