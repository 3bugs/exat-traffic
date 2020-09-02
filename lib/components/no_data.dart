import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';

class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "ไม่มีข้อมูล",
          style: getTextStyle(LanguageName.thai),
        ),
      ),
    );
  }
}
