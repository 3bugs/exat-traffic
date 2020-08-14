import 'package:exattraffic/components/my_cached_image.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/express_way_model.dart';
import 'package:exattraffic/screens/bottom_sheet/home_bottom_sheet.dart';

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

  Color _getTrafficStatus() {
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
        case TrafficPointDataModel.STATUS_UNKNOWN:
          return Color(0xFFAAAAAA);
        default:
          return Color(0xFFAAAAAA);
      }
    } else {
      return Colors.black;
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
                          (trafficPoint.cctvMarkerModel.streamMobile != null) ||
                                  (trafficPoint.cctvMarkerModel.godImageUrl != null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(getPlatformSize(9.0)),
                                  ),
                                  child: SizedBox(
                                    width: getPlatformSize(100.0),
                                    height: getPlatformSize(65.0),
                                    child: _getThumbImage(),
                                  ),
                                )
                              : SizedBox(
                                  height: getPlatformSize(65.0),
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

  Widget _getThumbImage() {
    if (trafficPoint.cctvMarkerModel.streamMobile != null) {
      return Stack(
        children: <Widget>[
          SizedBox(
            width: getPlatformSize(100.0),
            height: getPlatformSize(65.0),
            child: false/*trafficPoint.cctvMarkerModel.godImageUrl != null*/
                ? MyCachedImage(
                    imageUrl: trafficPoint.cctvMarkerModel.godImageUrl,
                    progressIndicatorSize: ProgressIndicatorSize.small,
                  )
                : Image(
                    image: AssetImage('assets/images/cctv_details/video_preview_mock.png'),
                    fit: BoxFit.cover,
                  ),
          ),
          Center(
            child: Image(
              image: AssetImage('assets/images/cctv_details/ic_playback.png'),
              width: getPlatformSize(30.0),
              height: getPlatformSize(30.0),
              fit: BoxFit.contain,
            ),
          ),
        ],
      );
    } else if (trafficPoint.cctvMarkerModel.godImageUrl != null) {
      return MyCachedImage(
        imageUrl: trafficPoint.cctvMarkerModel.godImageUrl,
        progressIndicatorSize: ProgressIndicatorSize.small,
      );
    }

    return SizedBox.shrink();
  }
}
