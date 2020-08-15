import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/bottom_sheet/home_bottom_sheet.dart';
import 'package:exattraffic/screens/bottom_sheet/layer_bottom_sheet.dart';
import 'package:exattraffic/app/app_bloc.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/screens/home/bloc/bloc.dart';
import 'package:exattraffic/screens/schematic_maps/schematic_maps.dart';
import 'package:exattraffic/components/my_progress_indicator.dart';
import 'package:exattraffic/screens/bottom_sheet/toll_plaza_bottom_sheet.dart';
import 'package:exattraffic/models/marker_categories/toll_plaza_model.dart';

class Home extends StatefulWidget {
  final Function hideSearchOptions;

  const Home(Key key, this.hideSearchOptions) : super(key: key);

  @override
  MyHomeState createState() => MyHomeState();
}

//enum MapTool {schematicMaps, aroundMe, dataLayer, currentLocation}

class MyHomeState extends State<Home> {
  final GlobalKey _keyMainContainer = GlobalKey();
  final GlobalKey _keyGoogleMaps = GlobalKey();
  final GlobalKey<TollPlazaBottomSheetState> _keyTollPlazaBottomSheet = GlobalKey();

  final Completer<GoogleMapController> _googleMapController = Completer();

  //final Uuid uuid = Uuid();
  Timer _timer;

  //double _mainContainerTop = 0; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  double _mainContainerHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()

  static const CameraPosition INITIAL_POSITION = CameraPosition(
    target: LatLng(13.7563, 100.5018), // Bangkok
    zoom: 8,
  );

  Future<void> _moveToCurrentPosition(BuildContext context) async {
    final Position position =
        await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final CameraPosition currentPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
  }

  /*void _addMarker(LatLng latLng) {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId((new DateTime.now().millisecondsSinceEpoch).toString());

    // creating a new marker
    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      //infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      //onTap: () {},
    );

    setState(() {
      // adding a new marker to map
      _markers[markerId] = marker;
    });
  }*/

  /*Future<void> _sendToVisualization(LatLng latLng) async {
    Map<String, String> params = {
      'lat': latLng.latitude.toString(),
      'lng': latLng.longitude.toString(),
      'type': 'bg',
    };
    var uri = Uri.http('163.47.9.26', '/location', params);
    var response = await http.get(uri);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    */ /*var url = 'http://163.47.9.26/location?lat=20&lng=20';
    var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');*/ /*
  }*/

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    /*_timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        _markers.removeWhere((key, value) =>
            new DateTime.now().millisecondsSinceEpoch - int.parse(key.value) > 60000);
      });
    });*/

    super.initState();
  }

  _afterLayout(_) {
    final RenderBox mainContainerRenderBox = _keyMainContainer.currentContext.findRenderObject();
    setState(() {
      //_mainContainerTop = mainContainerRenderBox.localToGlobal(Offset.zero).dy;
      _mainContainerHeight = mainContainerRenderBox.size.height;
    });
  }

  Future<Set<Marker>> _createMarkerSet(BuildContext context, List<MarkerModel> markerList) async {
    Set<Marker> markerSet = Set();
    for (MarkerModel markerModel in markerList) {
      Marker marker = await _createMarker(context, markerModel);
      markerSet.add(marker);
      /*marker = await _createTextMarker(context, markerModel);
      markerSet.add(marker);*/
    }
    return markerSet;

    /*return markerList.map((MarkerModel marker) async {
      return await _createMarker(context, marker);
    }).toSet();*/
  }

  Future<Marker> _createMarker(BuildContext context, MarkerModel marker) async {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('marker-${marker.id.toString()}');

    BitmapDescriptor markerIcon = await marker.category.getNetworkIcon();
    //BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(await getBytesFromCanvas(300, 100));

    return Marker(
      markerId: markerId,
      position: LatLng(marker.latitude, marker.longitude),
      //icon: marker.category.markerIconBitmap, // local icon
      icon: markerIcon,
      // network icon
      alpha: 1.0,
      infoWindow: (true)
          ? InfoWindow(
              title: marker.name + (kReleaseMode ? "" : " [${marker.category.code}-${marker.id}]"),
              snippet: marker.category.name,
            )
          : InfoWindow.noText,
      onTap: () => _handleClickMarker(context, marker),
    );
  }

  Future<Marker> _createTextMarker(BuildContext context, MarkerModel marker) async {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('marker-label-${marker.id.toString()}');

    BitmapDescriptor markerIcon =
        BitmapDescriptor.fromBytes(await getBytesFromCanvas(marker.name, 500, 60));

    return Marker(
      markerId: markerId,
      position: LatLng(marker.latitude, marker.longitude),
      //icon: marker.category.markerIconBitmap, // local icon
      icon: markerIcon,
      anchor: const Offset(0.5, 0.0),
      // network icon
      alpha: 1.0,
      infoWindow: (false)
          ? InfoWindow(
              title: marker.name + (kReleaseMode ? "" : " [${marker.category.code}-${marker.id}]"),
              snippet: marker.category.name,
            )
          : InfoWindow.noText,
      onTap: null,
    );
  }

  Future<Uint8List> getBytesFromCanvas(String label, int width, int height) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.transparent;
    final Radius radius = Radius.circular(20.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint,
    );
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: label,
      style: getTextStyle(
        0,
        sizeTh: 50.0,
        sizeEn: 50.0,
        isBold: true,
      ),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset((width * 0.5) - painter.width * 0.5, (height * 0.5) - painter.height * 0.5),
    );
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  void _handleClickMarker(BuildContext context, MarkerModel marker) {
    widget.hideSearchOptions();

    // ใส่ delay เพื่อรอให้ marker pan ไปอยู่กลาง map
    Future.delayed(Duration(milliseconds: 500), () {
      marker.showDetailsScreen(context);
    });
  }

  void goHome() {
    if (_homeBlocContext != null) {
      _homeBlocContext.bloc<HomeBloc>().add(ClickMapTool(mapTool: MapTool.none));
    }
  }

  void _handleClickMapTool(BuildContext context, MapTool mapTool) {
    widget.hideSearchOptions();

    switch (mapTool) {
      case MapTool.schematicMaps:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SchematicMaps()),
        );
        break;
      case MapTool.aroundMe:
        context.bloc<HomeBloc>().add(ClickMapTool(mapTool: MapTool.aroundMe));
        break;
      case MapTool.layer:
        context.bloc<HomeBloc>().add(ClickMapTool(mapTool: MapTool.layer));
        break;
      case MapTool.currentLocation:
        _moveToCurrentPosition(context);
        break;
      case MapTool.none:
        break;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  BuildContext _homeBlocContext;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) {
            List<MarkerModel> markerList = context.bloc<AppBloc>().markerList;
            List<CategoryModel> categoryList = context.bloc<AppBloc>().categoryList;
            return HomeBloc(markerList: markerList, categoryList: categoryList);
          },
        ),
        BlocProvider<MarkerBloc>(
          create: (context) {
            return MarkerBloc();
          },
        ),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previousState, state) {
          return true;
        },
        builder: (context, state) {
          print('--------------------------------------- HOME BUILDER');

          _homeBlocContext = context;

          MapTool selectedMapTool = state.selectedMapTool;
          List<MarkerModel> markerList = state.markerList;
          //List<CategoryModel> categoryList = state.categoryList;
          //Map<int, bool> categorySelectedMap = state.categorySelectedMap;

          /*Set<Marker> markerSet = markerList.map((MarkerModel marker) {
            return _createMarker(context, marker);
          }).toSet();*/

          if ((state is MapToolChange && state.selectedMapTool != MapTool.none) ||
              state is MarkerLayerChange) {
            /*new Future.delayed(Duration(milliseconds: 1000), () async {
              List<LatLng> markerLatLngList =
                  markerList.map((marker) => LatLng(marker.latitude, marker.longitude)).toList();
              LatLngBounds latLngBounds = boundsFromLatLngList(markerLatLngList);
              final GoogleMapController controller = await _googleMapController.future;
              controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 50));
            });*/
          } else if (state is MapToolChange && state.selectedMapTool == MapTool.none) {
            _moveToCurrentPosition(context);
          }

          return Container(
            key: _keyMainContainer,
            /*decoration: BoxDecoration(
              border: Border.all(
                color: Colors.redAccent,
                width: 2.0,
              ),
            ),*/
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                FutureBuilder(
                  future: _createMarkerSet(context, markerList),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if ((state is MapToolChange && state.selectedMapTool != MapTool.none) ||
                          state is MarkerLayerChange) {
                        new Future.delayed(Duration(milliseconds: 1000), () async {
                          List<LatLng> markerLatLngList = markerList
                              .map((marker) => LatLng(marker.latitude, marker.longitude))
                              .toList();
                          LatLngBounds latLngBounds = boundsFromLatLngList(markerLatLngList);
                          final GoogleMapController controller = await _googleMapController.future;
                          controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 50));
                        });
                      }
                    }

                    if (true /*snapshot.hasData*/) {
                      return GoogleMap(
                        key: _keyGoogleMaps,
                        padding: EdgeInsets.only(
                          //bottom: (state.selectedMapTool == MapTool.layer) || (state.selectedMapTool == MapTool.aroundMe) ? getPlatformSize(100.0) : 0.0,
                          top: getPlatformSize(20.0),
                          bottom: getPlatformSize(140.0),
                          left: getPlatformSize(0.0),
                          right: getPlatformSize(50.0),
                        ),
                        mapType: MapType.normal,
                        initialCameraPosition: INITIAL_POSITION,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        trafficEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _googleMapController.complete(controller);
                          _moveToCurrentPosition(context);
                        },
                        onTap: (LatLng latLng) {
                          widget.hideSearchOptions();
                          /*_addMarker(latLng);
                              _sendToVisualization(latLng);*/
                        },
                        markers: snapshot.hasData ? snapshot.data : null,
                      );
                    }
                  },
                ),

                // Map tools
                Container(
                  padding: EdgeInsets.only(
                    top: getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
                    left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                    right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget>[
                        MapToolItem(
                          icon: AssetImage('assets/images/map_tools/ic_map_tool_schematic.png'),
                          iconWidth: getPlatformSize(16.4),
                          iconHeight: getPlatformSize(18.3),
                          marginTop: getPlatformSize(0.0),
                          isChecked: false,
                          showProgress: false,
                          onClick: () => _handleClickMapTool(context, MapTool.schematicMaps),
                        ),

                        // around me
                        MapToolItem(
                          icon: AssetImage('assets/images/map_tools/ic_map_tool_nearby.png'),
                          iconWidth: getPlatformSize(26.6),
                          iconHeight: getPlatformSize(21.6),
                          marginTop: getPlatformSize(10.0),
                          isChecked: selectedMapTool == MapTool.aroundMe,
                          showProgress: state.showProgress,
                          onClick: () => _handleClickMapTool(context, MapTool.aroundMe),
                        ),

                        // layer
                        MapToolItem(
                          icon: AssetImage('assets/images/map_tools/ic_map_tool_layer.png'),
                          iconWidth: getPlatformSize(15.5),
                          iconHeight: getPlatformSize(16.5),
                          marginTop: getPlatformSize(10.0),
                          isChecked: selectedMapTool == MapTool.layer,
                          showProgress: false,
                          onClick: () => _handleClickMapTool(context, MapTool.layer),
                        ),

                        // current location
                        MapToolItem(
                          icon: AssetImage('assets/images/map_tools/ic_map_tool_location.png'),
                          iconWidth: getPlatformSize(21.0),
                          iconHeight: getPlatformSize(21.0),
                          marginTop: getPlatformSize(10.0),
                          isChecked: false,
                          showProgress: false,
                          onClick: () => _handleClickMapTool(context, MapTool.currentLocation),
                        ),
                      ],
                    ),
                  ),
                ),

                // bottom sheet
                Visibility(
                  visible: true,
                  child: IndexedStack(
                    index: selectedMapTool == MapTool.none ? 0 : 1,
                    children: <Widget>[
                      HomeBottomSheet(
                        collapsePosition: _mainContainerHeight -
                            getPlatformSize(Constants.BottomSheet.HEIGHT_INITIAL),
                        expandPosition: getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
                      ),
                      LayerBottomSheet(
                        collapsePosition: _mainContainerHeight -
                            getPlatformSize(Constants.BottomSheet.HEIGHT_LAYER),
                        // expandPosition ไม่ได้ใช้ เพราะ layer bottom sheet ยืดไม่ได้
                        expandPosition: getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
                      ),
                    ],
                  ),
                ),

                BlocListener<MarkerBloc, MarkerState>(
                  listener: (context, state) {
                    if (state is ShowTollPlazaBottomSheet) {
                      _keyTollPlazaBottomSheet.currentState.toggleSheet();
                    }
                  },
                  child: BlocBuilder<MarkerBloc, MarkerState>(
                    builder: (context, state) {
                      TollPlazaModel tollPlaza;

                      if (state is ShowTollPlazaBottomSheet) {
                        tollPlaza = state.tollPlaza;
                      }
                      return TollPlazaBottomSheet(
                        key: _keyTollPlazaBottomSheet,
                        collapsePosition: _mainContainerHeight,
                        expandPosition: getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
                        tollPlazaModel: tollPlaza,
                      );
                    },
                  ),
                ),

                /*BlocBuilder<MarkerBloc, MarkerState>(
                  builder: (context, state) {
                    if (state is ShowTollPlazaBottomSheet) {
                      _keyTollPlazaBottomSheet.currentState.toggleSheet();
                    }

                    return TollPlazaBottomSheet(
                      key: _keyTollPlazaBottomSheet,
                      collapsePosition: _mainContainerHeight + getPlatformSize(1.0),
                      expandPosition: getPlatformSize(MAP_TOOL_TOP_POSITION),
                    );
                  },
                ),*/

                Visibility(
                  visible: state.showProgress,
                  child: Center(
                    child: MyProgressIndicator(),
                  ),
                ),

                /*Visibility(
                  visible: state.showProgress,
                  child: Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }
}

class MapToolItem extends StatelessWidget {
  MapToolItem({
    @required this.icon,
    @required this.iconWidth,
    @required this.iconHeight,
    @required this.marginTop,
    @required this.isChecked,
    @required this.showProgress,
    @required this.onClick,
  });

  final AssetImage icon;
  final double iconWidth;
  final double iconHeight;
  final double marginTop;
  final bool isChecked;
  final bool showProgress;
  final Function onClick;

  static const double SIZE = 45.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getPlatformSize(SIZE),
      height: getPlatformSize(SIZE),
      margin: EdgeInsets.only(
        top: marginTop,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: isChecked ? Constants.App.PRIMARY_COLOR : Colors.transparent,
          width: isChecked ? 2 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x22777777),
            blurRadius: getPlatformSize(10.0),
            spreadRadius: getPlatformSize(5.0),
            offset: Offset(
              getPlatformSize(2.0), // move right
              getPlatformSize(2.0), // move down
            ),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (onClick != null && !showProgress) {
              onClick();
            }
          },
          //highlightColor: Constants.App.PRIMARY_COLOR,
          borderRadius: BorderRadius.all(
            Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
          ),
          child: Center(
            child: showProgress
                ? SizedBox(
                    width: getPlatformSize(18.0),
                    height: getPlatformSize(18.0),
                    child: CircularProgressIndicator(
                      strokeWidth: getPlatformSize(3),
                    ),
                  )
                : Image(
                    image: icon,
                    width: iconWidth,
                    height: iconHeight,
                  ),
          ),
        ),
      ),
    );
  }
}
