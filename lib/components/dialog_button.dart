import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

class DialogButton extends StatelessWidget {
  DialogButton({
    @required this.text,
    @required this.onClickButton,
  });

  final String text;
  final Function onClickButton;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          getPlatformSize(Constants.App.BOX_BORDER_RADIUS),
        ),
        //side: BorderSide(color: Colors.red)
      ),
      padding: EdgeInsets.symmetric(
        horizontal: getPlatformSize(26.0),
        vertical: getPlatformSize(6.0),
      ),
      onPressed: onClickButton,
      color: Constants.App.PRIMARY_COLOR,
      //Color(0xFF305393),
      textColor: Colors.white,
      child: Text(
        text.toUpperCase(),
        style: getTextStyle(
          0,
          sizeTh: Constants.Font.BIGGER_SIZE_TH,
          sizeEn: Constants.Font.BIGGER_SIZE_EN,
          color: Colors.white,
        ),
      ),
    );
  }
}
