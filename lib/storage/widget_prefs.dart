import 'package:exattraffic/screens/widget/widget.dart';
import 'package:exattraffic/storage/string_list_prefs.dart';

class WidgetPrefs extends StringListPrefs {
  static const String KEY_PREF_WIDGET = "pref_widget";

  final List<String> _list = List();

  WidgetPrefs() : super(KEY_PREF_WIDGET) {
    updateList();
  }

  bool isWidgetOn(WidgetType widgetType) {
    return _list.contains(widgetType.toString());
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