import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:exattraffic/models/language_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:provider/provider.dart';

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

double getPlatformFontSize(double size) {
  //return Platform.isAndroid ? 0.9 * size : 0.95 * size;
  return getPlatformSize(size);
}

Future<Position> getCurrentLocation() async {
  Position position;
  try {
    position = await Geolocator().getLastKnownPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  } catch (error) {
    print(error);
  }
  return position;
}

Future<Position> getCurrentLocationNotNull() async {
  Position position;
  try {
    position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  } catch (error) {
    print(error);
  }
  return position;
}

const double DEFAULT_LINE_HEIGHT = 0;

TextStyle getTextStyle(
  LanguageName lang, {
  double sizeTh = Constants.Font.DEFAULT_SIZE_TH,
  double sizeEn = Constants.Font.DEFAULT_SIZE_EN,
  Color color = Constants.Font.DEFAULT_COLOR,
  Color bgColor = Colors.transparent,
  bool isBold = false,
  double heightTh = DEFAULT_LINE_HEIGHT,
  double heightEn = DEFAULT_LINE_HEIGHT,
}) {
  String fontFamily = lang == LanguageName.thai ? (isBold ? 'DBHeavent-Med' : 'DBHeavent') : null;
  FontWeight fontWeight = lang == LanguageName.thai
      ? FontWeight.normal
      : (isBold ? FontWeight.bold : FontWeight.normal);
  double fontSize =
      lang == LanguageName.thai ? getPlatformFontSize(sizeTh) : getPlatformFontSize(sizeEn);
  double height =
      lang == LanguageName.thai ? getPlatformFontSize(heightTh) : getPlatformFontSize(heightEn);

  return height == DEFAULT_LINE_HEIGHT
      ? TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color ?? Constants.Font.DEFAULT_COLOR,
          backgroundColor: bgColor,
        )
      : TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color ?? Constants.Font.DEFAULT_COLOR,
          backgroundColor: bgColor,
          height: height,
        );
}

TextStyle getHeadlineTextStyle(BuildContext context, {LanguageName lang = LanguageName.thai}) {
  final bool isBigScreen =
      screenWidth(context) > getPlatformSize(400) && screenHeight(context) > getPlatformSize(700);

  double sizeTh = isBigScreen ? 55.0 : 44.0;
  double sizeEn = isBigScreen ? 40.0 : 32.0;

  return getTextStyle(
    lang,
    sizeTh: Platform.isAndroid ? sizeTh : 0.9 * sizeTh,
    sizeEn: Platform.isAndroid ? sizeEn : 0.9 * sizeEn,
    color: Colors.white,
    heightTh: 1.1 / 0.9,
    heightEn: 1.4 / 0.9,
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

Future<DialogResult> alert(BuildContext context, String title, String content) async {
  return await showMyDialog(
    context,
    content,
    [DialogButtonModel(text: "OK", value: DialogResult.ok)],
  );

  /*return showDialog<void>(
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
  );*/
}

Future<DialogResult> showMyDialog(
  BuildContext context,
  String message,
  List<DialogButtonModel> dialogButtonList, {
  String title = Constants.App.NAME,
}) async {
  LanguageName lang = Provider.of<LanguageModel>(context, listen: false).lang;

  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/images/splash/exat_logo_new_no_text.png'),
            width: getPlatformSize(24.0 * 320 / 246),
            height: getPlatformSize(24.0),
            fit: BoxFit.contain,
          ),
          SizedBox(width: getPlatformSize(8.0)),
          Text(title),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message,
            style: getTextStyle(
              lang,
              sizeTh: Constants.Font.BIGGER_SIZE_TH,
              sizeEn: Constants.Font.BIGGER_SIZE_EN,
            ),
          ),
          /*SizedBox(height: getPlatformSize(36.0)),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: DialogButton(
                        text: "ไม่ใช่",
                        onClickButton: () => Navigator.of(context).pop(false),
                      ),
                    ),
                    SizedBox(width: getPlatformSize(12.0)),
                    Expanded(
                      child: DialogButton(
                        text: "ใช่",
                        onClickButton: () => Navigator.of(context).pop(true),
                      ),
                    ),
                  ],
                ),*/
        ],
      ),
      actions: dialogButtonList
          .map<Widget>((dialogButton) => FlatButton(
                child: Text(
                  dialogButton.text,
                  style: getTextStyle(
                    lang,
                    sizeTh: Constants.Font.BIGGER_SIZE_TH,
                    sizeEn: Constants.Font.BIGGER_SIZE_EN,
                    color: Constants.App.PRIMARY_COLOR,
                    isBold: true,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(dialogButton.value),
              ))
          .toList(),
      /*actions: <Widget>[
        FlatButton(
          child: Text(
            "ไม่ใช่",
            style: getTextStyle(
              0,
              sizeTh: Constants.Font.BIGGER_SIZE_TH,
              sizeEn: Constants.Font.BIGGER_SIZE_EN,
              color: Constants.App.PRIMARY_COLOR,
              isBold: true,
            ),
          ),
          onPressed: () {},
        ),
        FlatButton(
          child: Text(
            "ใช่",
            style: getTextStyle(
              0,
              sizeTh: Constants.Font.BIGGER_SIZE_TH,
              sizeEn: Constants.Font.BIGGER_SIZE_EN,
              color: Constants.App.PRIMARY_COLOR,
              isBold: true,
            ),
          ),
          onPressed: () {},
        ),
      ],*/
    ),
  );
}

enum DialogResult { yes, no, ok, cancel }

class DialogButtonModel {
  final String text;
  final DialogResult value;

  DialogButtonModel({
    @required this.text,
    @required this.value,
  });
}

String formatDateTime(String dateTime) {
  DateTime dt = DateTime.parse(dateTime);
  String d = "${dt.year}-${dt.month < 10 ? '0' : ''}${dt.month}-${dt.day < 10 ? '0' : ''}${dt.day}";
  String t = "${dt.hour < 10 ? '0' : ''}${dt.hour}:${dt.minute < 10 ? '0' : ''}${dt.minute}";
  return "$d  $t";
}

void underConstruction(BuildContext context) {
  alert(context, "EXAT Traffic", "Under construction, coming soon. :)\nMade with ♥ by 2fellows.");
}

LatLngBounds boundsFromLatLngList(List<LatLng> latLngList) {
  double x0, x1, y0, y1;
  for (LatLng latLng in latLngList) {
    if (latLng.latitude < 5.3 ||
        latLng.longitude < 96.7 ||
        latLng.latitude > 20.7 ||
        latLng.longitude > 106) {
      continue;
    }

    if (x0 == null) {
      x0 = x1 = latLng.latitude;
      y0 = y1 = latLng.longitude;
    } else {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
  }
  return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
}

double getDistance(double lat1, double lng1, double lat2, double lng2) {
  const R = 6371e3; // metres

  final double t1 = lat1 * pi / 180; // φ, λ in radians
  final double t2 = lat2 * pi / 180;
  final double dt = (lat2 - lat1) * pi / 180;
  final double dl = (lng2 - lng1) * pi / 180;

  final double a = sin(dt / 2) * sin(dt / 2) + cos(t1) * cos(t2) * sin(dl / 2) * sin(dl / 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c; // in metres
}

double calculateDistance(lat1, lng1, lat2, lng2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a =
      0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

/*Future<List<dynamic>> fetchDataList(url) async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBodyJson = json.decode(response.body);
    ErrorModel error = ErrorModel.fromJson(responseBodyJson['error']);

    if (error.code == 0) {
      List dataListJson = responseBodyJson['data_list'];
      List<dynamic> dataList =
          dataListJson.map((json) => GateInModel.fromJson(json)).toList();

      return dataList;
    } else {
      print(error.message);
      //throw Exception(error.message);
    }
  } else {
    print('เกิดข้อผิดพลาดในการเชื่อมต่อ Server');
    //throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อ Server');
  }
}*/
