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

TextStyle getHeadlineTextStyle(BuildContext context) {
  double size = 32.0;
  if (screenWidth(context) > getPlatformSize(400) && screenHeight(context) > getPlatformSize(700)) {
    size = 40.0;
  }
  return TextStyle(
    fontSize: getPlatformSize(size),
    color: Colors.white,
    height: 1,
  );
}

TextStyle getDateTextStyle() {
  return TextStyle(
    fontSize: getPlatformSize(Constants.Font.DEFAULT_SIZE),
    color: Colors.white,
  );
}

TextStyle getSearchTextStyle() {
  return TextStyle(
    fontSize: getPlatformSize(Constants.Font.DEFAULT_SIZE),
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
