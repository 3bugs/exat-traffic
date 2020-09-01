import 'package:exattraffic/storage/string_list_prefs.dart';

class CctvFavoritePrefs extends StringListPrefs {
  static const String KEY_PREF_CCTV_FAVORITE = "pref_cctv_favorite";

  final List<String> _list = List();

  CctvFavoritePrefs() : super(KEY_PREF_CCTV_FAVORITE) {
    updateList();
  }

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
}