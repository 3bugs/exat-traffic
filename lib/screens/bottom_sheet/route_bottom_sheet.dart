import 'package:exattraffic/screens/route/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/services/google_maps_services.dart';
import 'package:exattraffic/storage/place_favorite_prefs.dart';
import 'package:exattraffic/models/locale_text.dart';

import 'components/bottom_sheet_scaffold.dart';

LocaleText bahtText = LocaleText.baht();
LocaleText fourWheelsText = LocaleText.fourWheels();
LocaleText sixToTenWheelsText = LocaleText.sixToTenWheels();
LocaleText overTenWheelsText = LocaleText.overTenWheels();
LocaleText totalTollsText = LocaleText.totalTolls();

class RouteBottomSheet extends StatefulWidget {
  RouteBottomSheet({
    @required this.expandPosition,
    @required this.collapsePosition,
    @required this.gateIn,
    @required this.costToll,
    @required this.googleRoute,
    this.destination,
    @required this.departureTimestamp,
    @required this.showArrivalTime,
    this.onClickTimePeriodOption,
  });

  final double expandPosition;
  final double collapsePosition;
  final GateInModel gateIn;
  final CostTollModel costToll;
  final Map<String, dynamic> googleRoute;
  final PlaceDetailsModel destination;
  final int departureTimestamp;
  final bool showArrivalTime;
  final Function onClickTimePeriodOption;

  @override
  _RouteBottomSheetState createState() => _RouteBottomSheetState();
}

class _RouteBottomSheetState extends State<RouteBottomSheet> {
  final GlobalKey<BottomSheetScaffoldState> _keyBottomSheetScaffold = GlobalKey();

  bool _bottomSheetExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleClickUpDownSheet() {
    _keyBottomSheetScaffold.currentState.toggleSheet();
  }

  void _handleChangeSize(bool sheetExpanded) {
    setState(() {
      _bottomSheetExpanded = sheetExpanded;
    });
  }

  Widget _getCarItem(LanguageName language, int widthFlex, String label, String iconPath,
      double iconWidth, double iconHeight, double iconMarginTop) {
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
                color: Colors.white,
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
            height: getPlatformSize(4.0),
          ),
          Image(
            image: AssetImage('assets/images/route/ic_sheet_down_white.png'),
            width: getPlatformSize(10.0),
            height: getPlatformSize(9.73 * 10.0 / 5.88),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: getPlatformSize(4.0),
              bottom: getPlatformSize(8.0),
            ),
            child: Text(
              totalTollsText.ofLanguage(language),
              style: getTextStyle(
                language,
                color: Colors.white,
                sizeTh: Constants.Font.SMALLER_SIZE_TH,
                sizeEn: Constants.Font.SMALLER_SIZE_EN,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: getPlatformSize(6.0),
              bottom: getPlatformSize(0.0),
            ),
            child: Text(
              fee.toString(),
              style: getTextStyle(
                LanguageName.english,
                color: Colors.white,
                sizeTh: 50.0,
                sizeEn: 35.0,
                heightEn: 0.9 / 0.9,
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
                color: Colors.white,
                sizeTh: Constants.Font.BIGGER_SIZE_TH,
                sizeEn: Constants.Font.BIGGER_SIZE_EN,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedTime(LanguageName lang, DateTime dateTime) {
    String hourText = (dateTime.hour < 10 ? "0" : "") + dateTime.hour.toString();
    String minuteText = (dateTime.minute < 10 ? "0" : "") + dateTime.minute.toString();
    return lang == LanguageName.thai ? '$hourText.$minuteText' : '$hourText:$minuteText';
  }

  String _getArrivalTimeText(LanguageName lang) {
    int routeDurationSeconds = widget.googleRoute == null
        ? 0
        : widget.googleRoute['legs'][0]['duration_in_traffic']['value'];

    DateTime departureDate = widget.departureTimestamp == 0
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(widget.departureTimestamp * 1000);
    DateTime arrivalDate = departureDate.add(Duration(seconds: routeDurationSeconds));
    return _getFormattedTime(lang, arrivalDate);
  }

  String _getDepartArrivalText(LanguageName lang) {
    if (widget.departureTimestamp == 0) {
      return sprintf(LocaleText.leaveNowArrive().ofLanguage(lang), [_getArrivalTimeText(lang)]);
    } else {
      DateTime departureDate =
          DateTime.fromMillisecondsSinceEpoch(widget.departureTimestamp * 1000);

      return sprintf(LocaleText.leaveArrive().ofLanguage(lang),
          [_getFormattedTime(lang, departureDate), _getArrivalTimeText(lang)]);
    }
  }

  int _getNumTollPlaza() {
    int tollPlazaCount = 0;

    if (widget.gateIn.marker != null &&
        widget.gateIn.marker.category.code == CategoryType.TOLL_PLAZA) {
      tollPlazaCount++;
    }
    if (widget.costToll.marker != null &&
        widget.costToll.marker.category.code == CategoryType.TOLL_PLAZA) {
      tollPlazaCount++;
    }
    for (MarkerModel marker in widget.costToll.partTollMarkerList) {
      if (marker.category.code == CategoryType.TOLL_PLAZA) {
        tollPlazaCount++;
      }
    }

    return tollPlazaCount;
  }

  Future<Icon> _getFavoriteIcon() async {
    return (await PlaceFavoritePrefs().existId(widget.destination.placeId))
        ? Icon(
            Icons.star,
            color: Constants.App.FAVORITE_ON_COLOR,
            size: getPlatformSize(24.0),
            semanticLabel: 'Favorite',
          )
        : Icon(
            Icons.star_border,
            color: Colors.white,
            size: getPlatformSize(24.0),
            semanticLabel: 'Favorite',
          );
  }

  void _handleClickFavorite() async {
    //PlaceFavoritePrefs prefs = PlaceFavoritePrefs();
    PlaceFavoritePrefs prefs = Provider.of<PlaceFavoritePrefs>(context, listen: false);
    LanguageModel language = Provider.of<LanguageModel>(context, listen: false);

    if (await prefs.existId(widget.destination.placeId)) {
      List<DialogButtonModel> dialogButtonList = [
        DialogButtonModel(text: "ไม่ใช่", value: DialogResult.no),
        DialogButtonModel(text: "ใช่", value: DialogResult.yes)
      ];
      DialogResult result = await showMyDialog(
        context,
        LocaleText.confirmDeleteFromFavorite().ofLanguage(language.lang),
        //"ยืนยันลบ '${widget.destination.name}' ออกจากรายการโปรด?",
        dialogButtonList,
      );
      if (result == DialogResult.yes) {
        prefs.removePlace(widget.destination.placeId).then((_) {
          setState(() {
            Fluttertoast.showToast(
              msg: LocaleText.deletedFromFavorite().ofLanguage(language.lang),
              //msg: "ลบ '${widget.destination.name}' ออกจากรายการโปรดแล้ว",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xFFDEDEDE),
              textColor: Colors.black,
              fontSize: 14.0,
            );
          });
        });
      }
    } else {
      prefs
          .addPlace(PlaceFavoriteModel(widget.destination.placeId, widget.destination.name))
          .then((_) {
        setState(() {
          Fluttertoast.showToast(
            msg: LocaleText.savedToFavorite().ofLanguage(language.lang),
            //msg: "เพิ่ม '${widget.destination.name}' ในรายการโปรดแล้ว",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xFFDEDEDE),
            textColor: Colors.black,
            fontSize: 14.0,
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScaffold(
      key: _keyBottomSheetScaffold,
      expandPosition: widget.expandPosition,
      collapsePosition: widget.collapsePosition,
      onChangeSize: _handleChangeSize,
      child: Expanded(
        child: GestureDetector(
          onTap: _handleClickUpDownSheet,
          onVerticalDragUpdate: (details) {
            double sensitivity = 3.0;
            if ((details.delta.dy < -sensitivity &&
                !_keyBottomSheetScaffold.currentState.bottomSheetExpanded) ||
                (details.delta.dy > sensitivity &&
                    _keyBottomSheetScaffold.currentState.bottomSheetExpanded)) {
              _handleClickUpDownSheet();
            }
          },
          child: Container(
            color: Constants.BottomSheet.DARK_BACKGROUND_COLOR,
            padding: EdgeInsets.only(
              left: getPlatformSize(20.0),
              right: getPlatformSize(4.0),
              top: getPlatformSize(4.0),
              bottom: getPlatformSize(0.0),
            ),
            child: Consumer<LanguageModel>(
              builder: (context, language, child) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        // ข้อความบอกเวลา ระยะทาง
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: getPlatformSize(6.0),
                            ),
                            child: BlocBuilder<RouteBloc, RouteState>(
                              builder: (context, state) {
                                return state is FetchDirectionsInitial
                                    ? Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: getPlatformSize(6.0),
                                              vertical: getPlatformSize(0.0),
                                            ),
                                            child: SizedBox(
                                              width: getPlatformSize(20.0),
                                              height: getPlatformSize(20.0),
                                              child: CircularProgressIndicator(
                                                strokeWidth: getPlatformSize(3.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: getPlatformSize(4.0),
                                          ),
                                          Text(
                                            LocaleText.findingRoute().ofLanguage(language.lang),
                                            style: getTextStyle(
                                              language.lang,
                                              color: Colors.white.withOpacity(0.6),
                                              sizeTh: Constants.Font.BIGGER_SIZE_TH,
                                              sizeEn: Constants.Font.BIGGER_SIZE_EN,
                                            ),
                                          ),
                                          Text(
                                            '.',
                                            style: getTextStyle(
                                              language.lang,
                                              color: Colors.transparent,
                                              sizeTh: Constants.Font.BIGGEST_SIZE_TH,
                                              sizeEn: Constants.Font.BIGGEST_SIZE_EN,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            widget.googleRoute == null
                                                ? ''
                                                : (language.lang == LanguageName.thai
                                                    ? widget.googleRoute['legs'][0]
                                                        ['duration_in_traffic']['text']
                                                    /*.replaceAll('hours', 'ชม.')
                                                .replaceAll('hour', 'ชม.')
                                                .replaceAll('mins', 'นาที')
                                                .replaceAll('min', 'นาที')*/
                                                    : widget.googleRoute['legs'][0]
                                                        ['duration_in_traffic']['text']),
                                            style: getTextStyle(
                                              language.lang,
                                              isBold: true,
                                              color: Colors.white,
                                              sizeTh: Constants.Font.BIGGEST_SIZE_TH,
                                              sizeEn: Constants.Font.BIGGEST_SIZE_EN,
                                            ),
                                          ),
                                          SizedBox(
                                            width: getPlatformSize(12.0),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: getPlatformSize(4.0)),
                                            child: Text(
                                              widget.googleRoute == null
                                                  ? ''
                                                  : '(${widget.googleRoute['legs'][0]['distance']['text']})',
                                              style: getTextStyle(
                                                language.lang,
                                                color: Colors.white,
                                                sizeTh: Constants.Font.BIGGER_SIZE_TH,
                                                sizeEn: Constants.Font.BIGGER_SIZE_EN,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                              },
                            ),
                          ),
                        ),

                        // ปุ่ม favorite
                        widget.destination != null
                            ? Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _handleClickFavorite,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(getPlatformSize(21.0)),
                                  ),
                                  child: Container(
                                    width: getPlatformSize(42.0),
                                    height: getPlatformSize(42.0),
                                    //padding: EdgeInsets.all(getPlatformSize(15.0)),
                                    child: Center(
                                      child: FutureBuilder(
                                          future: _getFavoriteIcon(),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            return snapshot.hasData
                                                ? snapshot.data
                                                : SizedBox.shrink();
                                          }),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),

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
                                      ? AssetImage('assets/images/route/ic_sheet_down_white.png')
                                      : AssetImage('assets/images/route/ic_sheet_up_white.png'),
                                  width: getPlatformSize(12.0),
                                  height: getPlatformSize(9.73 * 12.0 / 5.88),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ถึงเวลา, ผ่านที่ด่าน
                    Padding(
                      padding: EdgeInsets.only(
                        right: getPlatformSize(16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          widget.showArrivalTime
                              ? Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.onClickTimePeriodOption != null) {
                                        widget.onClickTimePeriodOption();
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.5,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(getPlatformSize(4.0)),
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                        top: getPlatformSize(2.0),
                                        bottom: getPlatformSize(2.0),
                                        left: getPlatformSize(8.0),
                                        right: getPlatformSize(4.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            _getDepartArrivalText(language.lang),
                                            style: getTextStyle(
                                              language.lang,
                                              color: Colors.white,
                                              sizeTh: Constants.Font.SMALLER_SIZE_TH,
                                              sizeEn: Constants.Font.SMALLER_SIZE_EN,
                                            ),
                                          ),
                                          SizedBox(
                                            width: getPlatformSize(6.0),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  sprintf(LocaleText.totalTollPlaza().ofLanguage(language.lang),
                                      [_getNumTollPlaza()]),
                                  style: getTextStyle(
                                    language.lang,
                                    color: Colors.white,
                                    sizeTh: Constants.Font.SMALLER_SIZE_TH,
                                    sizeEn: Constants.Font.SMALLER_SIZE_EN,
                                  ),
                                ),
                          widget.showArrivalTime
                              ? Text(
                                  sprintf(LocaleText.totalTollPlaza().ofLanguage(language.lang),
                                      [_getNumTollPlaza()]),
                                  style: getTextStyle(
                                    language.lang,
                                    color: Colors.white,
                                    sizeTh: Constants.Font.SMALLER_SIZE_TH,
                                    sizeEn: Constants.Font.SMALLER_SIZE_EN,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),

                    // เส้นคั่น
                    Container(
                      height: 0.0,
                      margin: EdgeInsets.only(
                        top: getPlatformSize(16.0),
                        bottom: getPlatformSize(16.0),
                        right: getPlatformSize(16.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.26),
                            width: getPlatformSize(0.0),
                          ),
                        ),
                      ),
                    ),

                    // รูปรถ
                    Padding(
                      padding: EdgeInsets.only(
                        right: getPlatformSize(16.0),
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
                    Padding(
                      padding: EdgeInsets.only(
                        right: getPlatformSize(16.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          _getFeeItem(language.lang, 6,
                              widget.costToll == null ? 0 : widget.costToll.cost4Wheels),
                          _getFeeItem(language.lang, 6,
                              widget.costToll == null ? 0 : widget.costToll.cost6To10Wheels),
                          _getFeeItem(language.lang, 6,
                              widget.costToll == null ? 0 : widget.costToll.costOver10Wheels),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
