import 'package:flutter/material.dart';

import 'package:exattraffic/screens/settings/settings_presenter.dart';
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/constants.dart' as Constants;

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["การตั้งค่า", "Settings", "设定值"];

  SettingsPresenter _presenter;

  Widget _content() {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Text("TEST\nTEST\nTEST\nTEST\nTEST\nTEST\nTEST\n"),
          Text("TEST\nTEST\nTEST\nTEST\nTEST\nTEST\nTEST\n"),
          Text("TEST\nTEST\nTEST\nTEST\nTEST\nTEST\nTEST\n"),
          Text("TEST\nTEST\nTEST\nTEST\nTEST\nTEST\nTEST\n"),
          Text("TEST\nTEST\nTEST\nTEST\nTEST\nTEST\nTEST\n"),
          Text("TEST\nTEST\nTEST\nTEST\nTEST\nTEST\nTEST\n"),
          Text("TEST\nTEST\nTEST\nTEST\nTEST\nTEST\nTEST\n"),
          Text("TEST\nTEST\nTEST\nTEST\nTEST\nTEST\nTEST\n"),
          Text("TEST\nTEST\nTEST\nTEST\nTEST\nTEST\nTEST\n"),
        ],
      ),
    );
  }

  @override
  void initState() {
    _presenter = SettingsPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      titleList: _titleList,
      child: _content(),
    );
  }
}
