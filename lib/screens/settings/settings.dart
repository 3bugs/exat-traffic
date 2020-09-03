import 'package:exattraffic/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/screens/settings/settings_presenter.dart';
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/locale_text.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

enum SettingName { language, notification, nightMode }

class _SettingsState extends State<Settings> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  LocaleText _title = LocaleText(thai: "การตั้งค่า", english: "Settings", chinese: "设定值");

  List<LanguageOptionModel> _languageOptionList = [
    LanguageOptionModel("ไทย", LanguageName.thai, isThaiText: true),
    LanguageOptionModel("English", LanguageName.english),
    LanguageOptionModel("中文", LanguageName.chinese),
    LanguageOptionModel("日本人", LanguageName.japanese),
    LanguageOptionModel("한국어", LanguageName.korean),
    LanguageOptionModel("Tiếng Việt", LanguageName.vietnamese),
    LanguageOptionModel("ລາວ", LanguageName.lao),
    LanguageOptionModel("မြန်မာ", LanguageName.myanmar),
    LanguageOptionModel("khmer", LanguageName.khmer),
    LanguageOptionModel("melayu", LanguageName.malay),
    LanguageOptionModel("bahasa Indonesia", LanguageName.indonesian),
    LanguageOptionModel("Pilipino", LanguageName.filipino),
  ];

  SettingsPresenter _presenter;

  //LanguageName _languageValue = LanguageName.thai;
  bool _notificationValue = false;
  bool _nightModeValue = false;
  LanguageName _selectedLang;

  void _handleClickLanguage(LanguageName lang) {
    /*if (lang == _languageValue) return;

    setState(() {
      _languageValue = lang;
    });*/

    LanguageModel languageModel = Provider.of<LanguageModel>(context, listen: false);
    if (languageModel.lang == lang) return;

    languageModel.lang = lang;
    _selectedLang = lang;
    _confirmRestart();
  }

  void _confirmRestart() {
    LocaleText confirmRestartText = LocaleText(
      thai:
      '${Constants.App.NAME} จำเป็นต้องเริ่มการทำงานใหม่เมื่อมีการเปลี่ยนภาษา คุณต้องการให้เริ่มการทำงานใหม่เดี๋ยวนี้หรือไม่',
      english: 'Restart required. Do you want to restart ${Constants.App.NAME} now?',
      chinese: '需要重新启动。 您要立即重新启动${Constants.App.NAME}吗？',
    );
    LocaleText restartText = LocaleText(
      thai: 'เริ่มใหม่เดี๋ยวนี้',
      english: 'RESTART NOW',
      chinese: '现在重启',
    );
    LocaleText noText = LocaleText(
      thai: 'ไม่ใช่',
      english: 'NO',
      chinese: '没有',
    );

    Future.delayed(Duration(milliseconds: 250), () async {
      DialogResult result = await showMyDialog(
        context,
        confirmRestartText.ofLanguage(_selectedLang),
        [
          DialogButtonModel(text: noText.ofLanguage(_selectedLang), value: DialogResult.no),
          DialogButtonModel(text: restartText.ofLanguage(_selectedLang), value: DialogResult.yes),
        ],
      );
      if (result == DialogResult.yes) {
        ExatApi.clearCache();
        Phoenix.rebirth(context);
      }
    });
  }

  void _handleSettingChange(SettingName settingName, bool newValue) {
    switch (settingName) {
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
      case SettingName.language:
        break;
    }
  }

  LocaleText languageText = LocaleText(thai: 'ภาษา', english: 'Language', chinese: '语言');
  LocaleText notificationText =
      LocaleText(thai: 'การแจ้งเตือน', english: 'Notification', chinese: '通知');

  Widget _content() {
    return Container(
      color: Constants.App.BACKGROUND_COLOR,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
              vertical: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
            ),
            child: Consumer<LanguageModel>(
              builder: (context, language, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SettingRow(
                      text: languageText.ofLanguage(language.lang),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _languageOptionList
                                .where((item) => (_languageOptionList.indexOf(item) <
                                    _languageOptionList.length ~/ 2 +
                                        (_languageOptionList.length % 2)))
                                .map<Widget>(
                                  (item) => OptionButton(
                                    text: item.text,
                                    value: item.value,
                                    groupValue: language.lang,
                                    isThaiText: item.isThaiText,
                                    onClick: () => _handleClickLanguage(item.value),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(
                          width: getPlatformSize(0.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _languageOptionList
                                .where((item) => (_languageOptionList.indexOf(item) >=
                                    _languageOptionList.length ~/ 2 +
                                        (_languageOptionList.length % 2)))
                                .map<Widget>(
                                  (item) => OptionButton(
                                    text: item.text,
                                    value: item.value,
                                    groupValue: language.lang,
                                    isThaiText: item.isThaiText,
                                    onClick: () => _handleClickLanguage(item.value),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getPlatformSize(8.0),
                    ),
                    SettingRow(
                      text: notificationText.ofLanguage(language.lang),
                      value: _notificationValue,
                      onChange: (bool value) =>
                          _handleSettingChange(SettingName.notification, value),
                    ),
                    /*SettingRow(
                    text: "โหมดกลางคืน (สำหรับ Schematic Map)",
                    value: _nightModeValue,
                    onChange: (bool value) => _handleSettingChange(SettingName.nightMode, value),
                  ),*/
                  ],
                );
              },
            ),
          ),
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
      title: _title,
      child: _content(),
      onClickBack: () {
        if (_selectedLang != null) {
          _confirmRestart();
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}

class LanguageOptionModel {
  final String text;
  final LanguageName value;
  final bool isThaiText;

  LanguageOptionModel(this.text, this.value, {this.isThaiText = false});
}

class OptionButton<T> extends StatelessWidget {
  final String text;
  final T value;
  final T groupValue;
  final Function onClick;
  final bool isThaiText;

  OptionButton({
    @required this.text,
    @required this.value,
    @required this.groupValue,
    @required this.onClick,
    this.isThaiText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: this.onClick,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Radio<T>(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: this.value,
              groupValue: this.groupValue,
              onChanged: (T value) {
                this.onClick();
              },
            ),
            Text(
              this.text,
              style: getTextStyle(this.isThaiText ? LanguageName.thai : LanguageName.english),
            ),
            SizedBox(
              width: getPlatformSize(12.0),
            )
          ],
        ),
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  final String text;
  final bool value;
  final Function onChange;

  SettingRow({
    @required this.text,
    this.value,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: getTextStyle(LanguageName.thai),
        ),
        Visibility(
          visible: onChange != null,
          child: Switch(
            value: value ?? false,
            onChanged: onChange,
          ),
        ),
      ],
    );
  }
}
