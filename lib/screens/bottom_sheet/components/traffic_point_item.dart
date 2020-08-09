import 'package:exattraffic/screens/bottom_sheet/home_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/express_way_model.dart';

class TrafficPointView extends StatelessWidget {
  TrafficPointView({
    @required this.trafficPoint,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.onClick,
  });

  final TrafficPointModel trafficPoint;
  final bool isFirstItem;
  final bool isLastItem;
  final Function onClick;

  final Random _rnd = Random();

  String _validateUrl(String url) {
    String newUrl = url;

    if (url != null && url.length > 0) {
      int beginIndex = url.indexOf("http://", 1);
      if (beginIndex != -1) {
        newUrl = url.substring(beginIndex);
      }
    }

    return newUrl;
  }

  Color _getTrafficStatus() {
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% _getTrafficStatus(): ${Random().nextInt(10000)} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

    List<TrafficPointDataModel> filteredTrafficPointData = HomeBottomSheet.trafficPointDataList
        .where((pointData) => pointData.pointId == trafficPoint.pointId)
        .toList();
    if (filteredTrafficPointData.isNotEmpty) {
      final trafficPointData = filteredTrafficPointData[0];
      switch (trafficPointData.status) {
        case TrafficPointDataModel.STATUS_GREEN:
          return Color(0xFF22B573);
        case TrafficPointDataModel.STATUS_ORANGE:
          return Color(0xFFF7882C);
        case TrafficPointDataModel.STATUS_RED:
          return Color(0xFFEB222C);
        case TrafficPointDataModel.STATUS_DARK_RED:
          return Color(0xFF790A11);
        default:
          return Colors.black;
      }
    } else {
      return Color(0xFFAAAAAA);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: getPlatformSize(14.0),
                right: getPlatformSize(14.0),
                top: getPlatformSize(isFirstItem ? 7.0 : 0.0),
                bottom: getPlatformSize(isLastItem ? 21.0 : 0.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: _getTrafficStatus(),
                      //_rnd.nextInt(2) == 0 ? Color(0xFFEB222C) : Color(0xFF22B573),
                      width: getPlatformSize(11.0),
                    ),
                    bottom: isLastItem
                        ? BorderSide.none
                        : BorderSide(
                            color: Color(0xFFC7C7C7),
                            width: getPlatformSize(0.0),
                          ),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onClick,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: getPlatformSize(20.0),
                        right: getPlatformSize(10.0),
                        top: getPlatformSize(12.0),
                        bottom: getPlatformSize(12.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Consumer<LanguageModel>(
                                builder: (context, language, child) {
                                  String name;
                                  switch (language.lang) {
                                    case 0:
                                      name = trafficPoint.cctvMarkerModel.name;
                                      break;
                                    case 1:
                                      name = 'Expressway';
                                      break;
                                    case 2:
                                      name = '高速公路';
                                      break;
                                  }
                                  return Text(
                                    name,
                                    style: getTextStyle(language.lang),
                                  );
                                },
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(getPlatformSize(9.0)),
                            ),
                            child: SizedBox(
                              width: getPlatformSize(100.0),
                              height: getPlatformSize(65.0),
                              child: Image.network(
                                _validateUrl(trafficPoint.cctvMarkerModel.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            isFirstItem
                ? SizedBox.shrink()
                : Positioned(
                    top: getPlatformSize(-5.0),
                    left: getPlatformSize(13.5),
                    child: Image(
                      image: AssetImage('assets/images/home/ic_arrow_down.png'),
                      width: getPlatformSize(12.26),
                      height: getPlatformSize(10.49),
                      fit: BoxFit.contain,
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
