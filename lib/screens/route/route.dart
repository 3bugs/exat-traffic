import 'dart:async';
import 'dart:convert';
import 'package:exattraffic/models/marker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'package:exattraffic/screens/route/bloc/bloc.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/home/home.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/error_model.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/screens/bottom_sheet/route_bottom_sheet.dart';
import 'package:exattraffic/services/google_maps_services.dart';

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
  final GoogleMapsServices _googleMapsServices = GoogleMapsServices();

  final Map<MarkerId, Marker> _gateInMarkerMap = <MarkerId, Marker>{};
  final Map<MarkerId, Marker> _costTollMarkerMap = <MarkerId, Marker>{};
  final Map<MarkerId, Marker> _partTollMarkerMap = <MarkerId, Marker>{};

  final Set<Polyline> _polyLines = <Polyline>{};

  static const CameraPosition INITIAL_POSITION = CameraPosition(
    target: LatLng(13.7563, 100.5018), // Bangkok
    zoom: 10,
  );

  double _googleMapsTop = 0; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  double _googleMapsHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()

  List<GateInModel> _gateInList = List();
  List<CostTollModel> _costTollList = List();
  GateInModel _selectedGateIn;
  CostTollModel _selectedCostToll;
  Map<String, dynamic> _googleRoute;
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

  Marker _createGateInMarkerFromModel(BuildContext context, GateInModel gateIn) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('gate-in-${gateIn.id.toString()}');

    return Marker(
      markerId: markerId,
      position: LatLng(gateIn.latitude, gateIn.longitude),
      icon: gateIn.selected ? _originMarkerIconLarge : _originMarkerIcon,
      alpha: gateIn.selected ? 1.0 : Constants.RouteScreen.INITIAL_MARKER_OPACITY,
      infoWindow: (true)
          ? InfoWindow(
              title: gateIn.name,
              snippet: gateIn.routeName,
            )
          : InfoWindow.noText,
      onTap: () {
        _selectGateInMarker(context, gateIn);
      },
    );
  }

  Marker _createCostTollMarkerFromModel(BuildContext context, CostTollModel costToll) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('cost-toll-${costToll.id.toString()}');

    return Marker(
      markerId: markerId,
      position: LatLng(costToll.latitude, costToll.longitude),
      icon: costToll.selected ? _destinationMarkerIconLarge : _destinationMarkerIcon,
      alpha: costToll.selected ? 1.0 : Constants.RouteScreen.INITIAL_MARKER_OPACITY,
      infoWindow: (true)
          ? InfoWindow(
              title: costToll.name,
              snippet: costToll.routeName,
            )
          : InfoWindow.noText,
      onTap: () {
        _selectCostTollMarker(context, costToll);
      },
    );
  }

  void _addPartTollMarker(MarkerModel partTollMarker) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('marker-${partTollMarker.id.toString()}');

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(partTollMarker.latitude, partTollMarker.longitude),
      //icon: markerModel.selected ? _destinationMarkerIconLarge : _destinationMarkerIcon,
      //alpha: markerModel.selected ? 1.0 : Constants.RouteScreen.INITIAL_MARKER_OPACITY,
      infoWindow: (true)
          ? InfoWindow(
              title: partTollMarker.name,
              snippet: partTollMarker.routeName,
            )
          : InfoWindow.noText,
      onTap: () {},
    );

    setState(() {
      _partTollMarkerMap[markerId] = marker;
    });
  }

  void _setupCustomMarker() async {
    _originMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/route/ic_marker_origin-xhdpi.png',
    );
    _originMarkerIconLarge = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/route/ic_marker_origin-xxhdpi.png',
    );
    _destinationMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/route/ic_marker_destination-xhdpi.png',
    );
    _destinationMarkerIconLarge = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/route/ic_marker_destination-xxhdpi.png',
    );
  }

  void _createMarkersFromModel() {
    bool isGateInSelected = _gateInList.fold(
      false,
      (previousValue, gateIn) => previousValue || gateIn.selected,
    );
    _gateInMarkerMap.clear();
    for (GateInModel gateIn in _gateInList) {
      if (gateIn.selected || (!gateIn.selected && !isGateInSelected)) {
        //_addGateInMarker(gateIn);
      }
    }

    bool isCostTollSelected = _costTollList.fold(
      false,
      (previousValue, costToll) => previousValue || costToll.selected,
    );
    _costTollMarkerMap.clear();
    _partTollMarkerMap.clear();
    for (CostTollModel costToll in _costTollList) {
      if (costToll.selected || (!costToll.selected && !isCostTollSelected)) {
        //_addCostTollMarker(costToll);
      }
      if (costToll.selected) {
        costToll.partTollMarkerList.map((partToll) => _addPartTollMarker(partToll)).toList();
      }
    }
  }

  void _selectGateInMarker(BuildContext context, GateInModel selectedGateIn) {
    context.bloc<RouteBloc>().add(GateInSelected(selectedGateIn: selectedGateIn));

    // ถ้าหมุดถูกเลือกอยู่แล้ว ไม่ต้องทำอะไร
    /*if (selectedGateIn.selected) return;

    setState(() {
      _selectedGateIn = selectedGateIn;
      _selectedCostToll = null;
      _polyLines.clear();
    });

    _gateInList.forEach((gateIn) {
      gateIn.selected = selectedGateIn == gateIn;
    });
    _createMarkersFromModel();

    _fetchCostTollByGateIn(selectedGateIn);*/
  }

  void _selectCostTollMarker(BuildContext context, CostTollModel selectedCostToll) {
    context.bloc<RouteBloc>().add(CostTollSelected(selectedCostToll: selectedCostToll));

    // ถ้าหมุดถูกเลือกอยู่แล้ว ไม่ต้องทำอะไร
    /*if (selectedCostToll.selected) return;

    setState(() {
      _selectedCostToll = selectedCostToll;
    });

    _costTollList.forEach((costToll) {
      costToll.selected = selectedCostToll == costToll;
    });
    _createMarkersFromModel();

    Map<String, dynamic> route = await _googleMapsServices.getRoute(
      LatLng(_selectedGateIn.latitude, _selectedGateIn.longitude),
      LatLng(_selectedCostToll.latitude, _selectedCostToll.longitude),
    );
    createRoutePolyline(route['overview_polyline']['points']);
    setState(() {
      _googleRoute = route;
    });*/
  }

  Polyline createRoutePolyline(String encodedPoly) {
    final List<LatLng> latLngList = _convertToLatLngList(_decodePoly(encodedPoly));

    return Polyline(
      polylineId: PolylineId('1'),
      width: 6,
      points: latLngList,
      color: Color(0xFF747474).withOpacity(1.0),
    );
  }

  List<LatLng> _convertToLatLngList(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    print(lList.toString());
    return lList;
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> latLngList) {
    double x0, x1, y0, y1;
    for (LatLng latLng in latLngList) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    /*BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/route/ic_marker_origin.png',
    ).then((value) {
      _originMarkerIcon = value;
    });*/

    _setupCustomMarker();
    //_fetchGateIn();
  }

  _afterLayout(_) {
    final RenderBox mainContainerRenderBox = _keyGoogleMaps.currentContext.findRenderObject();
    setState(() {
      _googleMapsTop = mainContainerRenderBox.localToGlobal(Offset.zero).dy;
      _googleMapsHeight = mainContainerRenderBox.size.height;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        RouteBloc routeBloc = RouteBloc();
        routeBloc.add(ListGateIn());
        return routeBloc;
      },
      child: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            BlocBuilder<RouteBloc, RouteState>(
              builder: (context, state) {
                final List<GateInModel> gateInList = state.gateInList ?? List();
                final List<CostTollModel> costTollList = state.costTollList ?? List();
                final selectedGateIn = state.selectedGateIn;
                final selectedCostToll = state.selectedCostToll;
                final googleRoute = state.googleRoute;

                List<GateInModel> filteredGateInList = gateInList.where((GateInModel gateIn) {
                  return selectedGateIn == null ? true : gateIn.selected;
                }).toList();
                Set<Marker> gateInMarkerSet = filteredGateInList.map((GateInModel gateIn) {
                  return _createGateInMarkerFromModel(context, gateIn);
                }).toSet();

                List<CostTollModel> filteredCostTollList =
                    costTollList.where((CostTollModel costToll) {
                  return selectedCostToll == null ? true : costToll.selected;
                }).toList();
                Set<Marker> costTollMarkerSet = filteredCostTollList.map((CostTollModel costToll) {
                  return _createCostTollMarkerFromModel(context, costToll);
                }).toSet();

                final Set<Polyline> polyLineSet = <Polyline>{};
                Polyline polyline;
                if (googleRoute != null) {
                  polyline =
                      createRoutePolyline(googleRoute['overview_polyline']['points']);
                  polyLineSet.add(polyline);
                }

                if (state is FetchGateInSuccess) {
                  // pan/zoom map ให้ครอบคลุม bound ของ gateIn ทั้งหมด
                  new Future.delayed(Duration(milliseconds: 1000), () async {
                    List<LatLng> gateInLatLngList = gateInList
                        .map((gateIn) => LatLng(gateIn.latitude, gateIn.longitude))
                        .toList();
                    LatLngBounds latLngBounds = _boundsFromLatLngList(gateInLatLngList);
                    final GoogleMapController controller = await _googleMapController.future;
                    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
                  });
                } else if (state is FetchCostTollSuccess) {
                  // pan/zoom map ให้ครอบคลุม bound ของ costToll ทั้งหมด & selectedGateIn
                  new Future.delayed(Duration(milliseconds: 1000), () async {
                    List<LatLng> costTollLatLngList = costTollList
                        .map((costToll) => LatLng(costToll.latitude, costToll.longitude))
                        .toList();
                    costTollLatLngList
                        .add(LatLng(selectedGateIn.latitude, selectedGateIn.longitude));
                    LatLngBounds latLngBounds = _boundsFromLatLngList(costTollLatLngList);
                    final GoogleMapController controller = await _googleMapController.future;
                    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
                  });
                } else if (state is FetchDirectionsSuccess) {
                  // pan/zoom map ให้ครอบคลุม bound ของ directions polyline
                  new Future.delayed(Duration(milliseconds: 1000), () async {
                    LatLngBounds latLngBounds = _boundsFromLatLngList(polyline.points);
                    final GoogleMapController controller = await _googleMapController.future;
                    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
                  });
                }

                return GoogleMap(
                  key: _keyGoogleMaps,
                  /*padding: EdgeInsets.only(
                    top: getPlatformSize(20.0),
                  ),*/
                  mapType: MapType.normal,
                  initialCameraPosition: INITIAL_POSITION,
                  myLocationEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _googleMapController.complete(controller);
                    //_moveMapToCurrentPosition(context);
                  },
                  onCameraMove: (CameraPosition position) {
                    /*setState(() {
                    _zoomLevel = position.zoom;
                  });*/
                  },
                  markers: gateInMarkerSet.union(costTollMarkerSet),
                  polylines: polyLineSet,
                );
              },
            ),

            // ช่องเลือกทางเข้า/ทางออก
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
                      top: getPlatformSize(10.0),
                      bottom: getPlatformSize(6.0),
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
                              /*Container(
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
                              ),*/
                              Image(
                                image:
                                    AssetImage('assets/images/route/ic_marker_origin-xxxhdpi.png'),
                                width: getPlatformSize(16.0),
                                height: getPlatformSize(16.0 * 28.42 / 21.13),
                              ),
                              Container(
                                width: 0.0,
                                height: getPlatformSize(30.0),
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
                                image: AssetImage(
                                    'assets/images/route/ic_marker_destination-xxxhdpi.png'),
                                width: getPlatformSize(16.0),
                                height: getPlatformSize(16.0 * 28.42 / 21.13),
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
                              BlocBuilder<RouteBloc, RouteState>(
                                builder: (context, state) {
                                  final gateInList = state.gateInList ?? List();
                                  final selectedGateIn = state.selectedGateIn;

                                  return DropdownButton<GateInModel>(
                                    value: selectedGateIn,
                                    hint: Consumer<LanguageModel>(
                                      builder: (context, language, child) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                            left: getPlatformSize(6.0),
                                          ),
                                          child: Text(
                                            'เลือกต้นทาง',
                                            style: getTextStyle(
                                              language.lang,
                                              color: Color(0xFFB2B2B2),
                                              heightTh: 0.8,
                                              heightEn: 1.15,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
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
                                      _selectGateInMarker(context, gateIn);

                                      final CameraPosition position = CameraPosition(
                                        target: LatLng(gateIn.latitude, gateIn.longitude),
                                        zoom: 12,
                                      );
                                      _moveMapToPosition(context, position);
                                    },
                                    selectedItemBuilder: (BuildContext context) {
                                      return gateInList.map<Widget>((GateInModel gateIn) {
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
                                    items: gateInList.map((GateInModel gateIn) {
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
                                                    gateIn.routeName.trim(),
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
                                  );
                                },
                              ),

                              // เส้นคั่นแนวนอน
                              Container(
                                margin: EdgeInsets.only(
                                  top: getPlatformSize(2.0),
                                  bottom: getPlatformSize(6.0),
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFF707070).withOpacity(0.33),
                                      width: getPlatformSize(0.0),
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
                              BlocBuilder<RouteBloc, RouteState>(builder: (context, state) {
                                final costTollList = state.costTollList ?? List();
                                final selectedCostToll = state.selectedCostToll;

                                return DropdownButton<CostTollModel>(
                                  value: selectedCostToll,
                                  hint: Consumer<LanguageModel>(
                                    builder: (context, language, child) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                          left: getPlatformSize(6.0),
                                        ),
                                        child: Text(
                                          'เลือกปลายทาง',
                                          style: getTextStyle(
                                            language.lang,
                                            color: Color(0xFFB2B2B2),
                                            heightTh: 0.8,
                                            heightEn: 1.15,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                                  onChanged: (CostTollModel costToll) {
                                    _selectCostTollMarker(context, costToll);

                                    final CameraPosition position = CameraPosition(
                                      target: LatLng(costToll.latitude, costToll.longitude),
                                      zoom: 12,
                                    );
                                    _moveMapToPosition(context, position);
                                  },
                                  selectedItemBuilder: (BuildContext context) {
                                    return costTollList.map<Widget>((CostTollModel costToll) {
                                      return Consumer<LanguageModel>(
                                        builder: (context, language, child) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                              left: getPlatformSize(6.0),
                                            ),
                                            child: Text(
                                              costToll.toString(),
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
                                  items: costTollList.map((CostTollModel costToll) {
                                    return DropdownMenuItem<CostTollModel>(
                                      value: costToll,
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
                                                  costToll.routeName,
                                                  style: getTextStyle(
                                                    language.lang,
                                                    color: Color(0xFFB2B2B2),
                                                    sizeTh: Constants.Font.SMALLER_SIZE_TH,
                                                    sizeEn: Constants.Font.SMALLER_SIZE_EN,
                                                  ),
                                                ),
                                                Text(
                                                  costToll.toString().trim(),
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
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // map tools
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

            // bottom sheet
            Visibility(
              visible: _selectedCostToll != null,
              child: RouteBottomSheet(
                collapsePosition: _googleMapsHeight -
                    getPlatformSize(Constants.BottomSheet.HEIGHT_ROUTE_COLLAPSED),
                expandPosition: _googleMapsHeight -
                    getPlatformSize(Constants.BottomSheet.HEIGHT_ROUTE_EXPANDED),
                selectedCostToll: _selectedCostToll,
                googleRoute: _googleRoute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
