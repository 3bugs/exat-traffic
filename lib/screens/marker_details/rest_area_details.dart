import 'dart:async';
import 'package:exattraffic/models/marker_categories/cctv_model.dart';
import 'package:exattraffic/models/marker_categories/rest_area_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/components/tool_item.dart';

class RestAreaDetails extends StatelessWidget {
  RestAreaDetails(this._restAreaModel);

  final RestAreaModel _restAreaModel;

  @override
  Widget build(BuildContext context) {
    return wrapSystemUiOverlayStyle(child: RestAreaDetailsMain(_restAreaModel));
  }
}

class RestAreaDetailsMain extends StatefulWidget {
  RestAreaDetailsMain(this._restAreaModel);

  final RestAreaModel _restAreaModel;

  @override
  _RestAreaDetailsMainState createState() => _RestAreaDetailsMainState();
}

class _RestAreaDetailsMainState extends State<RestAreaDetailsMain> {
  int _checkedToolItemIndex = 0;

  void _handleClickTool(int toolItemIndex) {
    /*setState(() {
      _checkedToolItemIndex = toolItemIndex;
    });*/
  }

  void _handleClickClose(BuildContext context) {
    //todo: stop video, etc.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getPlatformSize(0.0),
              //getPlatformSize(Constants.CctvPlayerScreen.HORIZONTAL_MARGIN),
              vertical: getPlatformSize(0.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: getPlatformSize(10.0),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        hoverColor: Color(0xFF999999),
                        splashColor: Color(0xFF999999),
                        highlightColor: Color(0xFF999999),
                        focusColor: Color(0xFF999999),
                        onTap: () => _handleClickClose(context),
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        child: Container(
                          width: getPlatformSize(36.0),
                          height: getPlatformSize(36.0),
                          //padding: EdgeInsets.all(getPlatformSize(15.0)),
                          child: Center(
                            child: Image(
                              image: AssetImage('assets/images/cctv_details/ic_close_cctv.png'),
                              width: getPlatformSize(13.5),
                              height: getPlatformSize(13.5),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getPlatformSize(16.0),
                ),
                Center(
                  child: Consumer<LanguageModel>(
                    builder: (context, language, child) {
                      String name;
                      switch (language.lang) {
                        case 0:
                          name = widget._restAreaModel.name;
                          break;
                        case 1:
                          name = 'About Us';
                          break;
                        case 2:
                          name = '关于我们';
                          break;
                      }
                      return Text(
                        name,
                        style: getTextStyle(
                          language.lang,
                          sizeTh: Constants.Font.BIGGER_SIZE_TH,
                          sizeEn: Constants.Font.BIGGER_SIZE_EN,
                          color: Colors.white,
                          isBold: true,
                          //heightEn: 1.5,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: getPlatformSize(25.0),
                ),
                Container(
                  height: getPlatformSize(240.0),
                  margin: EdgeInsets.symmetric(
                    horizontal: getPlatformSize(Constants.CctvPlayerScreen.HORIZONTAL_MARGIN),
                    vertical: getPlatformSize(0.0),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(
                      color: Colors.yellowAccent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(getPlatformSize(10.0)),
                    ),
                  ),
                  /*child: Center(
                    child: Image(
                      image: AssetImage('assets/images/cctv_details/ic_playback.png'),
                      width: getPlatformSize(89.0),
                      height: getPlatformSize(89.0),
                      fit: BoxFit.contain,
                    ),
                  ),*/
                ),
                SizedBox(
                  height: getPlatformSize(24.0),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getPlatformSize(Constants.CctvPlayerScreen.HORIZONTAL_MARGIN),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      widget._restAreaModel.hasParkingLot
                          ? ServiceItem(
                              'ที่จอดรถ',
                              AssetImage(
                                  'assets/images/rest_area_details/ic_rest_area_parking.png'),
                              getPlatformSize(28.4),
                              getPlatformSize(27.45),
                            )
                          : SizedBox.shrink(),
                      widget._restAreaModel.hasToilet
                          ? ServiceItem(
                              'ห้องน้ำ',
                              AssetImage('assets/images/rest_area_details/ic_rest_area_toilet.png'),
                              getPlatformSize(29.0),
                              getPlatformSize(30.96),
                            )
                          : SizedBox.shrink(),
                      widget._restAreaModel.hasGasStation
                          ? ServiceItem(
                              'น้ำมัน',
                              AssetImage('assets/images/rest_area_details/ic_rest_area_fuel.png'),
                              getPlatformSize(33.89),
                              getPlatformSize(28.43),
                            )
                          : SizedBox.shrink(),
                      widget._restAreaModel.hasRestaurant
                          ? ServiceItem(
                              'อาหาร',
                              AssetImage('assets/images/rest_area_details/ic_rest_area_food.png'),
                              getPlatformSize(18.66),
                              getPlatformSize(27.97),
                            )
                          : SizedBox.shrink(),
                      widget._restAreaModel.hasCafe
                          ? ServiceItem(
                              'กาแฟ',
                              AssetImage('assets/images/rest_area_details/ic_rest_area_cafe.png'),
                              getPlatformSize(21.89),
                              getPlatformSize(32.87),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                SizedBox(
                  height: getPlatformSize(28.0),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getPlatformSize(Constants.CctvPlayerScreen.HORIZONTAL_MARGIN),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      /*ToolItem(
                        'ภาพเคลื่อนไหว',
                        AssetImage('assets/images/cctv_details/ic_video.png'),
                        getPlatformSize(30.79),
                        getPlatformSize(25.51),
                        this._checkedToolItemIndex == 0,
                            () => this._handleClickTool(0),
                      ),
                      ToolItem(
                        'ภาพถ่าย',
                        AssetImage('assets/images/cctv_details/ic_picture.png'),
                        getPlatformSize(23.67),
                        getPlatformSize(20.06),
                        this._checkedToolItemIndex == 1,
                            () => this._handleClickTool(1),
                      ),*/
                      ToolItem(
                        'เส้นทาง',
                        AssetImage('assets/images/cctv_details/ic_route.png'),
                        getPlatformSize(27.06),
                        getPlatformSize(35.21),
                        false,
                        () => this._handleClickTool(0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceItem extends StatefulWidget {
  const ServiceItem(
    this._text,
    this._icon,
    this._iconWidth,
    this._iconHeight,
  );

  final String _text;
  final AssetImage _icon;
  final double _iconWidth;
  final double _iconHeight;

  @override
  _ServiceItemState createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Container(
          width: getPlatformSize(56.0),
          height: getPlatformSize(52.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: getPlatformSize(2.0),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                getPlatformSize(13.0),
              ),
            ),
          ),
          child: Center(
            child: Image(
              image: widget._icon,
              width: widget._iconWidth,
              height: widget._iconHeight,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
