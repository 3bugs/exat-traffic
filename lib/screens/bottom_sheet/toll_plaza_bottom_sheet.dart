import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:google_fonts/google_fonts.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/marker_categories/toll_plaza_model.dart';
import 'package:exattraffic/screens/bottom_sheet/components/bottom_sheet_scaffold.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/screens/bottom_sheet/components/toll_plaza_lane_item.dart';
import 'package:exattraffic/models/locale_text.dart';

LocaleText bahtText = LocaleText.baht();
LocaleText fourWheelsText = LocaleText.fourWheels();
LocaleText sixToTenWheelsText = LocaleText.sixToTenWheels();
LocaleText overTenWheelsText = LocaleText.overTenWheels();
LocaleText laneText = LocaleText.lane();
LocaleText distanceBasedTollsText = LocaleText.distanceBasedTolls();

class TollPlazaBottomSheet extends StatefulWidget {
  TollPlazaBottomSheet({
    @required Key key,
    @required this.expandPosition,
    @required this.collapsePosition,
    @required this.tollPlazaModel,
  }) : super(key: key);

  final double expandPosition;
  final double collapsePosition;
  final TollPlazaModel tollPlazaModel;

  @override
  TollPlazaBottomSheetState createState() => TollPlazaBottomSheetState();
}

class TollPlazaBottomSheetState extends State<TollPlazaBottomSheet> {
  final GlobalKey<BottomSheetScaffoldState> _keyBottomSheetScaffold = GlobalKey();

  static const TEXT_COLOR = Color(0xFF818181);
  bool _bottomSheetExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  void toggleSheet() {
    _keyBottomSheetScaffold.currentState.toggleSheet();
  }

  void _handleClickUpDownSheet() {
    this.toggleSheet();
  }

  void _handleChangeSize(bool sheetExpanded) {
    setState(() {
      _bottomSheetExpanded = sheetExpanded;
    });
  }

  Widget _getCarItem(LanguageName language, int widthFlex, String label, String iconPath, double iconWidth,
      double iconHeight, double iconMarginTop) {
    return Expanded(
      flex: widthFlex,
      child: Container(
        height: getPlatformSize(75),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: getPlatformSize(iconMarginTop),
              ),
              child: Image(
                image: AssetImage(iconPath),
                width: getPlatformSize(iconWidth),
                height: getPlatformSize(iconHeight),
              ),
            ),
            Text(
              label,
              style: getTextStyle(
                language,
                color: Color(0xFFACACAC),
                isBold: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFeeItem(LanguageName language, int widthFlex, int fee) {
    return Expanded(
      flex: widthFlex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: getPlatformSize(2.0),
          ),
          Image(
            image: AssetImage('assets/images/home/ic_sheet_down.png'),
            width: getPlatformSize(10.0),
            height: getPlatformSize(9.73 * 10.0 / 5.88),
          ),
          SizedBox(
            height: getPlatformSize(2.0),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: getPlatformSize(6.0),
              bottom: getPlatformSize(0.0),
            ),
            child: Text(
              fee.toString(),
              /*style: GoogleFonts.kanit(
                textStyle: TextStyle(
                  fontSize: getPlatformSize(30.0),
                  fontWeight: FontWeight.bold,
                  color: TEXT_COLOR,
                ),
              ),*/
              style: getTextStyle(
                LanguageName.english,
                color: TEXT_COLOR,
                sizeTh: 50.0,
                sizeEn: 35.0,
                heightEn: 0.9,
                isBold: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: getPlatformSize(0.0),
              bottom: getPlatformSize(8.0),
            ),
            child: Text(
              bahtText.ofLanguage(language),
              style: getTextStyle(
                language,
                color: TEXT_COLOR,
                sizeTh: Constants.Font.BIGGER_SIZE_TH,
                sizeEn: Constants.Font.BIGGER_SIZE_EN,
                heightTh: 1.0,
                heightEn: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScaffold(
      key: _keyBottomSheetScaffold,
      expandPosition: widget.expandPosition,
      collapsePosition: widget.collapsePosition,
      onChangeSize: _handleChangeSize,
      child: Expanded(
        child: Container(
          color: Colors.white,
          child: Consumer<LanguageModel>(
            builder: (context, language, child) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: getPlatformSize(20.0),
                      right: getPlatformSize(4.0),
                      top: getPlatformSize(10.0),
                      bottom: getPlatformSize(6.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // ข้อความบอกเวลา ระยะทาง
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: getPlatformSize(6.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: getPlatformSize(4.0),
                                  ),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/map_markers/ic_marker_toll_plaza_small.png'),
                                    width: getPlatformSize(25.58),
                                    height: getPlatformSize(33.41),
                                  ),
                                ),
                                SizedBox(
                                  width: getPlatformSize(14.0),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.tollPlazaModel != null
                                          ? widget.tollPlazaModel.name
                                          : "",
                                      style: getTextStyle(
                                        language.lang,
                                        isBold: true,
                                        sizeTh: Constants.Font.BIGGER_SIZE_TH,
                                        sizeEn: Constants.Font.BIGGER_SIZE_EN,
                                      ),
                                    ),
                                    /*Text(
                                      'ใช้เวลาเดินทาง x ชม. y นาที',
                                      style: getTextStyle(
                                        language.lang,
                                        sizeTh: Constants.Font.SMALLER_SIZE_TH,
                                        sizeEn: Constants.Font.SMALLER_SIZE_EN,
                                      ),
                                    ),*/
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ปุ่ม up/down
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _handleClickUpDownSheet();
                            },
                            borderRadius: BorderRadius.all(
                              Radius.circular(getPlatformSize(21.0)),
                            ),
                            child: Container(
                              width: getPlatformSize(42.0),
                              height: getPlatformSize(42.0),
                              //padding: EdgeInsets.all(getPlatformSize(15.0)),
                              child: Center(
                                child: Image(
                                  image: _bottomSheetExpanded
                                      ? AssetImage('assets/images/home/ic_sheet_down.png')
                                      : AssetImage('assets/images/home/ic_sheet_up.png'),
                                  width: getPlatformSize(12.0),
                                  height: getPlatformSize(9.73 * 12.0 / 5.88),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getPlatformSize(20.0),
                          vertical: getPlatformSize(0.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            // รูปรถ
                            Padding(
                              padding: EdgeInsets.only(
                                top: getPlatformSize(16.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  _getCarItem(
                                    language.lang,
                                    8,
                                    fourWheelsText.ofLanguage(language.lang),
                                    'assets/images/route/ic_car_small.png',
                                    46.0,
                                    25.8,
                                    15,
                                  ),
                                  _getCarItem(
                                    language.lang,
                                    10,
                                    sixToTenWheelsText.ofLanguage(language.lang),
                                    'assets/images/route/ic_car_medium-new.png',
                                    84.65,
                                    38.66,
                                    3,
                                  ),
                                  _getCarItem(
                                    language.lang,
                                    11,
                                    overTenWheelsText.ofLanguage(language.lang),
                                    'assets/images/route/ic_car_large-new.png',
                                    118.25,
                                    42.01,
                                    0,
                                  ),
                                ],
                              ),
                            ),

                            // ค่าผ่านทาง
                            widget.tollPlazaModel != null
                                ? (widget.tollPlazaModel.cost4Wheels == -1
                                    ? Container(
                                        padding: EdgeInsets.only(
                                          top: getPlatformSize(10.0),
                                          bottom: getPlatformSize(10.0),
                                          right: getPlatformSize(16.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            distanceBasedTollsText.ofLanguage(language.lang),
                                            style: getTextStyle(
                                              language.lang,
                                              color: TEXT_COLOR,
                                              sizeTh: Constants.Font.BIGGER_SIZE_TH,
                                              sizeEn: Constants.Font.BIGGER_SIZE_EN,
                                              heightTh: 1.0,
                                              heightEn: 1.2,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(
                                          right: getPlatformSize(16.0),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            _getFeeItem(
                                              language.lang,
                                              6,
                                              widget.tollPlazaModel.cost4Wheels,
                                            ),
                                            _getFeeItem(
                                              language.lang,
                                              6,
                                              widget.tollPlazaModel.cost6To10Wheels,
                                            ),
                                            _getFeeItem(
                                              language.lang,
                                              6,
                                              widget.tollPlazaModel.costOver10Wheels,
                                            ),
                                          ],
                                        ),
                                      ))
                                : SizedBox.shrink(),

                            // เส้นคั่น
                            Container(
                              height: 0.0,
                              margin: EdgeInsets.symmetric(
                                vertical: getPlatformSize(4.0),
                                horizontal: getPlatformSize(4.0),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0x707070).withOpacity(0.3),
                                    width: getPlatformSize(0.0),
                                  ),
                                ),
                              ),
                            ),

                            widget.tollPlazaModel != null
                                ? Container(
                                    height: getPlatformSize(234.0),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                      top: getPlatformSize(10.0),
                                      bottom: getPlatformSize(20.0),
                                    ),
                                    child: ListView.separated(
                                      itemCount: widget.tollPlazaModel.laneList.length,
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (BuildContext context, int index) {
                                        TollPlazaLaneModel lane =
                                            widget.tollPlazaModel.laneList[index];

                                        return TollPlazaLaneItemView(
                                          laneItem: lane,
                                          isFirstItem: index == 0,
                                          isLastItem:
                                              index == widget.tollPlazaModel.laneList.length - 1,
                                        );
                                      },
                                      separatorBuilder: (BuildContext context, int index) {
                                        return SizedBox.shrink();
                                      },
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
