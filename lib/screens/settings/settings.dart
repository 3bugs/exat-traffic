import 'package:exattraffic/etc/utils.dart';
import 'package:flutter/material.dart';

import 'package:exattraffic/screens/settings/settings_presenter.dart';
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/constants.dart' as Constants;

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

enum SettingName { language, notification, nightMode }
enum LanguageName { thai, english, chinese }

class _SettingsState extends State<Settings> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["การตั้งค่า", "Settings", "设定值"];

  SettingsPresenter _presenter;
  bool _languageValue = false;
  bool _notificationValue = false;
  bool _nightModeValue = false;

  void _handleSettingChange(SettingName settingName, bool newValue) {
    switch (settingName) {
      case SettingName.language:
        setState(() {
          _languageValue = !_languageValue;
        });
        break;
      case SettingName.notification:
        setState(() {
          _notificationValue = !_notificationValue;
        });
        break;
      case SettingName.nightMode:
        setState(() {
          _nightModeValue = !_nightModeValue;
        });
        break;
    }
  }

  Widget _content() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
            vertical: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SettingRow(
                text: "ภาษา",
                value: _languageValue,
                onChange: (bool value) => _handleSettingChange(SettingName.language, value),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: LanguageName.thai,
                              groupValue: LanguageName.thai,
                              onChanged: (LanguageName value) {
                                setState(() {});
                              },
                            ),
                            Expanded(child: Text("ภาษาไทย", style: getTextStyle(0),)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: LanguageName.english,
                              groupValue: LanguageName.thai,
                              onChanged: (LanguageName value) {
                                setState(() {});
                              },
                            ),
                            Expanded(child: Text("ภาษาอังกฤษ", style: getTextStyle(0),)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: LanguageName.chinese,
                              groupValue: LanguageName.thai,
                              onChanged: (LanguageName value) {
                                setState(() {});
                              },
                            ),
                            Expanded(child: Text("ภาษาจีน", style: getTextStyle(0),)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("123"),
                        Text("456"),
                        Text("789"),
                      ],
                    ),
                  )
                ],
              ),
              SettingRow(
                text: "การแจ้งเตือน",
                value: _notificationValue,
                onChange: (bool value) => _handleSettingChange(SettingName.notification, value),
              ),
              SettingRow(
                text: "โหมดกลางคืน (สำหรับ Schematic Map)",
                value: _nightModeValue,
                onChange: (bool value) => _handleSettingChange(SettingName.nightMode, value),
              ),
            ],
          ),
        ),
      ],
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

class SettingRow extends StatelessWidget {
  final String text;
  final bool value;
  final Function onChange;

  SettingRow({
    @required this.text,
    @required this.value,
    @required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: getTextStyle(0),
        ),
        Switch(
          value: value,
          onChanged: onChange,
        ),
      ],
    );
  }
}
