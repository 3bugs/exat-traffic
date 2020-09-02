import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/locale_text.dart';

LocaleText noDataText = LocaleText(
  thai: 'ไม่มีข้อมูล',
  english: 'No data',
  chinese: '没有数据',
);

class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageModel>(builder: (context, language, child) {
      return Container(
        child: Center(
          child: Text(
            noDataText.ofLanguage(language.lang),
            style: getTextStyle(LanguageName.thai),
          ),
        ),
      );
    });
  }
}
