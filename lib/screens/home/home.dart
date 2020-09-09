import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

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
import 'package:exattraffic/screens/widget/widget.dart';
import 'package:exattraffic/models/favorite_model.dart';
import 'package:exattraffic/screens/bottom_sheet/widget_bottom_sheet.dart';
import 'package:exattraffic/storage/cctv_favorite_prefs.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/screens/search/search_place_presenter.dart';
import 'package:exattraffic/services/api.dart';
import 'package:exattraffic/services/google_maps_services.dart';
import 'package:exattraffic/storage/place_favorite_prefs.dart';
import 'package:exattraffic/storage/widget_prefs.dart';
import 'package:exattraffic/models/locale_text.dart';

class Home extends StatefulWidget {
  final Function hideSearchOptions;
  final Function showBestRouteAfterSearch;

  const Home(Key key, this.hideSearchOptions, this.showBestRouteAfterSearch) : super(key: key);

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

  static const INITIAL_ZOOM = 8.0;
  static const CameraPosition INITIAL_POSITION = CameraPosition(
    target: LatLng(13.7563, 100.5018), // Bangkok
    zoom: INITIAL_ZOOM,
  );

  double _zoom = INITIAL_ZOOM;
  bool _isLoading = false;

  Future<void> _moveToCurrentPosition(BuildContext context,
      {bool showAlertIfLocationNotAvailable = false}) async {
    final Position position = await getCurrentLocationNotNull();

    if (position != null) {
      final CameraPosition currentPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
      );
      final GoogleMapController controller = await _googleMapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    } else {
      if (showAlertIfLocationNotAvailable) {
        //alert(context, Constants.App.NAME, Constants.Message.LOCATION_NOT_AVAILABLE);
        LanguageModel language = Provider.of<LanguageModel>(context, listen: false);
        showMyDialog(
          context,
          LocaleText.locationNotAvailable().ofLanguage(language.lang),
          //Constants.Message.LOCATION_NOT_AVAILABLE,
          [DialogButtonModel(text: "OK", value: DialogResult.yes)],
        );
      }
    }
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

    if (_zoom > 12) {
      for (MarkerModel marker in markerList) {
        Marker m = await _createMarker(context, marker);
        markerSet.add(m);
      }
    } else {
      Map<int, ClusterModel> clusterMap = Map();

      markerList.forEach((marker) async {
        if (marker.groupId == 0) {
          Marker m = await _createMarker(context, marker);
          markerSet.add(m);
        } else {
          if (clusterMap.containsKey(marker.groupId)) {
            ClusterModel cluster = clusterMap[marker.groupId];
            cluster.markerList.add(marker);
          } else {
            ClusterModel cluster = ClusterModel(
              id: marker.groupId,
              name: marker.groupName,
            );
            cluster.markerList.add(marker);
            clusterMap[marker.groupId] = cluster;
          }
        }
      });

      List<ClusterModel> clusterList = clusterMap.entries.map((entry) => entry.value).toList();
      print("^^^^^^^^^^^^^^^^^^^^^^^^^ CLUSTER ^^^^^^^^^^^^^^^^^^^^^^^^^");
      clusterList.forEach((cluster) {
        print("CLUSTER ID: ${cluster.id}, MARKER COUNT: ${cluster.markerList.length}, AVG LATLNG: ${cluster.getAverageLatLng()}");
        cluster.markerList.forEach((marker) {
          print("--- MARKER CATEGORY CODE: ${marker.category.code}, LAT: ${marker.latitude}, LNG: ${marker.longitude}");
        });
      });

      List<ClusterModel> oneMarkerClusterList =
          clusterList.where((cluster) => cluster.markerList.length == 1).toList();
      oneMarkerClusterList.forEach((cluster) async {
        Marker m = await _createMarker(context, cluster.markerList[0]);
        markerSet.add(m);
      });

      List<ClusterModel> manyMarkersClusterList =
          clusterList.where((cluster) => cluster.markerList.length > 1).toList();
      markerSet.addAll(await _createClusterMarkerSet(context, manyMarkersClusterList));
    }

    return markerSet;
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

  Future<Set<Marker>> _createClusterMarkerSet(
      BuildContext context, List<ClusterModel> clusterList) async {
    Set<Marker> markerSet = Set();

    for (ClusterModel cluster in clusterList) {
      Marker marker = await _createClusterMarker(context, cluster);
      markerSet.add(marker);
    }

    return markerSet;
  }

  static const int CLUSTER_ICON_SIZE = 120;

  Future<Marker> _createClusterMarker(BuildContext context, ClusterModel cluster) async {
    //String markerIdVal = uuid.v1();
    final MarkerId markerId = MarkerId('cluster-marker-${cluster.id.toString()}');

    String label = cluster.markerList.length.toString();
    BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(
        await getBytesFromCanvas(label, CLUSTER_ICON_SIZE, CLUSTER_ICON_SIZE));

    LatLng averageLatLng = cluster.getAverageLatLng();
    return Marker(
      markerId: markerId,
      position: LatLng(averageLatLng.latitude, averageLatLng.longitude),
      //icon: marker.category.markerIconBitmap, // local icon
      icon: markerIcon,
      anchor: const Offset(0.5, 0.5),
      // network icon
      alpha: 1.0,
      //infoWindow: InfoWindow.noText,
      onTap: () => _handleClickClusterMarker(context, cluster),
    );
  }

  Future<Uint8List> getBytesFromCanvas(String label, int width, int height) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    //final Paint paint = Paint()..color = Constants.App.PRIMARY_COLOR.withOpacity(0.8);
    final Paint fill = Paint()..color = Color(0xFFF98008).withOpacity(0.8);
    final Paint strokeWhite = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    //final Radius radius = Radius.circular(60.0);
    canvas.drawCircle(
        Offset(CLUSTER_ICON_SIZE / 2, CLUSTER_ICON_SIZE / 2), CLUSTER_ICON_SIZE / 2, fill);
    canvas.drawCircle(Offset(CLUSTER_ICON_SIZE / 2, CLUSTER_ICON_SIZE / 2),
        (CLUSTER_ICON_SIZE - 15) / 2, strokeWhite);
    canvas.drawCircle(Offset(CLUSTER_ICON_SIZE / 2, CLUSTER_ICON_SIZE / 2),
        (CLUSTER_ICON_SIZE - 35) / 2, strokeWhite);
    /*canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint,
    );*/
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: label,
      style: getTextStyle(
        LanguageName.thai,
        sizeTh: 60.0,
        sizeEn: 60.0,
        isBold: true,
        color: Colors.white,
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
    if (widget.hideSearchOptions != null) {
      widget.hideSearchOptions();
    }

    // ใส่ delay เพื่อรอให้ marker pan ไปอยู่กลาง map
    Future.delayed(Duration(milliseconds: 500), () {
      marker.showDetailsScreen(context);
    });
  }

  void _handleClickClusterMarker(BuildContext context, ClusterModel cluster) async {
    LatLng averageLatLng = cluster.getAverageLatLng();
    final CameraPosition currentPosition = CameraPosition(
      target: LatLng(averageLatLng.latitude, averageLatLng.longitude),
      zoom: 15,
    );
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
  }

  void goHome() {
    if (_homeBlocContext != null) {
      _homeBlocContext.bloc<HomeBloc>().add(ClickMapTool(mapTool: MapTool.none));
    }
  }

  void _handleClickMapTool(BuildContext context, MapTool mapTool) {
    if (widget.hideSearchOptions != null) {
      widget.hideSearchOptions();
    }

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
        _moveToCurrentPosition(context, showAlertIfLocationNotAvailable: true);
        break;
      case MapTool.none:
        break;
    }
  }

  void _handleCameraMove(CameraPosition cameraPosition) {
    double oldZoom = _zoom;
    double newZoom = cameraPosition.zoom;
    _zoom = cameraPosition.zoom;
    print("ZOOM LEVEL: $_zoom");
    if ((oldZoom >= 12 && newZoom < 12) || (oldZoom < 12 && newZoom >= 12)) {
      setState(() {});
    }
  }

  /*Future<List<FavoriteModel>> _getFavoriteList() async {
    List<MarkerModel> markerList = BlocProvider.of<AppBloc>(context).markerList;
    List<String> cctvIdList = await CctvFavoritePrefs().getIdList();
    List<MarkerModel> cctvList = markerList
        .where((marker) => (cctvIdList != null && cctvIdList.contains(marker.id.toString())))
        .toList();
    List<FavoriteModel> cctvFavoriteList = cctvList
        .map<FavoriteModel>((cctvMarker) => FavoriteModel(
              name: cctvMarker.name,
              description: cctvMarker.routeName ?? "กล้อง CCTV",
              //"${cctvMarker.latitude}, ${cctvMarker.longitude}",
              type: FavoriteType.cctv,
              marker: cctvMarker,
            ))
        .toList();

    List<PlaceFavoriteModel> placeList = await PlaceFavoritePrefs().getPlaceList();
    List<FavoriteModel> placeFavoriteList = placeList
        .map<FavoriteModel>((placeFavorite) => FavoriteModel(
              name: placeFavorite.placeName,
              description: "สถานที่",
              //"${cctvMarker.latitude}, ${cctvMarker.longitude}",
              type: FavoriteType.place,
              placeId: placeFavorite.placeId,
            ))
        .toList();

    return placeFavoriteList..addAll(cctvFavoriteList);
  }*/

  Future<void> _handleClickFavoriteItem(FavoriteModel favorite) async {
    switch (favorite.type) {
      case FavoriteType.cctv:
        favorite.marker.showDetailsScreen(context, callback: null);
        break;
      case FavoriteType.place:
        final GoogleMapsServices googleMapsServices = GoogleMapsServices();
        /*_presenter.setLoadingMessage("ดึงข้อมูลสถานที่");
        _presenter.loading();*/
        setState(() {
          _isLoading = true;
        });
        try {
          PlaceDetailsModel placeDetails =
              await googleMapsServices.getPlaceDetails(favorite.placeId);
          /*Position destination =
            Position(latitude: placeDetails.latitude, longitude: placeDetails.longitude);*/
          //_presenter.setLoadingMessage("หาเส้นทางที่ใช้เวลาน้อยที่สุด");
          RouteModel bestRoute = await SearchPlacePresenter.findBestRoute(context, placeDetails);

          if (bestRoute != null && widget.showBestRouteAfterSearch != null) {
            //assert(bestRoute.gateInCostTollList.isNotEmpty);
            // กลับไป _handleClickSearchOption ใน MyScaffold
            widget.showBestRouteAfterSearch(bestRoute);
          }
        } catch (error) {}
        setState(() {
          _isLoading = false;
        });
        break;
    }
  }

  Widget _getWidget(WidgetType widgetType) {
    return Consumer<WidgetPrefs>(
      builder: (context, prefs, child) {
        bool isFavoriteOn = prefs.isWidgetOn(WidgetType.favorite);
        bool isIncidentOn = prefs.isWidgetOn(WidgetType.incident);
        bool isExpressWayOn = prefs.isWidgetOn(WidgetType.expressWay);

        switch (widgetType) {
          case WidgetType.favorite:
            return isFavoriteOn
                ? Consumer<CctvFavoritePrefs>(
                    builder: (context, cctvFavoritePrefs, child) {
                      List<MarkerModel> markerList = BlocProvider.of<AppBloc>(context).markerList;
                      List<FavoriteModel> cctvFavoriteList =
                          cctvFavoritePrefs.getFavoriteList(markerList);

                      return Consumer<PlaceFavoritePrefs>(
                        builder: (context, placeFavoritePrefs, child) {
                          List<FavoriteModel> placeFavoriteList =
                              placeFavoritePrefs.getFavoriteList();

                          List<FavoriteModel> totalList = List();
                          totalList.addAll(cctvFavoriteList);
                          totalList.addAll(placeFavoriteList);

                          List<TextImageModel> dataList = totalList
                              .map<TextImageModel>((favorite) => TextImageModel(
                                    text: favorite.name,
                                    widget: favorite.type == FavoriteType.place
                                        ? Image(
                                            image: AssetImage(
                                                'assets/images/favorite/image_widget_favorite_place.png'),
                                            fit: BoxFit.cover,
                                          )
                                        : Stack(
                                            children: <Widget>[
                                              Image(
                                                image: AssetImage(
                                                    'assets/images/cctv_details/video_preview_mock.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              Center(
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/cctv_details/ic_playback.png'),
                                                  width: getPlatformSize(30.0),
                                                  height: getPlatformSize(30.0),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ))
                              .toList();

                          return WidgetBottomSheet(
                            title: "รายการโปรด",
                            dataList: dataList,
                            onClickItem: (item, index) =>
                                _handleClickFavoriteItem(totalList[index]),
                            collapsePosition: _mainContainerHeight -
                                getPlatformSize(Constants.BottomSheet.HEIGHT_WIDGET_FAVORITE) -
                                (isIncidentOn
                                    ? getPlatformSize(Constants.BottomSheet.HEIGHT_WIDGET_INCIDENT)
                                    : 0.0) -
                                (isExpressWayOn
                                    ? getPlatformSize(
                                        Constants.BottomSheet.HEIGHT_WIDGET_EXPRESS_WAY)
                                    : 0.0),
                            // expandPosition ไม่ได้ใช้ เพราะ layer bottom sheet ยืดไม่ได้
                            expandPosition:
                                getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
                          );
                        },
                      );
                    },
                  )
                : SizedBox.shrink();
            break;
          case WidgetType.incident:
            return isIncidentOn
                ? LayerBottomSheet(
                    collapsePosition: _mainContainerHeight -
                        getPlatformSize(Constants.BottomSheet.HEIGHT_WIDGET_INCIDENT) -
                        (isExpressWayOn
                            ? getPlatformSize(Constants.BottomSheet.HEIGHT_WIDGET_EXPRESS_WAY)
                            : 0.0),
                    // expandPosition ไม่ได้ใช้ เพราะ layer bottom sheet ยืดไม่ได้
                    expandPosition: getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
                  )
                : SizedBox.shrink();
            break;
          case WidgetType.expressWay:
            return isExpressWayOn
                ? HomeBottomSheet(
                    collapsePosition: _mainContainerHeight -
                        getPlatformSize(Constants.BottomSheet.HEIGHT_WIDGET_EXPRESS_WAY),
                    expandPosition: getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
                  )
                : SizedBox.shrink();
            break;
        }
        return SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
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
            return HomeBloc(context, markerList: markerList, categoryList: categoryList);
          },
        ),
        BlocProvider<MarkerBloc>(
          create: (context) {
            return MarkerBloc();
          },
        ),
      ],
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          List<MarkerModel> markerList = state.markerList;

          if ((state is MapToolChange && state.selectedMapTool != MapTool.none) ||
              state is MarkerLayerChange) {
            new Future.delayed(Duration(milliseconds: 1000), () async {
              List<LatLng> markerLatLngList =
                  markerList.map((marker) => LatLng(marker.latitude, marker.longitude)).toList();
              LatLngBounds latLngBounds = boundsFromLatLngList(markerLatLngList);
              final GoogleMapController controller = await _googleMapController.future;
              controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 50));
            });
          } else if (state is MapToolChange && state.selectedMapTool == MapTool.none) {
            _moveToCurrentPosition(context);
          }
        },
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

            /*if ((state is MapToolChange && state.selectedMapTool != MapTool.none) ||
                state is MarkerLayerChange) {
              new Future.delayed(Duration(milliseconds: 1000), () async {
                List<LatLng> markerLatLngList =
                    markerList.map((marker) => LatLng(marker.latitude, marker.longitude)).toList();
                LatLngBounds latLngBounds = boundsFromLatLngList(markerLatLngList);
                final GoogleMapController controller = await _googleMapController.future;
                controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 50));
              });
            } else if (state is MapToolChange && state.selectedMapTool == MapTool.none) {
              _moveToCurrentPosition(context);
            }*/

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
                            if (widget.hideSearchOptions != null) {
                              widget.hideSearchOptions();
                            }

                            /*_addMarker(latLng);
                                _sendToVisualization(latLng);*/
                          },
                          onCameraMove: _handleCameraMove,
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
                            image: AssetImage('assets/images/map_tools/ic_map_tool_schematic.png'),
                            imageWidth: getPlatformSize(16.4),
                            imageHeight: getPlatformSize(18.3),
                            marginTop: getPlatformSize(0.0),
                            isChecked: false,
                            showProgress: false,
                            onClick: () => _handleClickMapTool(context, MapTool.schematicMaps),
                          ),

                          // around me
                          MapToolItem(
                            image: AssetImage('assets/images/map_tools/ic_map_tool_nearby.png'),
                            imageWidth: getPlatformSize(26.6),
                            imageHeight: getPlatformSize(21.6),
                            marginTop: getPlatformSize(10.0),
                            isChecked: selectedMapTool == MapTool.aroundMe,
                            showProgress: state.showProgress,
                            onClick: () => _handleClickMapTool(context, MapTool.aroundMe),
                          ),

                          // layer
                          MapToolItem(
                            image: AssetImage('assets/images/map_tools/ic_map_tool_layer.png'),
                            imageWidth: getPlatformSize(15.5),
                            imageHeight: getPlatformSize(16.5),
                            marginTop: getPlatformSize(10.0),
                            isChecked: selectedMapTool == MapTool.layer,
                            showProgress: false,
                            onClick: () => _handleClickMapTool(context, MapTool.layer),
                          ),

                          // current location
                          MapToolItem(
                            image: AssetImage('assets/images/map_tools/ic_map_tool_location.png'),
                            imageWidth: getPlatformSize(21.0),
                            imageHeight: getPlatformSize(21.0),
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
                  /*Visibility(
                    visible: true,
                    child: IndexedStack(
                      index: selectedMapTool == MapTool.none ? 0 : 1,
                      children: <Widget>[
                        _getWidgets(),
                        LayerBottomSheet(
                          collapsePosition: _mainContainerHeight -
                              getPlatformSize(Constants.BottomSheet.HEIGHT_LAYER),
                          // expandPosition ไม่ได้ใช้ เพราะ layer bottom sheet ยืดไม่ได้
                          expandPosition: getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
                        ),
                      ],
                    ),
                  ),*/

                  Visibility(
                    visible: selectedMapTool == MapTool.none,
                    child: _getWidget(WidgetType.favorite),
                  ),
                  Visibility(
                    visible: selectedMapTool == MapTool.none,
                    child: _getWidget(WidgetType.incident),
                  ),
                  Visibility(
                    visible: selectedMapTool == MapTool.none,
                    child: _getWidget(WidgetType.expressWay),
                  ),
                  Visibility(
                    visible: selectedMapTool != MapTool.none,
                    child: LayerBottomSheet(
                      collapsePosition: _mainContainerHeight -
                          getPlatformSize(Constants.BottomSheet.HEIGHT_LAYER),
                      // expandPosition ไม่ได้ใช้ เพราะ layer bottom sheet ยืดไม่ได้
                      expandPosition: getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
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
                          expandPosition:
                              getPlatformSize(Constants.HomeScreen.MAP_TOOL_TOP_POSITION),
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
                    visible: state.showProgress || _isLoading,
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
      ),
    );
  }
}

class MapToolItem extends StatelessWidget {
  MapToolItem({
    this.image,
    this.icon,
    @required this.imageWidth,
    @required this.imageHeight,
    @required this.marginTop,
    @required this.isChecked,
    @required this.showProgress,
    @required this.onClick,
  });

  final AssetImage image;
  final Icon icon;
  final double imageWidth;
  final double imageHeight;
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
                : (this.icon != null
                    ? this.icon
                    : Image(
                        image: image,
                        width: imageWidth,
                        height: imageHeight,
                      )),
          ),
        ),
      ),
    );
  }
}
