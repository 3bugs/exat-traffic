import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/marker_categories/toll_plaza_model.dart';

class TollPlazaLaneItemView extends StatelessWidget {
  TollPlazaLaneItemView({
    @required this.laneItem,
    @required this.isFirstItem,
    @required this.isLastItem,
  });

  final TollPlazaLaneModel laneItem;
  final bool isFirstItem;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    Color laneColor;
    String laneText, laneTextEn;
    switch (laneItem.type) {
      case TollPlazaLaneType.cash:
        laneColor = Color(0xFFFE9289);
        laneText = "เงินสด";
        laneTextEn = "CASH";
        break;
      case TollPlazaLaneType.easyPass:
        laneColor = Color(0xFF00ACE1);
        laneText = "อัตโนมัติ";
        laneTextEn = "EASY PASS";
        break;
      default:
        laneColor = Color(0xFFBCC1C3);
        laneText = ".";
        break;
    }

    return Container(
      padding: EdgeInsets.only(
        left: getPlatformSize(isFirstItem ? 8.0 : 4.0),
        right: getPlatformSize(isLastItem ? 8.0 : 4.0),
        top: getPlatformSize(2.0),
        bottom: getPlatformSize(2.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: getPlatformSize(0.0),
          horizontal: getPlatformSize(0.0),
        ),
        width: getPlatformSize(72.0),
        decoration: BoxDecoration(
          color: laneColor,
          borderRadius: BorderRadius.all(
            Radius.circular(Constants.App.BOX_BORDER_RADIUS),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "ช่อง",
              style: getTextStyle(
                0,
                color: Colors.white,
                isBold: true,
                /*sizeTh: Constants.Font.BIGGER_SIZE_TH,
                sizeEn: Constants.Font.BIGGER_SIZE_EN,*/
              ),
            ),
            SizedBox(
              height: getPlatformSize(8.0),
            ),
            Text(
              laneItem.number.toString(),
              style: GoogleFonts.kanit(
                textStyle: TextStyle(
                  fontSize: getPlatformSize(18.0),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: getPlatformSize(8.0),
            ),
            Text(
              laneText,
              textAlign: TextAlign.center,
              style: getTextStyle(
                0,
                color: Colors.white,
                isBold: true,
                /*sizeTh: Constants.Font.SMALLER_SIZE_TH,
                sizeEn: Constants.Font.SMALLER_SIZE_EN,*/
              ),
            ),
            Text(
              laneTextEn,
              textAlign: TextAlign.center,
              style: getTextStyle(
                1,
                color: Colors.white,
                isBold: true,
                //sizeTh: Constants.Font.SMALLER_SIZE_TH,
                sizeEn: 10.5,
                heightEn: 1.0,
              ),
            ),
            SizedBox(
              height: getPlatformSize(22.0),
            ),
            Image(
              image: AssetImage('assets/images/toll_plaza_details/ic_lane_arrow.png'),
              width: getPlatformSize(16.61),
              height: getPlatformSize(26.34),
            ),
            SizedBox(
              height: getPlatformSize(10.0),
            ),
          ],
        ),
      ),
    );
  }
}
