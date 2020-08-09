import 'dart:async';

import 'package:exattraffic/models/marker_categories/toll_plaza_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

//import 'package:exattraffic/screens/home/map_test.dart';
import 'package:exattraffic/screens/bottom_sheet/home_bottom_sheet.dart';
import 'package:exattraffic/screens/bottom_sheet/layer_bottom_sheet.dart';
import 'package:exattraffic/app/app_bloc.dart';
import 'package:exattraffic/models/category_model.dart';
import 'package:exattraffic/models/marker_model.dart';
import 'package:exattraffic/screens/home/bloc/bloc.dart';
import 'package:exattraffic/screens/schematic_maps/schematic_maps.dart';
import 'package:exattraffic/models/marker_categories/cctv_model.dart';
import 'package:exattraffic/screens/marker_details/cctv_details.dart';
import 'package:exattraffic/components/my_progress_indicator.dart';
import 'package:exattraffic/screens/bottom_sheet/toll_plaza_bottom_sheet.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeMain();
  }
}

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final GlobalKey _keyMainContainer = GlobalKey();
  final GlobalKey _keyGoogleMaps = GlobalKey();
  final GlobalKey<TollPlazaBottomSheetState> _keyTollPlazaBottomSheet = GlobalKey();

  final Completer<GoogleMapController> _googleMapController = Completer();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  //final Uuid uuid = Uuid();
  Timer _timer;
  bool _showSearchOptions = false;
  double _mainContainerTop = 0; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  double _mainContainerHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()

  static const CameraPosition INITIAL_POSITION = CameraPosition(
    target: LatLng(13.7563, 100.5018), // Bangkok
    zoom: 8,
  );
  static const double SEARCH_BOX_TOP_POSITION = -37.0;
  static const double MAP_TOOL_TOP_POSITION = 42.0;

  List<String> _searchHintList = [
    'ค้นหา',
    'Search',
    '搜索',
  ];

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

  void _addMarker(LatLng latLng) {
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
  }

  Future<void> _sendToVisualization(LatLng latLng) async {
    Map<String, String> params = {
      'lat': latLng.latitude.toString(),
      'lng': latLng.longitude.toString(),
      'type': 'bg',
    };
    var uri = Uri.http('163.47.9.26', '/location', params);
    var response = await http.get(uri);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    /*var url = 'http://163.47.9.26/location?lat=20&lng=20';
    var response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');*/
  }

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
      _mainContainerTop = mainContainerRenderBox.localToGlobal(Offset.zero).dy;
      _mainContainerHeight = mainContainerRenderBox.size.height;
    });
  }

  Future<Set<Marker>> _createMarkerSet(BuildContext context, List<MarkerModel> markerList) async {
    Set<Marker> markerSet = Set();
    for (MarkerModel markerModel in markerList) {
      Marker marker = await _createMarker(context, markerModel);
      markerSet.add(marker);
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
      onTap: () {
        // ใส่ delay เพื่อรอให้ marker pan ไปอยู่กลาง map
        Future.delayed(Duration(milliseconds: 600), () {
          _handleClickMarker(context, marker);
        });
      },
    );
  }

  void _handleClickMarker(BuildContext context, MarkerModel marker) {
    marker.showDetailsScreen(context);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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

          MapTool selectedMapTool = state.selectedMapTool;
          List<MarkerModel> markerList = state.markerList;
          List<CategoryModel> categoryList = state.categoryList;
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
                            final GoogleMapController controller =
                                await _googleMapController.future;
                            controller
                                .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 50));
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
                            if (_showSearchOptions) {
                              setState(() {
                                _showSearchOptions = false;
                              });
                            }
                            /*_addMarker(latLng);
                              _sendToVisualization(latLng);*/
                          },
                          markers: snapshot.hasData ? snapshot.data : null,
                        );
                      }
                    }),

                // Map tools
                Container(
                  padding: EdgeInsets.only(
                    top: getPlatformSize(MAP_TOOL_TOP_POSITION),
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
                          onClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SchematicMaps()),
                            );
                          },
                        ),

                        // around me
                        MapToolItem(
                          icon: AssetImage('assets/images/map_tools/ic_map_tool_nearby.png'),
                          iconWidth: getPlatformSize(26.6),
                          iconHeight: getPlatformSize(21.6),
                          marginTop: getPlatformSize(10.0),
                          isChecked: selectedMapTool == MapTool.aroundMe,
                          showProgress: state.showProgress,
                          onClick: () {
                            context.bloc<HomeBloc>().add(ClickMapTool(mapTool: MapTool.aroundMe));

                            /*Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MapTest()),
                                );*/
                          },
                        ),

                        // layer
                        MapToolItem(
                          icon: AssetImage('assets/images/map_tools/ic_map_tool_layer.png'),
                          iconWidth: getPlatformSize(15.5),
                          iconHeight: getPlatformSize(16.5),
                          marginTop: getPlatformSize(10.0),
                          isChecked: selectedMapTool == MapTool.layer,
                          showProgress: false,
                          onClick: () {
                            context.bloc<HomeBloc>().add(ClickMapTool(mapTool: MapTool.layer));
                          },
                        ),

                        // current location
                        MapToolItem(
                          icon: AssetImage('assets/images/map_tools/ic_map_tool_location.png'),
                          iconWidth: getPlatformSize(21.0),
                          iconHeight: getPlatformSize(21.0),
                          marginTop: getPlatformSize(10.0),
                          isChecked: false,
                          showProgress: false,
                          onClick: () {
                            _moveToCurrentPosition(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // ช่อง search
                Visibility(
                  visible: true,
                  child: Positioned(
                    width: MediaQuery.of(context).size.width,
                    top: getPlatformSize(SEARCH_BOX_TOP_POSITION),
                    left: 0.0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                        right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                              top: getPlatformSize(
                                  Constants.HomeScreen.SEARCH_BOX_VERTICAL_POSITION),
                            ),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x22777777),
                                  blurRadius: getPlatformSize(10.0),
                                  spreadRadius: getPlatformSize(5.0),
                                  offset: Offset(
                                    getPlatformSize(2.0), // move right
                                    getPlatformSize(2.0), // move down
                                  ),
                                ),
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
                                  setState(() {
                                    _showSearchOptions = true;
                                  });
                                },
                                borderRadius: BorderRadius.all(
                                  Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: getPlatformSize(6.0),
                                    bottom: getPlatformSize(6.0),
                                    left: getPlatformSize(20.0),
                                    right: getPlatformSize(12.0),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image(
                                        image: AssetImage('assets/images/home/ic_search.png'),
                                        width: getPlatformSize(16.0),
                                        height: getPlatformSize(16.0),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: getPlatformSize(16.0),
                                            right: getPlatformSize(16.0),
                                          ),
                                          child: Consumer<LanguageModel>(
                                            builder: (context, language, child) {
                                              return Text(
                                                _searchHintList[language.lang],
                                                style: getTextStyle(
                                                  language.lang,
                                                  color: Constants.Font.DIM_COLOR,
                                                ),
                                              );
                                              /*return TextField(
                                                onTap: () {
                                                  setState(() {
                                                    _showSearchOptions = true;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding: EdgeInsets.only(
                                                    top: getPlatformSize(4.0),
                                                    bottom: getPlatformSize(4.0),
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: _searchHintList[language.lang],
                                                ),
                                                style: getTextStyle(language.lang),
                                              );*/
                                            },
                                          ),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            print('close search');
                                            setState(() {
                                              _showSearchOptions = false;
                                            });
                                          },
                                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                          child: Container(
                                            width: getPlatformSize(36.0),
                                            height: getPlatformSize(36.0),
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // รูปแบบการค้นหา (บริการผู้ใช้ทาง/เส้นทาง)
                Visibility(
                  visible: _showSearchOptions,
                  child: Positioned(
                    width: MediaQuery.of(context).size.width,
                    top: getPlatformSize(65.0 + SEARCH_BOX_TOP_POSITION),
                    left: 0.0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                        right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x22777777),
                              blurRadius: getPlatformSize(10.0),
                              spreadRadius: getPlatformSize(5.0),
                              offset: Offset(
                                getPlatformSize(2.0), // move right
                                getPlatformSize(2.0), // move down
                              ),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            // ค้นหาบริการผู้ใช้ทาง
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  underConstruction(context);
                                  setState(() {
                                    _showSearchOptions = false;
                                  });
                                },
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                                  topRight: Radius.circular(
                                      getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: getPlatformSize(18.0),
                                    horizontal: getPlatformSize(20.0),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: getPlatformSize(10.0),
                                        height: getPlatformSize(10.0),
                                        margin: EdgeInsets.only(
                                          right: getPlatformSize(16.0),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF3497FD),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(getPlatformSize(3.0)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Consumer<LanguageModel>(
                                          builder: (context, language, child) {
                                            return Text(
                                              'ค้นหาบริการ',
                                              style: getTextStyle(
                                                language.lang,
                                                color: Color(0xFF454F63),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // เส้นคั่น
                            Container(
                              margin: EdgeInsets.only(
                                left: getPlatformSize(20.0),
                                right: getPlatformSize(20.0),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFF4F4F4),
                                    width: getPlatformSize(1.0),
                                  ),
                                ),
                              ),
                            ),
                            // ค้นหาเส้นทาง
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  underConstruction(context);
                                  setState(() {
                                    _showSearchOptions = false;
                                  });
                                },
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                                  bottomRight: Radius.circular(
                                      getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: getPlatformSize(18.0),
                                    horizontal: getPlatformSize(20.0),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: getPlatformSize(10.0),
                                        height: getPlatformSize(10.0),
                                        margin: EdgeInsets.only(
                                          right: getPlatformSize(16.0),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF3ACCE1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(getPlatformSize(3.0)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Consumer<LanguageModel>(
                                          builder: (context, language, child) {
                                            return Text(
                                              'ค้นหาเส้นทาง',
                                              style: getTextStyle(
                                                language.lang,
                                                color: Color(0xFF454F63),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        expandPosition: getPlatformSize(MAP_TOOL_TOP_POSITION),
                      ),
                      LayerBottomSheet(
                        collapsePosition: _mainContainerHeight -
                            getPlatformSize(Constants.BottomSheet.HEIGHT_LAYER),
                        // expandPosition ไม่ได้ใช้ เพราะ layer bottom sheet ยืดไม่ได้
                        expandPosition: getPlatformSize(MAP_TOOL_TOP_POSITION),
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
                        expandPosition: getPlatformSize(MAP_TOOL_TOP_POSITION),
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
