import 'dart:async';
import 'dart:convert';
import 'package:exattraffic/models/error_model.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/home/home.dart';
import 'package:exattraffic/models/language_model.dart';

class MyRoute extends StatelessWidget {
  MyRoute({
    @required this.onUpdateBottomSheet,
  });

  final Function onUpdateBottomSheet;

  @override
  Widget build(BuildContext context) {
    return MyRouteMain(onUpdateBottomSheet: onUpdateBottomSheet);
  }
}

class MyRouteMain extends StatefulWidget {
  MyRouteMain({
    @required this.onUpdateBottomSheet,
  });

  final Function onUpdateBottomSheet;

  @override
  _MyRouteMainState createState() => _MyRouteMainState();
}

class _MyRouteMainState extends State<MyRouteMain> {
  final GlobalKey _keyGoogleMaps = GlobalKey();
  final Completer<GoogleMapController> _googleMapController = Completer();

  final Map<MarkerId, Marker> _markerMap = <MarkerId, Marker>{};

  static const CameraPosition INITIAL_POSITION = CameraPosition(
    target: LatLng(13.7563, 100.5018), // Bangkok
    zoom: 8,
  );

  //Future<List<GateInModel>> _futureGateInList;
  List<GateInModel> _gateInList;
  GateInModel _selectedGateIn;
  String _routeDestinationValue = 'ทดสอบ4';
  BitmapDescriptor _originMarkerIcon, _originMarkerIconLarge;
  BitmapDescriptor _destinationMarkerIcon, _destinationMarkerIconLarge;

  Future<void> _moveMapToCurrentPosition(BuildContext context) async {
    final Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final CameraPosition currentPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 10,
    );
    _moveMapToPosition(context, currentPosition);
  }

  Future<void> _moveMapToPosition(BuildContext context, CameraPosition position) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  void _addMarker(GateInModel gateIn) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId(gateIn.id.toString());

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(gateIn.latitude, gateIn.longitude),
      icon: gateIn.selected ? _originMarkerIconLarge : _originMarkerIcon,
      alpha: gateIn.selected ? 1.0 : Constants.RouteScreen.INITIAL_MARKER_OPACITY,
      //infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _selectMarker(gateIn);
      },
    );

    setState(() {
      _markerMap[markerId] = marker;
    });
  }

  // https://bezkoder.com/dart-flutter-parse-json-string-array-to-object-list/
  // https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51
  void _fetchGateIn() async {
    final response = await http.get(Constants.Api.GET_GATE_IN_URL);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBodyJson = json.decode(response.body);
      ErrorModel error = ErrorModel.fromJson(responseBodyJson['error']);

      if (error.code == 0) {
        List dataList = responseBodyJson['data_list'];
        List<GateInModel> gateInList =
            dataList.map((gateInJson) => GateInModel.fromJson(gateInJson)).toList();
        print('Number of Gate In : ${gateInList.length}');

        setState(() {
          _gateInList = gateInList;
        });
        _createMarkersFromModel();

        //return gateInList;
      } else {
        print(error.message);
        //throw Exception(error.message);
        /*new Future.delayed(Duration.zero, () {
          alert(context, 'ผิดพลาด', error.message);
        });*/
      }
    } else {
      print('เกิดข้อผิดพลาดในการเชื่อมต่อ Server');
      //throw Exception('เกิดข้อผิดพลาดในการเชื่อมต่อ Server');
      /*new Future.delayed(Duration.zero, () {
        alert(context, 'ผิดพลาด', 'เกิดข้อผิดพลาดในการเชื่อมต่อ Server');
      });*/
    }
  }

  void _setupCustomMarker() async {
    _originMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/route/ic_marker_origin.png',
    );
    _originMarkerIconLarge = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/route/ic_marker_origin-xxxhdpi.png',
    );
    _destinationMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/route/ic_marker_destination.png',
    );
    _destinationMarkerIconLarge = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/route/ic_marker_destination-xxxhdpi.png',
    );
  }

  void _createMarkersFromModel() {
    _markerMap.clear();
    for (GateInModel gateIn in _gateInList) {
      _addMarker(gateIn);
    }
  }

  void _selectMarker(GateInModel selectedGateIn) {
    setState(() {
      _selectedGateIn = selectedGateIn;
    });

    _gateInList.forEach((gateIn) {
      gateIn.selected = selectedGateIn == gateIn;
    });
    _createMarkersFromModel();
  }

  @override
  void initState() {
    super.initState();

    /*BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/route/ic_marker_origin.png',
    ).then((value) {
      _originMarkerIcon = value;
    });*/

    _setupCustomMarker();
    _fetchGateIn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /*decoration: BoxDecoration(
        border: Border.all(
          color: Colors.redAccent,
          width: 2.0,
        ),
      ),*/
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          GoogleMap(
            key: _keyGoogleMaps,
            mapType: MapType.normal,
            initialCameraPosition: INITIAL_POSITION,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController.complete(controller);
              _moveMapToCurrentPosition(context);
            },
            markers: Set<Marker>.of(_markerMap.values),
          ),
          Positioned(
            top: getPlatformSize(-32.0),
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(
                left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x55777777),
                      blurRadius: getPlatformSize(3.0),
                      spreadRadius: getPlatformSize(1.5),
                      offset: Offset(
                        getPlatformSize(1.0), // move right
                        getPlatformSize(1.0), // move down
                      ),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(getPlatformSize(7.0)),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: getPlatformSize(14.0),
                    bottom: getPlatformSize(10.0),
                    left: getPlatformSize(19.0),
                    right: getPlatformSize(19.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: getPlatformSize(19.5),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: getPlatformSize(19.5),
                              height: getPlatformSize(19.5),
                              decoration: BoxDecoration(
                                color: Color(0xFF5995FA),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(getPlatformSize(9.75)),
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: getPlatformSize(7.5),
                                  height: getPlatformSize(7.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(getPlatformSize(3.75)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 0.0,
                              height: getPlatformSize(48.0),
                              margin: EdgeInsets.symmetric(
                                horizontal: getPlatformSize(0.0),
                                vertical: getPlatformSize(5.0),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Color(0xFF707070),
                                    width: getPlatformSize(1.0),
                                  ),
                                ),
                              ),
                            ),
                            Image(
                              image: AssetImage('assets/images/map_markers/ic_marker_small.png'),
                              width: getPlatformSize(14.33),
                              height: getPlatformSize(19.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getPlatformSize(10.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            // ข้อความ Pickup Location
                            Padding(
                              padding: EdgeInsets.only(
                                left: getPlatformSize(6.0),
                                top: getPlatformSize(2.0),
                              ),
                              child: Text(
                                'Pickup Location',
                                style: getTextStyle(
                                  1,
                                  color: Color(0xFFB2B2B2),
                                  sizeEn: Constants.Font.SMALLER_SIZE_EN,
                                  sizeTh: Constants.Font.SMALLER_SIZE_TH,
                                ),
                              ),
                            ),

                            // dropdown เลือกต้นทาง
                            /*FutureBuilder<List<GateInModel>>(
                              future: _futureGateInList,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<GateInModel>(
                                      value: _selectedGateIn,
                                      icon: Image(
                                        image: AssetImage('assets/images/route/ic_down_arrow.png'),
                                        width: getPlatformSize(12.0),
                                        height: getPlatformSize(7.4),
                                      ),
                                      iconSize: getPlatformSize(24.0),
                                      elevation: 2,
                                      //style: getTextStyle(1),
                                      underline: SizedBox.shrink(),
                                      isDense: true,
                                      isExpanded: true,
                                      onChanged: (GateInModel gateIn) {
                                        setState(() {
                                          _selectedGateIn = gateIn;
                                        });
                                      },
                                      items: snapshot.data.map((GateInModel gateIn) {
                                        return DropdownMenuItem<GateInModel>(
                                          value: gateIn,
                                          child: Consumer<LanguageModel>(
                                            builder: (context, language, child) {
                                              return Container(
                                                padding: EdgeInsets.only(
                                                  left: getPlatformSize(6.0),
                                                ),
                                                child: Text(
                                                  gateIn.toString(),
                                                  style: getTextStyle(
                                                    language.lang,
                                                    isBold: false,
                                                    heightTh: 0.8,
                                                    heightEn: 1.15,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }
                                return CircularProgressIndicator();
                              },
                            ),*/

                            // dropdown เลือกต้นทาง
                            DropdownButton<GateInModel>(
                              value: _selectedGateIn,
                              icon: Image(
                                image: AssetImage('assets/images/route/ic_down_arrow.png'),
                                width: getPlatformSize(12.0),
                                height: getPlatformSize(7.4),
                              ),
                              iconSize: getPlatformSize(24.0),
                              elevation: 2,
                              //style: getTextStyle(1),
                              underline: SizedBox.shrink(),
                              isDense: true,
                              isExpanded: true,
                              onChanged: (GateInModel gateIn) {
                                _selectMarker(gateIn);

                                final CameraPosition position = CameraPosition(
                                  target: LatLng(gateIn.latitude, gateIn.longitude),
                                  zoom: 12,
                                );
                                _moveMapToPosition(context, position);
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return _gateInList.map<Widget>((GateInModel gateIn) {
                                  return Consumer<LanguageModel>(
                                    builder: (context, language, child) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                          left: getPlatformSize(6.0),
                                        ),
                                        child: Text(
                                          gateIn.toString(),
                                          style: getTextStyle(
                                            language.lang,
                                            heightTh: 0.8,
                                            heightEn: 1.15,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList();
                              },
                              items: _gateInList.map((GateInModel gateIn) {
                                return DropdownMenuItem<GateInModel>(
                                  value: gateIn,
                                  child: Consumer<LanguageModel>(
                                    builder: (context, language, child) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                          left: getPlatformSize(6.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              gateIn.routeId.toString(),
                                              style: getTextStyle(
                                                language.lang,
                                                color: Color(0xFFB2B2B2),
                                                sizeTh: Constants.Font.SMALLER_SIZE_TH,
                                                sizeEn: Constants.Font.SMALLER_SIZE_EN,
                                              ),
                                            ),
                                            Text(
                                              gateIn.toString().trim(),
                                              style: getTextStyle(
                                                language.lang,
                                                heightTh: 0.8,
                                                heightEn: 1.15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),

                            // เส้นคั่นแนวนอน
                            Container(
                              margin: EdgeInsets.only(
                                top: getPlatformSize(6.0),
                                bottom: getPlatformSize(10.0),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF707070).withOpacity(0.33),
                                    width: getPlatformSize(1.0),
                                  ),
                                ),
                              ),
                            ),

                            // ช้อความ Destination Location
                            Padding(
                              padding: EdgeInsets.only(
                                left: getPlatformSize(6.0),
                                top: getPlatformSize(2.0),
                              ),
                              child: Text(
                                'Destination Location',
                                style: getTextStyle(
                                  1,
                                  color: Color(0xFFB2B2B2),
                                  sizeEn: Constants.Font.SMALLER_SIZE_EN,
                                  sizeTh: Constants.Font.SMALLER_SIZE_TH,
                                ),
                              ),
                            ),

                            // dropdown เลือกปลายทาง
                            DropdownButton<String>(
                              value: _routeDestinationValue,
                              icon: Image(
                                image: AssetImage('assets/images/route/ic_down_arrow.png'),
                                width: getPlatformSize(12.0),
                                height: getPlatformSize(7.4),
                              ),
                              iconSize: getPlatformSize(24.0),
                              elevation: 2,
                              //style: getTextStyle(1),
                              underline: SizedBox.shrink(),
                              isDense: true,
                              isExpanded: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _routeDestinationValue = newValue;
                                });
                              },
                              items: <String>['ทดสอบ1', 'ทดสอบ2', 'ทดสอบ3', 'ทดสอบ4']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Consumer<LanguageModel>(
                                    builder: (context, language, child) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: getPlatformSize(6.0),
                                        ),
                                        child: Text(
                                          value,
                                          style: getTextStyle(
                                            language.lang,
                                            isBold: false,
                                            heightTh: 0.8,
                                            heightEn: 1.15,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: getPlatformSize(100.0),
              left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
              right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  MapToolItem(
                    icon: AssetImage('assets/images/map_tools/ic_map_tool_location.png'),
                    iconWidth: getPlatformSize(21.0),
                    iconHeight: getPlatformSize(21.0),
                    marginTop: getPlatformSize(10.0),
                    isChecked: false,
                    onClick: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
