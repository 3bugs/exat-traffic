import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/*import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';*/
//import 'package:socket_io_client/socket_io_client.dart' as IO;
//import 'package:adhara_socket_io/adhara_socket_io.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/express_way_model.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/marker_categories/cctv_model.dart';
import 'package:exattraffic/screens/marker_details/cctv_details.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/components/my_progress_indicator.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/components/lazy_indexed_stack.dart';

import 'components/bottom_sheet_scaffold.dart';
import 'components/express_way.dart';
import 'components/traffic_point_item.dart';

List<String> expressWayHeaderList = [
  'ทางพิเศษ',
  'Expressway',
  '高速公路',
];

class HomeBottomSheet extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();

    /*IO.Socket socket = IO.io("http://163.47.9.26", <String, dynamic>{
      'autoConnect': false,
    });
    socket.on('connect', (_) {
      print("Socket.IO connected!");
    });
    socket.on('update-traffic', (data) {
      print(data);
    });
    print("Connecting 163.47.9.26 ...");
    socket.connect();*/

    /////////////////////////////////////////////////////////////////////

    /*_socketIO = SocketIOManager().createSocketIO(
      "http://163.47.9.26",
      "",
      socketStatusCallback: _socketStatus,
    );
    //call init socket before doing anything
    _socketIO.init();
    //subscribe event
    _socketIO.subscribe("update-traffic", _onSocketInfo);
    //connect socket
    _socketIO.connect();*/
  }

  @override
  void dispose() {
    /*if (_socketIO != null) {
      _socketIO.unSubscribe("update-traffic");
      _socketIO.disconnect();
    }
    SocketIOManager().destroySocket(_socketIO);*/
    super.dispose();
  }

  void _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  void _onSocketInfo(dynamic data) {
    print("Socket info: " + data);
  }

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
            top: getPlatformSize(8.0),
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
              Expanded(
                child: LazyIndexedStack(
                  reuse: false,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? ExpressWayList(_handleClickExpressWay)
                        : ExpressWayDetails(
                            Key(_selectedExpressWay.name),
                            _selectedExpressWay,
                            _handleClickTrafficPoint,
                          );
                  },
                  itemCount: 2,
                  index: _selectedExpressWay == null ? 0 : 1,
                ),
                /*child: IndexedStack(
                  children: <Widget>[
                    ExpressWayList(_handleClickExpressWay),
                    ExpressWayDetails(_selectedExpressWay, _handleClickTrafficPoint)
                  ],
                  index: _selectedExpressWay == null ? 0 : 1,
                ),*/
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpressWayList extends StatefulWidget {
  ExpressWayList(this._onSelectExpressWay);

  final Function _onSelectExpressWay;

  @override
  _ExpressWayListState createState() => _ExpressWayListState();
}

class _ExpressWayListState extends State<ExpressWayList> {
  Future<List<ExpressWayModel>> _futureExpressWayList;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      List<MarkerModel> markerList = BlocProvider.of<AppBloc>(context).markerList;
      _futureExpressWayList = ExatApi.fetchExpressWays(context, markerList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getPlatformSize(120.0),
      child: FutureBuilder(
        future: _futureExpressWayList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.separated(
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    ExpressWayModel selectedExpressWay = snapshot.data[index];

                    return ExpressWayImageView(
                      expressWay: selectedExpressWay,
                      isFirstItem: index == 0,
                      isLastItem: index == snapshot.data.length - 1,
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
                )
              : Center(
                  child: CircularProgressIndicator(),
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
