import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

class MyButton extends StatelessWidget {
  final String text;
  final Function onClick;

  MyButton({@required this.text, this.onClick});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(
        horizontal: getPlatformSize(24.0),
        vertical: getPlatformSize(8.0),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
//        side: BorderSide(color: Colors.red),
      ),
      onPressed: () {
        if (this.onClick != null) {
          this.onClick();
        }
      },
      color: Constants.App.PRIMARY_COLOR,
      child: Text(
        this.text,
        style: getTextStyle(
          0,
          color: Colors.white,
          sizeTh: Constants.Font.BIGGER_SIZE_TH,
          sizeEn: Constants.Font.BIGGER_SIZE_EN,
        ),
      ),
    );
  }
}
