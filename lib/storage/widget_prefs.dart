import 'package:exattraffic/storage/string_list_prefs.dart';

class WidgetPrefs extends StringListPrefs {
  static const String KEY_PREF_WIDGET = "pref_widget";

  final List<String> _widgetTypeList = List();

  WidgetPrefs() : super(KEY_PREF_WIDGET) {
    updateList();
  }

  List<String> get widgetTypeList => _widgetTypeList;

  updateList() async {
    _widgetTypeList.clear();
    _widgetTypeList.addAll(await getIdList());
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