import 'package:exattraffic/models/favorite_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/storage/string_list_prefs.dart';

class CctvFavoritePrefs extends StringListPrefs {
  static const String KEY_PREF_CCTV_FAVORITE = "pref_cctv_favorite";

  final List<String> _list = List();

  CctvFavoritePrefs() : super(KEY_PREF_CCTV_FAVORITE) {
    updateList();
  }

  List<String> get list => _list;

  updateList() async {
    _list.clear();
    _list.addAll(await getIdList());
    notifyListeners();
  }

  @override
  Future<void> addId(String idToAdd) async {
    await super.addId(idToAdd);
    await updateList();
  }

  @override
  Future<void> removeId(String idToRemove) async {
    await super.removeId(idToRemove);
    await updateList();
  }

  List<FavoriteModel> getFavoriteList(List<MarkerModel> markerList) {
    //List<String> cctvIdList = await getIdList();
    List<String> cctvIdList = _list;
    List<MarkerModel> cctvList = markerList
        .where((marker) => (cctvIdList != null && cctvIdList.contains(marker.id.toString())))
        .toList();
    List<FavoriteModel> cctvFavoriteList = cctvList
        .map<FavoriteModel>((cctvMarker) => FavoriteModel(
              name: cctvMarker.name,
              description: cctvMarker.routeName ?? "กล้อง CCTV",
              //"${cctvMarker.latitude}, ${cctvMarker.longitude}",
              type: FavoriteType.cctv,
              marker: cctvMarker,
            ))
        .toList();
    return cctvFavoriteList;
  }
}
