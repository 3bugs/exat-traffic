import 'package:exattraffic/components/my_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/express_way_model.dart';
import 'package:exattraffic/screens/bottom_sheet/home_bottom_sheet.dart';

class TrafficPointView extends StatelessWidget {
  final TrafficPointModel trafficPoint;
  final bool isFirstItem;
  final bool isLastItem;
  final Function onClick;
  Color _statusColor;
  String _statusText;

  TrafficPointView({
    @required this.trafficPoint,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.onClick,
  }) {
    List<TrafficPointDataModel> filteredTrafficPointData = HomeBottomSheet.trafficPointDataList
        .where((pointData) => pointData.pointId == trafficPoint.pointId)
        .toList();
    if (filteredTrafficPointData.isNotEmpty) {
      final trafficPointData = filteredTrafficPointData[0];
      switch (trafficPointData.status) {
        case TrafficPointDataModel.STATUS_GREEN:
          this._statusColor = Constants.BottomSheet.TRAFFIC_GREEN;
          this._statusText = '> 70 km/h';
          break;
        case TrafficPointDataModel.STATUS_ORANGE:
          this._statusColor = Constants.BottomSheet.TRAFFIC_ORANGE;
          this._statusText = '40-70 km/h';
          break;
        case TrafficPointDataModel.STATUS_RED:
          this._statusColor = Constants.BottomSheet.TRAFFIC_RED;
          this._statusText = '15-40 km/h';
          break;
        case TrafficPointDataModel.STATUS_DARK_RED:
          this._statusColor = Constants.BottomSheet.TRAFFIC_DARK_RED;
          this._statusText = '0-15 km/h';
          break;
        case TrafficPointDataModel.STATUS_UNKNOWN:
          this._statusColor = Color(0xFFAAAAAA);
          this._statusText = 'N/A';
          break;
        default:
          this._statusColor = Color(0xFFAAAAAA);
          this._statusText = 'N/A';
          break;
      }
    } else {
      this._statusColor = Colors.black;
      this._statusText = 'N/A';
    }
  }

  //final Random _rnd = Random();

  /*Color _getTrafficStatusColor() {
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
  }*/

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
                      color: _statusColor,
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
                            child: Consumer<LanguageModel>(
                              builder: (context, language, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      trafficPoint.cctvMarkerModel.name,
                                      style: getTextStyle(language.lang),
                                    ),
                                    Text(
                                      _statusText,
                                      style: getTextStyle(language.lang, color: _statusColor),
                                    ),
                                  ],
                                );
                              },
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
            child: false /*trafficPoint.cctvMarkerModel.godImageUrl != null*/
                ? MyCachedImage(
                    // ignore: dead_code
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
