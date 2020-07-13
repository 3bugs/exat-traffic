import 'dart:async';
import 'package:exattraffic/models/alert_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:exattraffic/screens/route/bloc/bloc.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/home/home.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/screens/bottom_sheet/route_bottom_sheet.dart';

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
  StreamSubscription<Position> _positionStreamSubscription;

  static const CameraPosition INITIAL_POSITION = CameraPosition(
    target: LatLng(13.7563, 100.5018), // Bangkok
    zoom: 10,
  );
  static const SPEED_THRESHOLD_TO_TRACK_LOCATION = 10; // km per hour

  double _googleMapsTop = 0; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  double _googleMapsHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()

  BitmapDescriptor _originMarkerIcon, _originMarkerIconLarge;
  BitmapDescriptor _destinationMarkerIcon, _destinationMarkerIconLarge;
  BitmapDescriptor _tollPlazaMarkerIcon;
  BitmapDescriptor _carMarkerIcon;

  Timer _locationTimer;
  bool _myLocationEnabled = false;
  LatLng _mapTarget;
  double _mapZoomLevel;

  void _handleClickMyLocation(BuildContext context) {
    _moveMapToCurrentPosition(context);
    setState(() {
      _myLocationEnabled = true;
    });

    if (_locationTimer != null) {
      _locationTimer.cancel();
    }
    _locationTimer = Timer(Duration(seconds: 10), () {
      setState(() {
        _myLocationEnabled = false;
      });
    });
  }

  void _handleCameraMove(CameraPosition cameraPosition) {
    _mapTarget = cameraPosition.target;
    _mapZoomLevel = cameraPosition.zoom;
  }
  
  Future<void> _moveMapToCurrentPosition(BuildContext context) async {
    final Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final CameraPosition currentPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: _mapZoomLevel ?? 15,
    );
    _moveMapToPosition(context, currentPosition);
  }

  Future<void> _moveMapToPosition(BuildContext context, CameraPosition position) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Marker _createGateInMarker(BuildContext context, GateInModel gateIn) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('gate-in-${gateIn.id.toString()}');

    return Marker(
      markerId: markerId,
      position: LatLng(gateIn.latitude, gateIn.longitude),
      icon: gateIn.selected ? _originMarkerIconLarge : _originMarkerIcon,
      alpha: gateIn.selected ? 1.0 : Constants.RouteScreen.INITIAL_MARKER_OPACITY,
      infoWindow: (true)
          ? InfoWindow(
              title: gateIn.name + (kReleaseMode ? "" : " [${gateIn.categoryId}]"),
              snippet: gateIn.routeName,
            )
          : InfoWindow.noText,
      onTap: () {
        _selectGateInMarker(context, gateIn);
      },
    );
  }

  Marker _createCostTollMarker(BuildContext context, CostTollModel costToll) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('cost-toll-${costToll.id.toString()}');

    return Marker(
      markerId: markerId,
      position: LatLng(costToll.latitude, costToll.longitude),
      icon: costToll.selected ? _destinationMarkerIconLarge : _destinationMarkerIcon,
      alpha: costToll.selected ? 1.0 : Constants.RouteScreen.INITIAL_MARKER_OPACITY,
      infoWindow: (true)
          ? InfoWindow(
              title: costToll.name + (kReleaseMode ? "" : " [${costToll.categoryId}]"),
              snippet: costToll.routeName,
            )
          : InfoWindow.noText,
      onTap: () {
        _selectCostTollMarker(context, costToll);
      },
    );
  }

  Marker _createPartTollMarker(MarkerModel partTollMarker) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('part-toll-${partTollMarker.id.toString()}');

    return Marker(
      markerId: markerId,
      position: LatLng(partTollMarker.latitude, partTollMarker.longitude),
      icon: _tollPlazaMarkerIcon,
      infoWindow: (true)
          ? InfoWindow(
              title: partTollMarker.name + (kReleaseMode ? "" : " [${partTollMarker.categoryId}]"),
              snippet: partTollMarker.routeName,
            )
          : InfoWindow.noText,
      onTap: () {},
    );
  }

  Marker _createCurrentLocationMarker(Position currentLocation) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('current-location');

    return Marker(
      markerId: markerId,
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      icon: _carMarkerIcon,
      rotation: currentLocation.heading,
      anchor: const Offset(0.5, 0.5),
    );
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

    _tollPlazaMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/map_markers/ic_marker_toll_plaza_small.png',
    );

    _carMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/map_markers/ic_marker_car-w60.png',
    );
  }

  void _selectGateInMarker(BuildContext context, GateInModel selectedGateIn) {
    context.bloc<RouteBloc>().add(GateInSelected(selectedGateIn: selectedGateIn));
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.pause();
    }
  }

  void _selectCostTollMarker(BuildContext context, CostTollModel selectedCostToll) {
    context.bloc<RouteBloc>().add(CostTollSelected(selectedCostToll: selectedCostToll));
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
    _setupCustomMarker();

    //_fetchGateIn();
  }

  void _setupLocationUpdate(BuildContext context) {
    const LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    );

    final Stream<Position> positionStream = Geolocator().getPositionStream(locationOptions);
    _positionStreamSubscription = positionStream.listen((Position position) {
      print("Current location: ${position.latitude}, ${position.longitude}");
      context.bloc<RouteBloc>().add(UpdateCurrentLocation(currentLocation: position));
    });
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<RouteBloc>(
          create: (context) {
            RouteBloc routeBloc = RouteBloc();
            routeBloc.add(ListGateIn());
            return routeBloc;
          },
        )
      ],
      child: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            BlocBuilder<RouteBloc, RouteState>(
              builder: (context, state) {
                print("***** BLOC_BUILDER *****");

                final List<GateInModel> gateInList = state.gateInList ?? List();
                final List<CostTollModel> costTollList = state.costTollList ?? List();
                final GateInModel selectedGateIn = state.selectedGateIn;
                final CostTollModel selectedCostToll = state.selectedCostToll;
                final googleRoute = state.googleRoute;
                final Position currentLocation = state.currentLocation;
                final AlertModel notification = state.notification;

                if (notification != null) {
                  Future.delayed(Duration.zero, () {
                    alert(context, notification.title, notification.message);
                  });
                }

                List<GateInModel> filteredGateInList = gateInList.where((GateInModel gateIn) {
                  return selectedGateIn == null ? true : gateIn.selected;
                }).toList();
                Set<Marker> gateInMarkerSet = filteredGateInList.map((GateInModel gateIn) {
                  return _createGateInMarker(context, gateIn);
                }).toSet();

                List<CostTollModel> filteredCostTollList =
                    costTollList.where((CostTollModel costToll) {
                  return selectedCostToll == null ? true : costToll.selected;
                }).toList();
                Set<Marker> costTollMarkerSet = filteredCostTollList.map((CostTollModel costToll) {
                  return _createCostTollMarker(context, costToll);
                }).toSet();

                Set<Marker> partTollSet = Set();
                if (selectedCostToll != null) {
                  partTollSet = selectedCostToll.partTollMarkerList
                      .map((partToll) => _createPartTollMarker(partToll))
                      .toSet();
                }

                final Set<Polyline> polyLineSet = <Polyline>{};
                Polyline polyline;
                if (googleRoute != null) {
                  polyline = createRoutePolyline(googleRoute['overview_polyline']['points']);
                  polyLineSet.add(polyline);
                }

                Set<Marker> currentLocationSet = Set();
                if (currentLocation != null) {
                  currentLocationSet.add(_createCurrentLocationMarker(currentLocation));
                }

                if (state is FetchGateInSuccess) {
                  print("STATE: FetchGateInSuccess");

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
                  print("STATE: FetchCostTollSuccess");

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
                  print("STATE: FetchDirectionsSuccess");

                  // pan/zoom map ให้ครอบคลุม bound ของ directions polyline
                  new Future.delayed(Duration(milliseconds: 1000), () async {
                    LatLngBounds latLngBounds = _boundsFromLatLngList(polyline.points);
                    final GoogleMapController controller = await _googleMapController.future;
                    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
                  });

                  // get current location จะได้แสดง marker รูปรถบน maps ทันที ไม่ต้องรอ location update
                  Geolocator().getCurrentPosition().then((Position position) {
                    context.bloc<RouteBloc>().add(UpdateCurrentLocation(currentLocation: position));
                  });

                  if (_positionStreamSubscription == null) {
                    _setupLocationUpdate(context);
                    _positionStreamSubscription.pause();
                  }
                  if (_positionStreamSubscription.isPaused) {
                    _positionStreamSubscription.resume();
                  }
                } else if (state is LocationTrackingUpdated) {
                  if (currentLocation.speed * 3.6 > SPEED_THRESHOLD_TO_TRACK_LOCATION) {
                    final CameraPosition position = CameraPosition(
                      target: LatLng(currentLocation.latitude, currentLocation.longitude),
                      zoom: _mapZoomLevel ?? 15,
                    );
                    _moveMapToPosition(context, position);
                  }
                }

                return GoogleMap(
                  key: _keyGoogleMaps,
                  /*padding: EdgeInsets.only(
                    top: getPlatformSize(20.0),
                  ),*/
                  mapType: MapType.normal,
                  initialCameraPosition: INITIAL_POSITION,
                  myLocationEnabled: _myLocationEnabled,
                  myLocationButtonEnabled: false,
                  trafficEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _googleMapController.complete(controller);
                    //_moveMapToCurrentPosition(context);
                  },
                  onCameraMove: _handleCameraMove,
                  markers: gateInMarkerSet
                      .union(costTollMarkerSet)
                      .union(partTollSet)
                      .union(currentLocationSet),
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
                top: getPlatformSize(90.0),
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
                      onClick: () => _handleClickMyLocation(context),
                    ),
                  ],
                ),
              ),
            ),

            BlocBuilder<RouteBloc, RouteState>(
              builder: (context, state) {
                final CostTollModel selectedCostToll = state.selectedCostToll;

                return selectedCostToll == null
                    ? SizedBox.shrink()
                    : RouteBottomSheet(
                        collapsePosition: _googleMapsHeight -
                            getPlatformSize(Constants.BottomSheet.HEIGHT_ROUTE_COLLAPSED),
                        expandPosition: _googleMapsHeight -
                            getPlatformSize(Constants.BottomSheet.HEIGHT_ROUTE_EXPANDED),
                        selectedCostToll: selectedCostToll,
                        googleRoute: state.googleRoute,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
