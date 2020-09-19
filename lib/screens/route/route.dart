import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

import 'package:exattraffic/screens/route/bloc/bloc.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/home/home.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/gate_in_model.dart';
import 'package:exattraffic/models/cost_toll_model.dart';
import 'package:exattraffic/screens/bottom_sheet/route_bottom_sheet.dart';
import 'package:exattraffic/app/bloc.dart';
import 'package:exattraffic/models/alert_model.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/models/marker_categories/toll_plaza_model.dart';
import 'package:exattraffic/screens/bottom_sheet/toll_plaza_bottom_sheet.dart';
import 'package:exattraffic/screens/search/search_place.dart';
import 'package:exattraffic/models/locale_text.dart';
import 'package:exattraffic/components/options_dialog.dart';
import 'package:exattraffic/components/my_progress_indicator.dart';
import 'package:exattraffic/components/error_view.dart';

class MyRoute extends StatefulWidget {
  final Function showBestRouteAfterSearch;

  const MyRoute(Key key, this.showBestRouteAfterSearch) : super(key: key);

  @override
  MyRouteState createState() => MyRouteState();
}

class MyRouteState extends State<MyRoute> {
  final GlobalKey _keyGoogleMaps = GlobalKey();
  final GlobalKey<TollPlazaBottomSheetState> _keyTollPlazaBottomSheet = GlobalKey();
  final Completer<GoogleMapController> _googleMapController = Completer();
  StreamSubscription<Position> _positionStreamSubscription;

  static const CameraPosition INITIAL_POSITION = CameraPosition(
    target: LatLng(13.7563, 100.5018), // Bangkok
    zoom: 10,
  );
  static const SPEED_THRESHOLD_TO_TRACK_LOCATION = 20; // km per hour
  static const double LOCATION_TRACKING_ZOOM = 18;
  static const double LOCATION_TRACKING_TILT = 60;

  bool _isLoading = false;

  //double _googleMapsTop = 0; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  double _googleMapsHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()

  Uint8List _originMarkerIcon, _originMarkerIconLarge;
  Uint8List _destinationMarkerIcon, _destinationMarkerIconLarge;
  Uint8List _carMarkerIcon;

  Timer _locationTimer;
  bool _myLocationEnabled = false;

  //LatLng _mapTarget;
  double _zoom;
  bool _labelVisible = false;
  RouteBloc _routeBloc;

  TollPlazaModel _tollPlaza;

  List<int> _timePeriodList;
  bool _timePeriodDialogVisible = false;

  static const String FROM_ENTRANCE = 'FROM ENTRANCE';
  static const String TO_EXIT = 'TO EXIT';
  static const String ORIGIN = 'ORIGIN';
  static const String DESTINATION = 'DESTINATION';
  String _entranceLabel = FROM_ENTRANCE;
  String _exitLabel = TO_EXIT;

  void _handleClickTimePeriodOptionInBottomSheet() {
    if (_timePeriodDialogVisible)
      _hideTimePeriodDialog();
    else
      _showTimePeriodDialog();
  }

  void _showTimePeriodDialog() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _timePeriodList = await ExatApi.fetchTimePeriod(context);
      setState(() {
        _timePeriodDialogVisible = true;
      });
    } catch (e) {
      alert(context, "", e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _hideTimePeriodDialog() {
    setState(() {
      _timePeriodDialogVisible = false;
    });
  }

  void _handleClickMyLocation(BuildContext context) {
    _moveMapToCurrentPosition(context).then((locationEnabled) {
      if (locationEnabled) {
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
      } else {
        LanguageModel language = Provider.of<LanguageModel>(context, listen: false);
        showMyDialog(
          context,
          LocaleText.locationNotAvailable().ofLanguage(language.lang),
          //Constants.Message.LOCATION_NOT_AVAILABLE,
          [DialogButtonModel(text: "OK", value: DialogResult.yes)],
        );
      }
    });
  }

  void _handleClickSearch(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (context, anim1, anim2) => SearchPlace(),
      ),
    ).then((bestRoute) {
      if (bestRoute != null && widget.showBestRouteAfterSearch != null) {
        widget.showBestRouteAfterSearch(bestRoute);
      }
    });
  }

  Future<void> _handleClickTimePeriodOption(int time) async {
    _hideTimePeriodDialog();
    //RouteModel bestRoute = BlocProvider.of<RouteBloc>(context).bestRoute;
    setState(() {
      _isLoading = true;
    });
    int departureTimestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round() + (time * 60);
    RouteModel newBestRoute = await _routeBloc.bestRoute.destination.findBestRouteAgain(
        context, _routeBloc.bestRoute.gateInCostTollList[0], time == 0 ? 0 : departureTimestamp);
    setState(() {
      _routeBloc.add(ShowSearchResultRoute(bestRoute: newBestRoute));
      _isLoading = false;
    });
  }

  void _stopLocationTracking() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
    }
    _positionStreamSubscription = null;
  }

  void _handleCameraMove(CameraPosition cameraPosition) {
    //_mapTarget = cameraPosition.target;
    double oldZoom = _zoom;
    double newZoom = cameraPosition.zoom;
    _zoom = cameraPosition.zoom;
    print("ZOOM LEVEL: $_zoom");
    if ((oldZoom >= 12 && newZoom < 12) || (oldZoom < 12 && newZoom >= 12)) {
      setState(() {});
    }
  }

  Future<bool> _moveMapToCurrentPosition(BuildContext context) async {
    final Position position = await getCurrentLocationNotNull();

    if (position != null) {
      final CameraPosition currentPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: _zoom ?? 15,
      );
      _moveMapToPosition(context, currentPosition);
      return true;
    } else {
      return false;
    }
  }

  Future<void> _moveMapToPosition(BuildContext context, CameraPosition position) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Future<Set<Marker>> _createLabelMarkerSet(
    BuildContext context,
    List<GateInModel> gateInList,
    List<CostTollModel> costTollList,
    bool costTollSelected,
  ) async {
    Set<Marker> labelMarkerSet = Set();

    if (_labelVisible) {
      for (GateInModel gateIn in gateInList) {
        Marker label = await _createLabel(
          context,
          'gate-in-${gateIn.id.toString()}',
          gateIn.name,
          LatLng(gateIn.latitude, gateIn.longitude),
          Constants.App.PRIMARY_COLOR.withOpacity(0.7),
        );
        labelMarkerSet.add(label);
      }
      for (CostTollModel costToll in costTollList) {
        Marker label = await _createLabel(
          context,
          'cost-toll-${costToll.id.toString()}',
          costToll.name,
          LatLng(costToll.latitude, costToll.longitude),
          Colors.redAccent.withOpacity(0.6),
        );
        labelMarkerSet.add(label);
      }
    }

    return labelMarkerSet;
  }

  Future<Marker> _createLabel(
    BuildContext context,
    String idText,
    String name,
    LatLng latLng,
    Color bgColor,
  ) async {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('label-$idText');

    BitmapDescriptor bitmap =
        BitmapDescriptor.fromBytes(await getBytesFromCanvas(name, bgColor));
    TextPainter painter = getLabelTextPainter(name, Colors.black);
    try {
      print('+++++++++++++++++++++++++++++++++++++++++PAINTER WIDTH: ${painter.width}');
    } catch (e) {
      print('ERROR IN _createLabel(): ${e.toString()}');
    }

    return Marker(
      markerId: markerId,
      position: latLng,
      icon: bitmap,
      anchor: Offset(-0.08, 1),
    );
  }

  TextPainter getLabelTextPainter(String text, Color bgColor) {
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: '  $text  ',
      style: getTextStyle(
        LanguageName.thai,
        sizeTh: 60.0,
        sizeEn: 60.0,
        //isBold: true,
        color: Colors.white,
        //bgColor: Constants.BottomSheet.DARK_BACKGROUND_COLOR.withOpacity(0.5),
        bgColor: bgColor,
      ),
    );
    return painter;
  }

  Future<Uint8List> getBytesFromCanvas(String label, Color bgColor) async {
    final int height = 70;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    /*final Paint paint = Paint()..color = Constants.App.ACCENT_COLOR.withOpacity(0.6);
    final Radius radius = Radius.circular(10.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint,
    );*/

    TextPainter painter = getLabelTextPainter(label, bgColor);
    painter.layout();
    painter.paint(
      canvas,
      //Offset((width * 0.5) - painter.width * 0.5, (height * 0.5) - painter.height * 0.5),
      Offset(0.0, (height * 0.5) - painter.height * 0.5),
    );
    final img = await pictureRecorder.endRecording().toImage(painter.width.floor(), painter.height.floor());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return data.buffer.asUint8List();
  }

  Marker _createGateInMarker(BuildContext context, GateInModel gateIn, bool costTollSelected) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('gate-in-${gateIn.id.toString()}');

    return Marker(
      markerId: markerId,
      position: LatLng(gateIn.latitude, gateIn.longitude),
      icon:
          BitmapDescriptor.fromBytes(gateIn.selected ? _originMarkerIconLarge : _originMarkerIcon),
      alpha: (gateIn.selected || (_zoom != null && _zoom > 12))
          ? 1.0
          : Constants.RouteScreen.INITIAL_MARKER_OPACITY,
      infoWindow: (true)
          ? InfoWindow(
              title: gateIn.name + (kReleaseMode ? "" : " [${gateIn.categoryId}]"),
              snippet: gateIn.routeName,
            )
          : InfoWindow.noText,
      onTap: () {
        if (costTollSelected &&
            gateIn.marker != null &&
            gateIn.marker.category.code == CategoryType.TOLL_PLAZA) {
          setState(() {
            _tollPlaza = TollPlazaModel.fromMarkerModel(gateIn.marker);
            _keyTollPlazaBottomSheet.currentState.toggleSheet();
          });
        }

        _selectGateInMarker(context, gateIn);
      },
    );
  }

  Marker _createCostTollMarker(
      BuildContext context, CostTollModel costToll, bool costTollSelected) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('cost-toll-${costToll.id.toString()}');

    return Marker(
      markerId: markerId,
      position: LatLng(costToll.latitude, costToll.longitude),
      icon: BitmapDescriptor.fromBytes(
          costToll.selected ? _destinationMarkerIconLarge : _destinationMarkerIcon),
      alpha: (costToll.selected || (_zoom != null && _zoom > 12))
          ? 1.0
          : Constants.RouteScreen.INITIAL_MARKER_OPACITY,
      infoWindow: (true)
          ? InfoWindow(
              title: costToll.name + (kReleaseMode ? "" : " [${costToll.categoryId}]"),
              snippet: costToll.routeName,
            )
          : InfoWindow.noText,
      onTap: () {
        if (costTollSelected &&
            costToll.marker != null &&
            costToll.marker.category.code == CategoryType.TOLL_PLAZA) {
          setState(() {
            _tollPlaza = TollPlazaModel.fromMarkerModel(costToll.marker);
            _keyTollPlazaBottomSheet.currentState.toggleSheet();
          });
        }

        _selectCostTollMarker(context, costToll);
      },
    );
  }

  Future<Set<Marker>> _createPartTollFutureMarkerSet(List<MarkerModel> partTollMarkerList) async {
    Set<Marker> markerSet = Set();
    for (MarkerModel markerModel in partTollMarkerList) {
      Marker marker = await _createFutureMarker(markerModel);
      markerSet.add(marker);
    }
    return markerSet;
  }

  Future<Marker> _createFutureMarker(MarkerModel markerModel) async {
    if (markerModel != null) {
      //String markerIdVal = uuid.v1();
      final MarkerId markerId = MarkerId('part-toll-${markerModel.id.toString()}');
      BitmapDescriptor markerIcon = await markerModel.category.getNetworkIcon();

      return Marker(
        markerId: markerId,
        position: LatLng(markerModel.latitude, markerModel.longitude),
        icon: markerIcon,
        alpha: 1.0,
        infoWindow: (true)
            ? InfoWindow(
                title: markerModel.name + (kReleaseMode ? "" : " [${markerModel.categoryId}]"),
                snippet: markerModel.routeName,
              )
            : InfoWindow.noText,
        onTap: () {
          if (markerModel.category.code == CategoryType.TOLL_PLAZA) {
            setState(() {
              _tollPlaza = TollPlazaModel.fromMarkerModel(markerModel);
              _keyTollPlazaBottomSheet.currentState.toggleSheet();
            });
          }
        },
      );
    } else {
      return Future.value(null);
    }
  }

  Marker _createCurrentLocationMarker(Position currentLocation) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('current-location');

    return Marker(
      markerId: markerId,
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      icon: BitmapDescriptor.fromBytes(_carMarkerIcon),
      //rotation: currentLocation.heading,
      anchor: const Offset(0.5, 0.5),
    );
  }

  List<Marker> _createSearchRouteMarkers(RouteModel bestRoute) {
    List<Marker> markerList = List();

    final MarkerId destinationMarkerId = MarkerId('search-route-destination');
    markerList.add(
      Marker(
        markerId: destinationMarkerId,
        position: LatLng(bestRoute.destination.latitude, bestRoute.destination.longitude),
        icon: BitmapDescriptor.fromBytes(_destinationMarkerIconLarge),
        infoWindow: InfoWindow(
          title: bestRoute.destination.name,
          snippet: bestRoute.destination.formattedAddress,
        ),
      ),
    );

    final MarkerId originMarkerId = MarkerId('search-route-origin');
    markerList.add(
      Marker(
        markerId: originMarkerId,
        position: LatLng(bestRoute.origin.latitude, bestRoute.origin.longitude),
        icon: BitmapDescriptor.fromBytes(_originMarkerIconLarge),
        infoWindow: InfoWindow(
          title: bestRoute.origin.name,
          snippet: bestRoute.origin.formattedAddress,
        ),
      ),
    );

    /*final MarkerId entranceMarkerId = MarkerId('search-route-entrance');
    markerList.add(
      Marker(
        markerId: entranceMarkerId,
        position: LatLng(
          bestRoute.gateInCostTollList[0].gateIn.latitude,
          bestRoute.gateInCostTollList[0].gateIn.longitude,
        ),
        //icon: BitmapDescriptor.fromBytes(_originMarkerIconLarge),
        infoWindow: InfoWindow(
          title: bestRoute.gateInCostTollList[0].gateIn.name,
          snippet: bestRoute.gateInCostTollList[0].gateIn.name,
        ),
      ),
    );

    final MarkerId exitMarkerId = MarkerId('search-route-exit');
    markerList.add(
      Marker(
        markerId: exitMarkerId,
        position: LatLng(
          bestRoute.gateInCostTollList[0].costToll.latitude,
          bestRoute.gateInCostTollList[0].costToll.longitude,
        ),
        //icon: BitmapDescriptor.fromBytes(_originMarkerIconLarge),
        infoWindow: InfoWindow(
          title: bestRoute.gateInCostTollList[0].costToll.name,
          snippet: bestRoute.gateInCostTollList[0].costToll.name,
        ),
      ),
    );*/

    return markerList;
  }

  Future<Set<Marker>> _createSearchRouteFutureMarkerSet(RouteModel bestRoute) async {
    GateInCostTollModel gateInCostToll = bestRoute.gateInCostTollList[0];

    // สร้าง marker ของ part toll list
    Set<Marker> markerSet = Set();
    for (MarkerModel markerModel in gateInCostToll.costToll.partTollMarkerList) {
      Marker marker = await _createFutureMarker(markerModel);
      markerSet.add(marker);
    }

    // สร้าง marker ของ gate in
    Marker marker = await _createFutureMarker(gateInCostToll.gateIn.marker);
    markerSet.add(marker);

    /*List<MarkerModel> gateInMarkerList = _routeBloc.markerList
        .where((marker) => (marker.latitude == gateInCostToll.gateIn.latitude &&
            marker.longitude == gateInCostToll.gateIn.longitude))
        .toList();

    assert(gateInMarkerList.isNotEmpty);

    for (MarkerModel markerModel in gateInMarkerList) {
      Marker marker = await _createFutureMarker(markerModel);
      markerSet.add(marker);
    }*/

    // สร้าง marker ของ cost toll
    if (gateInCostToll.costToll.marker != null) {
      Marker marker = await _createFutureMarker(gateInCostToll.costToll.marker);
      markerSet.add(marker);
    } else {
      List<CategoryModel> filteredCategoryList =
          _routeBloc.categoryList.where((category) => category.code == CategoryType.EXIT).toList();
      BitmapDescriptor markerIcon = await filteredCategoryList[0].getNetworkIcon();

      Marker marker = Marker(
        markerId: MarkerId("route-search-destination"),
        position: LatLng(gateInCostToll.costToll.latitude, gateInCostToll.costToll.longitude),
        icon: markerIcon,
        alpha: 1.0,
        infoWindow: (true)
            ? InfoWindow(
                title: gateInCostToll.costToll.name,
                snippet: gateInCostToll.costToll.routeName,
              )
            : InfoWindow.noText,
        onTap: () {},
      );
      markerSet.add(marker);
    }

    /*List<MarkerModel> costTollMarkerList = _routeBloc.markerList
        .where((marker) => (marker.latitude == gateInCostToll.costToll.latitude &&
            marker.longitude == gateInCostToll.costToll.longitude))
        .toList();
    if (costTollMarkerList.isEmpty) {
      List<CategoryModel> filteredCategoryList =
          _routeBloc.categoryList.where((category) => category.code == CategoryType.EXIT).toList();
      BitmapDescriptor markerIcon = await filteredCategoryList[0].getNetworkIcon();

      Marker marker = Marker(
        markerId: MarkerId("route-search-destination"),
        position: LatLng(gateInCostToll.costToll.latitude, gateInCostToll.costToll.longitude),
        icon: markerIcon,
        alpha: 1.0,
        infoWindow: (true)
            ? InfoWindow(
                title: gateInCostToll.costToll.name,
                snippet: gateInCostToll.costToll.routeName,
              )
            : InfoWindow.noText,
        onTap: () {},
      );
      markerSet.add(marker);
    } else {
      Marker marker = await _createFutureMarker(costTollMarkerList[0]);
      markerSet.add(marker);
    }*/

    return markerSet;
  }

  void _setupCustomMarker() async {
    _originMarkerIcon = await getBytesFromAsset(
      'assets/images/route/ic_marker_origin-xxhdpi.png',
      getPlatformSize(Constants.RouteScreen.MARKER_ICON_WIDTH_SMALL).round(),
    );
    _originMarkerIconLarge = await getBytesFromAsset(
      'assets/images/route/ic_marker_origin-xxhdpi.png',
      getPlatformSize(Constants.RouteScreen.MARKER_ICON_WIDTH_LARGE).round(),
    );
    _destinationMarkerIcon = await getBytesFromAsset(
      'assets/images/route/ic_marker_destination-xxhdpi.png',
      getPlatformSize(Constants.RouteScreen.MARKER_ICON_WIDTH_SMALL).round(),
    );
    _destinationMarkerIconLarge = await getBytesFromAsset(
      'assets/images/route/ic_marker_destination-xxhdpi.png',
      getPlatformSize(Constants.RouteScreen.MARKER_ICON_WIDTH_LARGE).round(),
    );
    _carMarkerIcon = await getBytesFromAsset(
      'assets/images/map_markers/ic_marker_car-w60.png',
      getPlatformSize(Constants.RouteScreen.MARKER_ICON_WIDTH_CAR).round(),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void _selectGateInMarker(BuildContext context, GateInModel selectedGateIn) {
    context.bloc<RouteBloc>().add(GateInSelected(selectedGateIn: selectedGateIn));
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _setupCustomMarker();

    List<MarkerModel> markerList = context.bloc<AppBloc>().markerList;
    List<CategoryModel> categoryList = context.bloc<AppBloc>().categoryList;
    _routeBloc = RouteBloc(context, markerList: markerList, categoryList: categoryList);
    //return routeBloc;
  }

  void initFindRoute(RouteModel route) {
    _routeBloc.add(ShowSearchResultRoute(bestRoute: route));
  }

  void _handleClickClose() {
    _routeBloc.add(ListGateIn());
  }

  void _setupLocationUpdate(Function positionChangeListener) {
    const LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    );

    Stream<Position> positionStream;
    try {
      positionStream = Geolocator().getPositionStream(locationOptions);
      if (positionStream != null) {
        _positionStreamSubscription = positionStream.listen((Position position) {
          positionChangeListener(position);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _afterLayout(_) {
    final RenderBox mainContainerRenderBox = _keyGoogleMaps.currentContext.findRenderObject();
    setState(() {
      //_googleMapsTop = mainContainerRenderBox.localToGlobal(Offset.zero).dy;
      _googleMapsHeight = mainContainerRenderBox.size.height;
    });
  }

  @override
  void dispose() {
    _stopLocationTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RouteBloc>(
          create: (context) {
            return _routeBloc..add(ListGateIn());
          },
        ),
        /*BlocProvider<FindRouteBloc>(
          create: (context) {
            return FindRouteBloc();
          }
        ),*/
      ],
      child: BlocListener<RouteBloc, RouteState>(
        listener: (context, state) {
          LanguageModel language = Provider.of<LanguageModel>(context, listen: false);

          final List<GateInModel> gateInList = state.gateInList ?? List();
          final List<CostTollModel> costTollList = state.costTollList ?? List();
          final GateInModel selectedGateIn = state.selectedGateIn;
          final googleRoute = state.googleRoute;
          final Position currentLocation = state.currentLocation;

          final Set<Polyline> polyLineSet = <Polyline>{};
          Polyline polyline;
          if (googleRoute != null) {
            polyline = createRoutePolyline(googleRoute['overview_polyline']['points']);
            polyLineSet.add(polyline);
          }

          if (state is FetchGateInSuccess) {
            setState(() {
              _entranceLabel = FROM_ENTRANCE;
              _exitLabel = TO_EXIT;
            });
            _stopLocationTracking();
            //Scaffold.of(context).hideCurrentSnackBar();
            final snackBar = SnackBar(
              content: Text(
                LocaleText.selectEntrance().ofLanguage(language.lang),
                style: getTextStyle(language.lang, color: Colors.white),
              ),
              backgroundColor: Constants.BottomSheet.DARK_BACKGROUND_COLOR,
            );
            Scaffold.of(context).showSnackBar(snackBar);

            // pan/zoom map ให้ครอบคลุม bound ของ gateIn ทั้งหมด
            new Future.delayed(Duration(milliseconds: 1000), () async {
              List<LatLng> gateInLatLngList =
                  gateInList.map((gateIn) => LatLng(gateIn.latitude, gateIn.longitude)).toList();
              LatLngBounds latLngBounds = boundsFromLatLngList(gateInLatLngList);
              final GoogleMapController controller = await _googleMapController.future;
              controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 110));
            });
          }

          if (state is FetchCostTollSuccess) {
            _stopLocationTracking();
            //Scaffold.of(context).hideCurrentSnackBar();

            final snackBar = SnackBar(
              content: Text(
                LocaleText.selectExit().ofLanguage(language.lang),
                style: getTextStyle(language.lang, color: Colors.white),
              ),
              backgroundColor: Constants.BottomSheet.DARK_BACKGROUND_COLOR,
            );
            Scaffold.of(context).showSnackBar(snackBar);

            // pan/zoom map ให้ครอบคลุม bound ของ costToll ทั้งหมด & selectedGateIn
            new Future.delayed(Duration(milliseconds: 1000), () async {
              List<LatLng> costTollLatLngList = costTollList
                  .map((costToll) => LatLng(costToll.latitude, costToll.longitude))
                  .toList();
              costTollLatLngList.add(LatLng(selectedGateIn.latitude, selectedGateIn.longitude));
              LatLngBounds latLngBounds = boundsFromLatLngList(costTollLatLngList);
              final GoogleMapController controller = await _googleMapController.future;
              controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 110));
            });
          }

          if (state is FetchDirectionsSuccess) {
            _stopLocationTracking();

            // pan/zoom map ให้ครอบคลุม bound ของ directions polyline
            new Future.delayed(Duration(milliseconds: 1000), () async {
              LatLngBounds latLngBounds = boundsFromLatLngList(polyline.points);
              final GoogleMapController controller = await _googleMapController.future;
              controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 110));
            });
          }

          if (state is LocationTrackingUpdated) {
            //if (currentLocation.speed * 3.6 > SPEED_THRESHOLD_TO_TRACK_LOCATION) {
            final CameraPosition position = CameraPosition(
              target: LatLng(currentLocation.latitude, currentLocation.longitude),
              //zoom: _mapZoomLevel ?? 15,
              zoom: LOCATION_TRACKING_ZOOM,
              bearing: state.currentLocation.heading,
              tilt: LOCATION_TRACKING_TILT,
            );
            _moveMapToPosition(context, position);
            //}
          }

          if ((state is LocationTrackingUpdated && state.notification != null) ||
              (state is ShowSearchLocationTrackingUpdated && state.notification != null)) {
            AlertModel notification = state.notification;

            Future.delayed(Duration.zero, () {
              alert(context, notification.title, notification.message);
            });
          }

          /* **************************************
             *************** SEARCH ***************
             ************************************** */
          if (state is ShowSearchResultRouteState &&
              !(state is ShowSearchLocationTrackingUpdated)) {
            setState(() {
              _entranceLabel = ORIGIN;
              _exitLabel = DESTINATION;
            });
            _stopLocationTracking(); // STOP NAVIGATION

            Polyline polyline = createRoutePolyline(
                state.bestRoute.gateInCostTollList[0].googleRoute['overview_polyline']['points']);

            new Future.delayed(Duration(milliseconds: 1000), () async {
              final GoogleMapController controller = await _googleMapController.future;

              List<LatLng> latLngList = List();
              latLngList.add(
                LatLng(state.bestRoute.origin.latitude, state.bestRoute.origin.longitude),
              );
              latLngList.add(
                LatLng(state.bestRoute.gateInCostTollList[0].gateIn.latitude,
                    state.bestRoute.gateInCostTollList[0].gateIn.longitude),
              );
              LatLngBounds latLngBounds = boundsFromLatLngList(latLngList);
              controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 110));

              new Future.delayed(Duration(milliseconds: 1500), () async {
                List<LatLng> latLngList = List();
                latLngList.add(
                  LatLng(
                      state.bestRoute.destination.latitude, state.bestRoute.destination.longitude),
                );
                latLngList.add(
                  LatLng(state.bestRoute.gateInCostTollList[0].costToll.latitude,
                      state.bestRoute.gateInCostTollList[0].costToll.longitude),
                );
                LatLngBounds latLngBounds = boundsFromLatLngList(latLngList);
                controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 110));

                new Future.delayed(Duration(milliseconds: 1500), () async {
                  LatLngBounds latLngBounds = boundsFromLatLngList(polyline.points);
                  controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 110));
                });
              });
            });
          }

          if (state is ShowSearchLocationTrackingUpdated) {
            //if (currentLocation.speed * 3.6 > SPEED_THRESHOLD_TO_TRACK_LOCATION) {
            final Position currentLocation = state.currentLocation;
            final CameraPosition position = CameraPosition(
              target: LatLng(currentLocation.latitude, currentLocation.longitude),
              //zoom: _mapZoomLevel ?? 15,
              zoom: LOCATION_TRACKING_ZOOM,
              bearing: state.currentLocation.heading,
              tilt: LOCATION_TRACKING_TILT,
            );
            _moveMapToPosition(context, position);
            //}
          }
        },
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

                  List<GateInModel> filteredGateInList = gateInList.where((GateInModel gateIn) {
                    return selectedGateIn == null ? true : gateIn.selected;
                  }).toList();
                  Set<Marker> gateInMarkerSet = filteredGateInList.map((GateInModel gateIn) {
                    return _createGateInMarker(context, gateIn, selectedCostToll != null);
                  }).toSet();

                  List<CostTollModel> filteredCostTollList =
                      costTollList.where((CostTollModel costToll) {
                    return selectedCostToll == null ? true : costToll.selected;
                  }).toList();
                  Set<Marker> costTollMarkerSet =
                      filteredCostTollList.map((CostTollModel costToll) {
                    return _createCostTollMarker(context, costToll, selectedCostToll != null);
                  }).toSet();

                  Future<Set<Marker>> futureLabelMarkerSet = _createLabelMarkerSet(
                      context, filteredGateInList, filteredCostTollList, selectedCostToll != null);

                  /*Set<Marker> partTollSet = Set();
                  if (selectedCostToll != null) {
                    partTollSet = selectedCostToll.partTollMarkerList
                        .map((partToll) => _createPartTollMarker(partToll))
                        .toSet();
                  }*/

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

                  /* **************************************
                     *************** SEARCH ***************
                     ************************************** */
                  Set<Marker> searchRouteMarkerSet = Set();
                  if (state is ShowSearchResultRouteState) {
                    searchRouteMarkerSet.addAll(_createSearchRouteMarkers(state.bestRoute));
                    polyline = createRoutePolyline(state.bestRoute.gateInCostTollList[0]
                        .googleRoute['overview_polyline']['points']);
                    polyLineSet.add(polyline);
                  }

                  return FutureBuilder(
                    future: (state is ShowSearchResultRouteState)
                        ? (_createSearchRouteFutureMarkerSet(state.bestRoute))
                        : (_createPartTollFutureMarkerSet(selectedCostToll != null
                            ? selectedCostToll.partTollMarkerList
                            : List())),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return FutureBuilder(
                        future: futureLabelMarkerSet,
                        builder: (BuildContext context, AsyncSnapshot labelSnapshot) {
                          return GoogleMap(
                            key: _keyGoogleMaps,
                            padding: EdgeInsets.only(
                              right: getPlatformSize(15.0),
                            ),
                            mapType: MapType.normal,
                            initialCameraPosition: INITIAL_POSITION,
                            myLocationEnabled: _myLocationEnabled,
                            myLocationButtonEnabled: false,
                            trafficEnabled: false,
                            mapToolbarEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              _googleMapController.complete(controller);
                              //_moveMapToCurrentPosition(context);
                            },
                            onCameraMove: _handleCameraMove,
                            markers: gateInMarkerSet
                                .union(costTollMarkerSet)
                                .union(snapshot.hasData ? snapshot.data : Set())
                                .union(currentLocationSet)
                                .union(searchRouteMarkerSet)
                                .union(labelSnapshot.hasData ? labelSnapshot.data : Set()),
                            polylines: polyLineSet,
                          );
                        },
                      );
                    },
                  );
                },
              ),

              // ช่องเลือกทางเข้า/ทางออก
              Positioned(
                top: getPlatformSize(-28.0),
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.only(
                    left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                    right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                  ),
                  child: Container(
                    height: getPlatformSize(Platform.isAndroid ? 115.0 : 118.0),
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
                        right: getPlatformSize(0.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: getPlatformSize(19.5),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  image: AssetImage(
                                      'assets/images/route/ic_marker_origin-xxxhdpi.png'),
                                  width: getPlatformSize(16.0),
                                  height: getPlatformSize(16.0 * 28.42 / 21.13),
                                ),
                                Container(
                                  width: 0.0,
                                  height: getPlatformSize(26.0),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                // ข้อความ Pickup Location
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: getPlatformSize(6.0),
                                    top: getPlatformSize(2.0),
                                  ),
                                  child: Text(
                                    _entranceLabel,
                                    style: getTextStyle(
                                      LanguageName.english,
                                      color: Color(0xFFB2B2B2),
                                      sizeEn: Constants.Font.SMALLEST_SIZE_EN,
                                      sizeTh: Constants.Font.SMALLEST_SIZE_TH,
                                    ),
                                  ),
                                ),

                                // dropdown เลือกต้นทาง
                                BlocBuilder<RouteBloc, RouteState>(
                                  builder: (context, state) {
                                    final gateInList = state.gateInList ?? List();
                                    final selectedGateIn = state.selectedGateIn;

                                    bool isSearchMode = (state is ShowSearchResultRouteState);

                                    return (state is FetchGateInInitial)
                                        ? Consumer<LanguageModel>(
                                            builder: (context, language, child) {
                                            return Padding(
                                              padding: EdgeInsets.all(getPlatformSize(4.0)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: getPlatformSize(14.0),
                                                    height: getPlatformSize(14.0),
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: getPlatformSize(3.0),
                                                    ),
                                                  ),
                                                  Text(
                                                    '.',
                                                    style: getTextStyle(
                                                      language.lang,
                                                      color: Colors.transparent,
                                                      heightTh: 0.8 / 0.9,
                                                      heightEn: 1.15 / 0.9,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          })
                                        : DropdownButton<GateInModel>(
                                            value: selectedGateIn,
                                            hint: Consumer<LanguageModel>(
                                              builder: (context, language, child) {
                                                return Container(
                                                  padding: EdgeInsets.only(
                                                    left: getPlatformSize(6.0),
                                                  ),
                                                  child: Text(
                                                    isSearchMode
                                                        ? (state as ShowSearchResultRouteState)
                                                            .bestRoute
                                                            .origin
                                                            .name
                                                        : LocaleText.selectEntrance()
                                                            .ofLanguage(language.lang),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: getTextStyle(
                                                      language.lang,
                                                      color:
                                                          isSearchMode ? null : Color(0xFFB2B2B2),
                                                      heightTh: 0.8 / 0.9,
                                                      heightEn: 1.15 / 0.9,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            icon: isSearchMode
                                                ? SizedBox.shrink()
                                                : Image(
                                                    image: AssetImage(
                                                        'assets/images/route/ic_down_arrow.png'),
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
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: getTextStyle(
                                                          language.lang,
                                                          heightTh: 0.8 / 0.9,
                                                          heightEn: 1.15 / 0.9,
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
                                                        top: getPlatformSize(4.0),
                                                        bottom: getPlatformSize(4.0),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            gateIn.routeName.trim(),
                                                            style: getTextStyle(
                                                              language.lang,
                                                              color: Color(0xFFB2B2B2),
                                                              sizeTh:
                                                                  Constants.Font.SMALLER_SIZE_TH,
                                                              sizeEn:
                                                                  Constants.Font.SMALLER_SIZE_EN,
                                                            ),
                                                          ),
                                                          Text(
                                                            gateIn.toString().trim(),
                                                            style: getTextStyle(
                                                              language.lang,
                                                              heightTh: 0.8 / 0.9,
                                                              heightEn: 1.15 / 0.9,
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
                                    _exitLabel,
                                    style: getTextStyle(
                                      LanguageName.english,
                                      color: Color(0xFFB2B2B2),
                                      sizeEn: Constants.Font.SMALLEST_SIZE_EN,
                                      sizeTh: Constants.Font.SMALLEST_SIZE_TH,
                                    ),
                                  ),
                                ),

                                // dropdown เลือกปลายทาง
                                BlocBuilder<RouteBloc, RouteState>(builder: (context, state) {
                                  final costTollList = state.costTollList ?? List();
                                  final selectedCostToll = state.selectedCostToll;

                                  bool isSearchMode = (state is ShowSearchResultRouteState);

                                  return (state is FetchCostTollInitial)
                                      ? Consumer<LanguageModel>(
                                          builder: (context, language, child) {
                                          return Padding(
                                            padding: EdgeInsets.all(getPlatformSize(4.0)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: getPlatformSize(14.0),
                                                  height: getPlatformSize(14.0),
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: getPlatformSize(3.0),
                                                  ),
                                                ),
                                                Text(
                                                  '.',
                                                  style: getTextStyle(
                                                    language.lang,
                                                    color: Colors.transparent,
                                                    heightTh: 0.8 / 0.9,
                                                    heightEn: 1.15 / 0.9,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                      : DropdownButton<CostTollModel>(
                                          value: selectedCostToll,
                                          hint: Consumer<LanguageModel>(
                                            builder: (context, language, child) {
                                              return Container(
                                                padding: EdgeInsets.only(
                                                  left: getPlatformSize(6.0),
                                                ),
                                                child: Text(
                                                  isSearchMode
                                                      ? (state as ShowSearchResultRouteState)
                                                          .bestRoute
                                                          .destination
                                                          .name
                                                      : ((state is FetchGateInInitial) ||
                                                              (state is FetchGateInSuccess) ||
                                                              (state is FetchGateInFailure)
                                                          ? ' '
                                                          : LocaleText.selectExit()
                                                              .ofLanguage(language.lang)),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: getTextStyle(
                                                    language.lang,
                                                    color: isSearchMode ? null : Color(0xFFB2B2B2),
                                                    heightTh: 0.8 / 0.9,
                                                    heightEn: 1.15 / 0.9,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          icon: isSearchMode
                                              ? SizedBox.shrink()
                                              : Image(
                                                  image: AssetImage(
                                                      'assets/images/route/ic_down_arrow.png'),
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
                                            return costTollList
                                                .map<Widget>((CostTollModel costToll) {
                                              return Consumer<LanguageModel>(
                                                builder: (context, language, child) {
                                                  return Container(
                                                    padding: EdgeInsets.only(
                                                      left: getPlatformSize(6.0),
                                                    ),
                                                    child: Text(
                                                      costToll.toString(),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: getTextStyle(
                                                        language.lang,
                                                        heightTh: 0.8 / 0.9,
                                                        heightEn: 1.15 / 0.9,
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
                                                      top: getPlatformSize(4.0),
                                                      bottom: getPlatformSize(4.0),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(
                                                          costToll.routeName,
                                                          style: getTextStyle(
                                                            language.lang,
                                                            color: Color(0xFFB2B2B2),
                                                            sizeTh: getPlatformSize(
                                                                Constants.Font.SMALLER_SIZE_TH),
                                                            sizeEn: getPlatformSize(
                                                                Constants.Font.SMALLER_SIZE_EN),
                                                          ),
                                                        ),
                                                        Text(
                                                          costToll.toString().trim(),
                                                          style: getTextStyle(
                                                            language.lang,
                                                            heightTh: 0.8 / 0.9,
                                                            heightEn: 1.15 / 0.9,
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
                          BlocBuilder<RouteBloc, RouteState>(
                            builder: (context, state) {
                              bool showCloseButton = (state is ShowSearchResultRouteState) ||
                                  state.googleRoute != null;

                              return showCloseButton
                                  ? Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: _handleClickClose,
                                        borderRadius: BorderRadius.all(Radius.circular(21.0)),
                                        child: Container(
                                          width: getPlatformSize(42.0),
                                          height: getPlatformSize(42.0),
                                          //padding: EdgeInsets.all(getPlatformSize(15.0)),
                                          child: Center(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/home/ic_close_search.png'),
                                              width: getPlatformSize(24.0),
                                              height: getPlatformSize(24.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(width: getPlatformSize(19.0));
                            },
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
                      // search
                      MapToolItem(
                        icon: Icon(
                          Icons.search,
                          size: getPlatformSize(21.0),
                          color: Color(0xFF454F63),
                        ),
                        imageWidth: getPlatformSize(21.0),
                        imageHeight: getPlatformSize(21.0),
                        marginTop: getPlatformSize(10.0),
                        isChecked: false,
                        showProgress: false,
                        onClick: () => _handleClickSearch(context),
                      ),

                      // show/hide label
                      MapToolItem(
                        icon: Icon(
                          Icons.label_outline,
                          size: getPlatformSize(20.0),
                        ),
                        imageWidth: getPlatformSize(21.0),
                        imageHeight: getPlatformSize(21.0),
                        marginTop: getPlatformSize(10.0),
                        isChecked: _labelVisible,
                        showProgress: false,
                        onClick: () {
                          setState(() {
                            _labelVisible = !_labelVisible;
                          });
                        },
                      ),

                      // current location
                      MapToolItem(
                        image: AssetImage('assets/images/map_tools/ic_map_tool_location.png'),
                        imageWidth: getPlatformSize(21.0),
                        imageHeight: getPlatformSize(21.0),
                        marginTop: getPlatformSize(10.0),
                        isChecked: false,
                        showProgress: false,
                        onClick: () => _handleClickMyLocation(context),
                      ),
                    ],
                  ),
                ),
              ),

              // ปุ่ม start/stop navigation
              BlocBuilder<RouteBloc, RouteState>(
                builder: (context, state) {
                  bool visible = false;
                  if (state is ShowSearchResultRouteState ||
                      state is FetchDirectionsSuccess ||
                      state is LocationTrackingUpdated) {
                    visible = true;
                  }

                  return !visible
                      ? SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(
                            right: getPlatformSize(16.0),
                            bottom: getPlatformSize(
                                Constants.BottomSheet.HEIGHT_ROUTE_COLLAPSED + 16.0),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                              onPressed: () {
                                if (state is LocationTrackingUpdated) {
                                  context.bloc<RouteBloc>().add(StopLocationTracking());
                                } else if (state is FetchDirectionsSuccess) {
                                  // get current location จะได้แสดง marker รูปรถบน maps ทันที ไม่ต้องรอ location update
                                  try {
                                    getCurrentLocation().then((Position position) {
                                      context
                                          .bloc<RouteBloc>()
                                          .add(DoLocationTracking(currentLocation: position));
                                    });
                                  } catch (e) {
                                    print(e);
                                  }

                                  if (_positionStreamSubscription == null) {
                                    _setupLocationUpdate((Position position) {
                                      print("////////////////////////////////////////////");
                                      print("/////// ENTRANCE/EXIT LOCATION UPDATE //////");
                                      print(
                                          "Current location: ${position.latitude}, ${position.longitude}");
                                      print("////////////////////////////////////////////");
                                      context
                                          .bloc<RouteBloc>()
                                          .add(DoLocationTracking(currentLocation: position));
                                    });
                                    _positionStreamSubscription.pause();
                                  }
                                  if (_positionStreamSubscription.isPaused) {
                                    _positionStreamSubscription.resume();
                                  }
                                }

                                if (state is ShowSearchLocationTrackingUpdated) {
                                  context
                                      .bloc<RouteBloc>()
                                      .add(ShowSearchResultRoute(bestRoute: state.bestRoute));
                                } else if (state is ShowSearchResultRouteState) {
                                  // get current location จะได้แสดง marker รูปรถบน maps ทันที ไม่ต้องรอ location update
                                  try {
                                    getCurrentLocation().then((Position position) {
                                      context.bloc<RouteBloc>().add(
                                          UpdateCurrentLocationSearch(currentLocation: position));
                                    });
                                  } catch (e) {
                                    print(e);
                                  }

                                  if (_positionStreamSubscription == null) {
                                    _setupLocationUpdate((Position position) {
                                      print("////////////////////////////////////////////");
                                      print("////////// SEARCH LOCATION UPDATE //////////");
                                      print(
                                          "Current location: ${position.latitude}, ${position.longitude}");
                                      print("////////////////////////////////////////////");
                                      context.bloc<RouteBloc>().add(
                                          UpdateCurrentLocationSearch(currentLocation: position));
                                    });
                                    _positionStreamSubscription.pause();
                                  }
                                  if (_positionStreamSubscription.isPaused) {
                                    _positionStreamSubscription.resume();
                                  }
                                }
                              },
                              child: Icon(
                                state is ShowSearchLocationTrackingUpdated ||
                                        state is LocationTrackingUpdated
                                    ? Icons.stop
                                    : Icons.navigation,
                                color: Colors.white,
                              ),
                              backgroundColor: Constants.App.PRIMARY_COLOR,
                            ),
                          ),
                        );
                },
              ),

              BlocBuilder<RouteBloc, RouteState>(
                builder: (context, state) {
                  if (state is ShowSearchResultRouteState) {
                    print("PLACE ID: ${state.bestRoute.destination.placeId}");

                    return RouteBottomSheet(
                      collapsePosition: _googleMapsHeight -
                          getPlatformSize(Constants.BottomSheet.HEIGHT_ROUTE_COLLAPSED),
                      expandPosition: _googleMapsHeight -
                          getPlatformSize(Constants.BottomSheet.HEIGHT_ROUTE_EXPANDED),
                      gateIn: state.bestRoute.gateInCostTollList[0].gateIn,
                      costToll: state.bestRoute.gateInCostTollList[0].costToll,
                      googleRoute: state.bestRoute.gateInCostTollList[0].googleRoute,
                      destination: state.bestRoute.destination,
                      departureTimestamp: state.bestRoute.departureTime,
                      showArrivalTime: true,
                      onClickTimePeriodOption: this._handleClickTimePeriodOptionInBottomSheet,
                    );
                  } else {
                    final GateInModel selectedGateIn = state.selectedGateIn;
                    final CostTollModel selectedCostToll = state.selectedCostToll;

                    return selectedCostToll == null || state is FetchDirectionsFailure
                        ? SizedBox.shrink()
                        : RouteBottomSheet(
                            collapsePosition: _googleMapsHeight -
                                getPlatformSize(Constants.BottomSheet.HEIGHT_ROUTE_COLLAPSED),
                            expandPosition: _googleMapsHeight -
                                getPlatformSize(Constants.BottomSheet.HEIGHT_ROUTE_EXPANDED),
                            gateIn: selectedGateIn,
                            costToll: selectedCostToll,
                            googleRoute: state.googleRoute,
                            departureTimestamp: 0,
                            showArrivalTime: false,
                          );
                  }
                },
              ),

              TollPlazaBottomSheet(
                key: _keyTollPlazaBottomSheet,
                collapsePosition: _googleMapsHeight,
                expandPosition: getPlatformSize(100.0),
                tollPlazaModel: _tollPlaza,
              ),

              // dialog เลือกช่วงเวลา
              if (_timePeriodDialogVisible)
                Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: getPlatformSize(60.0)),
                        child: Wrap(
                          children: <Widget>[
                            OptionsDialog(
                              title: LocaleText.departureTime().ofLanguage(language.lang),
                              optionList: _timePeriodList.asMap().entries.map((entry) {
                                return OptionModel(
                                  text: entry.value == 0
                                      ? LocaleText.now().ofLanguage(language.lang)
                                      : sprintf(
                                          LocaleText.minutesLater().ofLanguage(language.lang),
                                          [entry.value],
                                        ),
                                  //searchServiceText.ofLanguage(language.lang),
                                  onClick: () => _handleClickTimePeriodOption(entry.value),
                                  bulletColor:
                                      Constants.BottomSheet.TAB_STRIP_COLOR_LIST[entry.key % 4],
                                );
                              }).toList(),
                              itemPadding: EdgeInsets.symmetric(
                                vertical: getPlatformSize(12.0),
                                horizontal: getPlatformSize(20.0),
                              ),
                              onClickClose: () => setState(() {
                                _timePeriodDialogVisible = false;
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              BlocBuilder<RouteBloc, RouteState>(
                builder: (context, state) {
                  bool isFailed = state is FetchGateInFailure ||
                      state is FetchCostTollFailure ||
                      state is FetchDirectionsFailure;
                  return isFailed
                      ? Center(
                          child: Consumer<LanguageModel>(
                            builder: (context, language, child) {
                              return ErrorView(
                                //title: LocaleText.error().ofLanguage(language.lang),
                                title: LocaleText.errorPleaseTryAgain().ofLanguage(language.lang),
                                text: state.errorMessage,
                                buttonText: LocaleText.tryAgain().ofLanguage(language.lang),
                                withBackground: true,
                                onClick: () {
                                  if (state is FetchGateInFailure) {
                                    _routeBloc.add(ListGateIn());
                                  } else if (state is FetchCostTollFailure) {
                                    _routeBloc
                                        .add(GateInSelected(selectedGateIn: state.selectedGateIn));
                                  } else if (state is FetchDirectionsFailure) {
                                    _routeBloc.add(
                                        CostTollSelected(selectedCostToll: state.selectedCostToll));
                                  }
                                },
                              );
                            },
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),

              BlocBuilder<RouteBloc, RouteState>(
                builder: (context, state) {
                  bool showProgress = _isLoading ||
                      state is FetchGateInInitial ||
                      state is FetchCostTollInitial ||
                      state is FetchDirectionsInitial;
                  return showProgress ? Center(child: MyProgressIndicator()) : SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
