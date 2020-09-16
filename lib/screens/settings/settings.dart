import 'package:exattraffic/components/my_button.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/storage/util_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

//import 'package:exattraffic/screens/settings/settings_presenter.dart';
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/locale_text.dart';

class Settings extends StatefulWidget {
  final bool isFirstRun;

  Settings({this.isFirstRun = false});

  @override
  _SettingsState createState() => _SettingsState();
}

enum SettingName { language, notification, nightMode }

class _SettingsState extends State<Settings> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  LocaleText _title = LocaleText.settings();

  List<LanguageOptionModel> _languageOptionList = [
    LanguageOptionModel("ไทย", LanguageName.thai, isThaiText: true),
    LanguageOptionModel("English", LanguageName.english),
    LanguageOptionModel("中文", LanguageName.chinese),
    LanguageOptionModel("日本人", LanguageName.japanese),
    LanguageOptionModel("한국어", LanguageName.korean),
    LanguageOptionModel("Tiếng Việt", LanguageName.vietnamese),
    LanguageOptionModel("ລາວ", LanguageName.lao),
    LanguageOptionModel("မြန်မာ", LanguageName.myanmar),
    LanguageOptionModel("កម្ពុជា", LanguageName.khmer),
    LanguageOptionModel("Bahasa Malaysia", LanguageName.malay),
    LanguageOptionModel("Indonesia", LanguageName.indonesian),
    //LanguageOptionModel("Pilipino", LanguageName.filipino),
  ];

  //SettingsPresenter _presenter;

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
    if (!widget.isFirstRun) {
      _confirmRestart();
    }
  }

  void _confirmRestart() {
    LocaleText confirmRestartText = LocaleText.confirmRestart();
    LocaleText restartText = LocaleText.restartNow();
    LocaleText noText = LocaleText.no();

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
        UtilPrefs prefs = Provider.of<UtilPrefs>(context, listen: false);
        prefs.setNotification(newValue);
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

  LocaleText languageText = LocaleText.language();
  LocaleText notificationText = LocaleText.notification();

  Widget _content() {
    return Container(
      color: Constants.App.BACKGROUND_COLOR,
      padding: EdgeInsets.symmetric(
        horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
        vertical: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
      ),
      child: Consumer<LanguageModel>(
        builder: (context, language, child) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      child: Column(
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
                          Consumer<UtilPrefs>(
                            builder: (context, prefs, child) {
                              return FutureBuilder(
                                future: prefs.getNotification(),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? SettingRow(
                                          text: notificationText.ofLanguage(language.lang),
                                          value: snapshot.data,
                                          onChange: (bool value) =>
                                              _handleSettingChange(SettingName.notification, value),
                                        )
                                      : SizedBox.shrink();
                                },
                              );
                            },
                          ),
                          /*SettingRow(
                            text: "โหมดกลางคืน (สำหรับ Schematic Map)",
                            value: _nightModeValue,
                            onChange: (bool value) => _handleSettingChange(SettingName.nightMode, value),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              widget.isFirstRun
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        MyButton(
                          text: LocaleText.next().ofLanguage(language.lang),
                          onClick: () => Navigator.pop(context),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    //_presenter = SettingsPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      title: _title,
      child: _content(),
      onClickBack: () {
        if (widget.isFirstRun) return;

        if (_selectedLang != null) {
          _confirmRestart();
        } else {
          Navigator.pop(context);
        }
      },
      hideBackButton: widget.isFirstRun,
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
