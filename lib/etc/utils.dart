import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

Future<Position> getCurrentLocation() async {
  final Position position = await Geolocator().getLastKnownPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  return position;
}

Future<Position> getCurrentLocationNotNull() async {
  final Position position = await Geolocator().getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  return position;
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
  FontWeight fontWeight =
      lang == 0 ? FontWeight.normal : (isBold ? FontWeight.bold : FontWeight.normal);
  double fontSize = lang == 0 ? getPlatformSize(sizeTh) : getPlatformSize(sizeEn);
  double height = lang == 0 ? heightTh : heightEn;

  return height == DEFAULT_LINE_HEIGHT
      ? TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color ?? Constants.Font.DEFAULT_COLOR,
        )
      : TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color ?? Constants.Font.DEFAULT_COLOR,
          height: height,
        );
}

TextStyle getHeadlineTextStyle(BuildContext context, {int lang = 0}) {
  final bool isBigScreen =
      screenWidth(context) > getPlatformSize(400) && screenHeight(context) > getPlatformSize(700);

  return getTextStyle(
    lang,
    sizeTh: isBigScreen ? 55.0 : 44.0,
    sizeEn: isBigScreen ? 40.0 : 32.0,
    color: Colors.white,
    heightTh: 1.1,
    heightEn: 1.4,
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

void underConstruction(BuildContext context) {
  alert(context, "EXAT Traffic", "Under construction, coming soon. :)\n\nMade with ♥ by 2fellows.");
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
