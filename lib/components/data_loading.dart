import 'package:flutter/material.dart';

import 'package:exattraffic/components/my_progress_indicator.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';

class DataLoading extends StatelessWidget {
  final String text;

  DataLoading({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        /*child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),*/
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyProgressIndicator(),
            this.text != null && this.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: getPlatformSize(6.0)),
                    child: Text(
                      this.text,
                      style: getTextStyle(
                        LanguageName.thai,
                        sizeTh: Constants.Font.SMALLER_SIZE_TH,
                        sizeEn: Constants.Font.SMALLER_SIZE_EN,
                        //color: Constants.Font.DIM_COLOR,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
