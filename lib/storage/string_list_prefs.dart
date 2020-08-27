import 'package:shared_preferences/shared_preferences.dart';

class StringListPrefs {
  final String _keyPref;

  StringListPrefs(this._keyPref);

  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<List<String>> getIdList() async {
    SharedPreferences prefs = await getSharedPrefs();
    List<String> idList = prefs.getStringList(_keyPref);
    return idList;
  }

  Future<bool> existId(String idToCheck) async {
    if (idToCheck != null) {
      idToCheck = idToCheck.trim();
    }

    SharedPreferences prefs = await getSharedPrefs();
    List<String> idList = prefs.getStringList(_keyPref);
    print("********** [$_keyPref] ID LIST: ${idList ?? 'NULL'}");
    if (idList != null) {
      for (String id in idList) {
        if (idToCheck == id) {
          return Future.value(true);
        }
      }
      return Future.value(false);
    } else {
      return Future.value(false);
    }
  }

  Future<void> addId(String idToAdd) async {
    assert(idToAdd != null);
    idToAdd = idToAdd != null ? idToAdd.trim() : "";

    SharedPreferences prefs = await getSharedPrefs();
    List<String> idList = prefs.getStringList(_keyPref);
    print("********** [$_keyPref] ID LIST BEFORE ADDING: ${idList ?? 'NULL'}");
    if (idList == null) {
      idList = List();
    }
    if (!idList.contains(idToAdd)) {
      idList.add(idToAdd);
      prefs.setStringList(_keyPref, idList);
    }
    print("********** [$_keyPref] ID LIST AFTER ADDING: $idList");
  }

  Future<void> removeId(String idToRemove) async {
    if (idToRemove != null && idToRemove.trim().isNotEmpty) {
      SharedPreferences prefs = await getSharedPrefs();
      List<String> idList = prefs.getStringList(_keyPref);
      print("********** [$_keyPref] ID LIST BEFORE REMOVING: ${idList ?? 'NULL'}");
      if (idList != null) {
        assert(idList.contains(idToRemove));
        idList.remove(idToRemove);
        prefs.setStringList(_keyPref, idList);
      }
      print("********** [$_keyPref] ID LIST AFTER REMOVING: ${idList ?? 'NULL'}");
    }
  }
}