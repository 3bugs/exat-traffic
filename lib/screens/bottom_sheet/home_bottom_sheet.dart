import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';

//import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/express_way_model.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/services/api.dart';

//import 'package:exattraffic/components/my_progress_indicator.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/components/lazy_indexed_stack.dart';
import 'package:exattraffic/components/error_view.dart';
import 'package:exattraffic/models/error_model.dart';

import 'components/bottom_sheet_scaffold.dart';
import 'components/express_way.dart';
import 'components/traffic_point_item.dart';

List<String> expressWayHeaderList = [
  'ทางพิเศษ',
  'Expressway',
  '高速公路',
];

class HomeBottomSheet extends StatefulWidget {
  static final List<TrafficPointDataModel> trafficPointDataList = List();

  HomeBottomSheet({
    @required this.expandPosition,
    @required this.collapsePosition,
  });

  final double expandPosition;
  final double collapsePosition;

  @override
  _HomeBottomSheetState createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet> {
  final GlobalKey<BottomSheetScaffoldState> _keyBottomSheetScaffold = GlobalKey();

  ExpressWayModel _selectedExpressWay;
  bool _bottomSheetExpanded = false;

  //SocketIO _socketIO;
  Timer _timer;
  List<ExpressWayModel> _futureExpressWayList;
  ErrorModel _error;

  void _fetchTrafficData(Function callback) {
    MyApi.fetchTrafficData().then((trafficPointDataList) {
      /*print("++++++++++++++++++++ TRAFFIC DATA ++++++++++++++++++++");
      print(trafficPointDataList);
      print("-------------------- TRAFFIC DATA --------------------");*/

      HomeBottomSheet.trafficPointDataList.clear();
      HomeBottomSheet.trafficPointDataList.addAll(trafficPointDataList);

      if (callback != null) {
        callback();
      }
    });
  }

  _fetchExpressWays(BuildContext context) async {
    setState(() {
      _error = null;
    });

    List<MarkerModel> markerList = BlocProvider.of<AppBloc>(context).markerList;
    // ถ้าเอา fetch api ไปใส่ใน future builder โดยตรง จะทำให้ fetch ใหม่ทุกครั้งที่กลับมา list express way
    try {
      List<ExpressWayModel> tempList = await ExatApi.fetchExpressWays(context, markerList);
      setState(() {
        _futureExpressWayList = tempList;
        _error = null;
      });
    } catch (error) {
      setState(() {
        _error = ErrorModel(code: 1, message: error.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(new Duration(minutes: 5), (timer) {
      //timer.tick.toString();
      _fetchTrafficData(() {
        setState(() {});
      });
    });
    _fetchTrafficData(null);

    Future.delayed(Duration.zero, () {
      _fetchExpressWays(context);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /*void _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  void _onSocketInfo(dynamic data) {
    print("Socket info: " + data);
  }*/

  void _handleClickUpDownSheet() {
    _keyBottomSheetScaffold.currentState.toggleSheet();
  }

  void _handleChangeSize(bool sheetExpanded) {
    setState(() {
      _bottomSheetExpanded = sheetExpanded;
    });
  }

  void _handleClickBack(BuildContext context) {
    setState(() {
      _selectedExpressWay = null;
    });
  }

  void _handleClickExpressWay(BuildContext context, ExpressWayModel expressWayModel) {
    setState(() {
      _selectedExpressWay = expressWayModel;
    });
  }

  void _handleClickTrafficPoint(BuildContext context, TrafficPointModel trafficPoint) {
    trafficPoint.cctvMarkerModel.showDetailsScreen(context);
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CctvDetails(trafficPoint.cctvMarkerModel)),
      //MaterialPageRoute(builder: (context) => RestAreaDetails(cctvModel)),
    );*/
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
          padding: EdgeInsets.only(
            left: getPlatformSize(0.0),
            right: getPlatformSize(0.0),
            top: getPlatformSize(10.0),
            bottom: getPlatformSize(0.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: getPlatformSize(8.0),
                  ),
                  _selectedExpressWay == null
                      ? SizedBox(
                          width: getPlatformSize(42.0),
                        )
                      : Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _handleClickBack(context);
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
                                  image: AssetImage('assets/images/home/ic_back.png'),
                                  width: getPlatformSize(12.0),
                                  height: getPlatformSize(12.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                  Expanded(
                    child: Center(
                      child: Consumer<LanguageModel>(
                        builder: (context, language, child) {
                          String name;
                          if (_selectedExpressWay != null) {
                            switch (language.lang) {
                              case 0:
                                name = _selectedExpressWay.name;
                                break;
                              case 1:
                                name = 'Expressway';
                                break;
                              case 2:
                                name = '高速公路';
                                break;
                            }
                          }
                          return Text(
                            _selectedExpressWay == null
                                ? expressWayHeaderList[language.lang]
                                : name,
                            style: getTextStyle(language.lang, isBold: true),
                          );
                        },
                      ),
                    ),
                  ),
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
                            //image: AssetImage('assets/images/home/ic_sheet_down.png'),
                            image: _bottomSheetExpanded
                                ? AssetImage('assets/images/home/ic_sheet_down.png')
                                : AssetImage('assets/images/home/ic_sheet_up.png'),
                            width: getPlatformSize(12.0),
                            height: getPlatformSize(6.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getPlatformSize(14.0),
                  ),
                ],
              ),
              SizedBox(height: getPlatformSize(4.0)),
              Expanded(
                child: _error == null
                    ? _futureExpressWayList != null
                        ? LazyIndexedStack(
                            reuse: false,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? ExpressWayList(_futureExpressWayList, _handleClickExpressWay)
                                  : ExpressWayDetails(
                                      Key(_selectedExpressWay.name),
                                      _selectedExpressWay,
                                      _handleClickTrafficPoint,
                                    );
                            },
                            itemCount: 2,
                            index: _selectedExpressWay == null ? 0 : 1,
                          )
                        : Center(
                            child: SizedBox(
                              width: getPlatformSize(25.0),
                              height: getPlatformSize(25.0),
                              child: CircularProgressIndicator(
                                strokeWidth: getPlatformSize(3.0),
                              ),
                            ),
                          )
                    : Center(
                        child: ErrorView(
                          //text: "ขออภัย เกิดข้อผิดพลาดในการดึงข้อมูลทางพิเศษ",
                          buttonText: "เกิดข้อผิดพลาด กรุณาลองใหม่",
                          onClick: () => _fetchExpressWays(context),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpressWayList extends StatefulWidget {
  ExpressWayList(this._expressWayList, this._onSelectExpressWay);

  final List<ExpressWayModel> _expressWayList;
  final Function _onSelectExpressWay;

  @override
  _ExpressWayListState createState() => _ExpressWayListState();
}

class _ExpressWayListState extends State<ExpressWayList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getPlatformSize(120.0),
      child: ListView.separated(
        itemCount: widget._expressWayList.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          ExpressWayModel selectedExpressWay = widget._expressWayList[index];

          return ExpressWayImageView(
            expressWay: selectedExpressWay,
            isFirstItem: index == 0,
            isLastItem: index == widget._expressWayList.length - 1,
            onClick: () {
              widget._onSelectExpressWay(context, selectedExpressWay);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: getPlatformSize(0.0),
          );
        },
      ),
    );
  }
}

class ExpressWayDetails extends StatefulWidget {
  ExpressWayDetails(Key key, this._expressWay, this._onSelectTrafficPoint) : super(key: key);

  final ExpressWayModel _expressWay;
  final Function _onSelectTrafficPoint;

  @override
  _ExpressWayDetailsState createState() => _ExpressWayDetailsState();
}

class _ExpressWayDetailsState extends State<ExpressWayDetails> {
  LegModel _selectedLeg;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initLeg();
  }

  void _initLeg() {
    if ((widget._expressWay != null) && (widget._expressWay.legList.length > 0)) {
      _selectedLeg = widget._expressWay.legList[0];
    } else {
      _selectedLeg = null;
    }
  }

  void _handleClickLeg(LegModel legModel) {
    setState(() {
      _selectedLeg = legModel;
    });
    Timer(
      Duration(milliseconds: 100),
      () => _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget._expressWay != null
        ? Column(
            children: <Widget>[
              // list ทางพิเศษ (text), todo: เปลี่ยนเป็น route
              Container(
                height: getPlatformSize(44.0),
                child: ListView.separated(
                  itemCount: widget._expressWay.legList.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    LegModel leg = widget._expressWay.legList[index];

                    return LegView(
                      legModel: leg,
                      isFirstItem: index == 0,
                      isLastItem: index == widget._expressWay.legList.length - 1,
                      selected: leg == _selectedLeg,
                      onSelectLeg: _handleClickLeg,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox.shrink();
                  },
                ),
              ),

              _selectedLeg != null
                  ?
                  // traffic point list
                  Expanded(
                      child: Container(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: _selectedLeg.trafficPointList.length,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            TrafficPointModel trafficPoint = _selectedLeg.trafficPointList[index];

                            return TrafficPointView(
                              trafficPoint: trafficPoint,
                              isFirstItem: index == 0,
                              isLastItem: index == _selectedLeg.trafficPointList.length - 1,
                              onClick: () {
                                widget._onSelectTrafficPoint(context, trafficPoint);
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          )
        : SizedBox.shrink();
  }
}
