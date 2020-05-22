import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

import 'package:exattraffic/constants.dart' as Constants;

Widget wrapSystemUiOverlayStyle({@required Widget child}) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
    child: child,
  );
}

double getPlatformSize(double size) {
  /*
    Galaxy J7 Prime (5.5" @ 1920x1080) = 414 x 736 logical pixel @ 3.0 pixel ratio
    iPhone 7 Plus (5.5" @ 1920x1080) = 360 x 640 logical pixel @ 3.0 pixel ratio
  */
  return Platform.isAndroid ? 0.9 * size : size;
}

const double DEFAULT_LINE_HEIGHT = -1;

TextStyle getTextStyle(
  int lang, {
  double sizeTh = Constants.Font.DEFAULT_SIZE_TH,
  double sizeEn = Constants.Font.DEFAULT_SIZE_EN,
  Color color = Constants.Font.DEFAULT_COLOR,
  bool isBold = false,
  double heightTh = DEFAULT_LINE_HEIGHT,
  double heightEn = DEFAULT_LINE_HEIGHT,
}) {
  String fontFamily = lang == 0 ? (isBold ? 'DBHeavent-Med' : 'DBHeavent') : null;
  FontWeight fontWeight = lang == 0 ? FontWeight.normal : (isBold ? FontWeight.bold : FontWeight.normal);
  double fontSize = lang == 0 ? getPlatformSize(sizeTh) : getPlatformSize(sizeEn);
  double height = lang == 0 ? heightTh : heightEn;

  return height == DEFAULT_LINE_HEIGHT
      ? TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
        )
      : TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
          height: height,
        );
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double dividedBy = 1, double reducedBy = 0.0}) {
  return (screenSize(context).height - reducedBy) / dividedBy;
}

double screenWidth(BuildContext context, {double dividedBy = 1, double reducedBy = 0.0}) {
  return (screenSize(context).width - reducedBy) / dividedBy;
}

double screenHeightExcludingToolbar(BuildContext context, {double dividedBy = 1}) {
  return screenHeight(context, dividedBy: dividedBy, reducedBy: kToolbarHeight);
}

Future<void> alert(BuildContext context, String title, String content) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
