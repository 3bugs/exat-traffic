import 'dart:async';
import 'package:exattraffic/screens/home/components/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/models/toll_plaza.dart';
import 'package:exattraffic/models/express_way.dart';
import 'package:exattraffic/screens/home/components/drawer.dart';
import 'package:exattraffic/screens/home/components/nav_bar.dart';
import 'package:exattraffic/constants.dart' as Constants;

//https://medium.com/flutter-community/implement-real-time-location-updates-on-google-maps-in-flutter-235c8a09173e
//https://medium.com/@CORDEA/implement-backdrop-with-flutter-73b4c61b1357
//https://codewithandrea.com/articles/2018-09-13-bottom-bar-navigation-with-fab/
//https://medium.com/flutter/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return wrapSystemUiOverlayStyle(child: HomeMain());
  }
}

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final GlobalKey _keyGoogleMaps = GlobalKey();

  final String formattedDate = new DateFormat.yMMMMd().format(new DateTime.now()).toUpperCase();

  static const List<Color> BG_GRADIENT_COLORS = [
    Constants.App.HEADER_GRADIENT_COLOR_START,
    Constants.App.HEADER_GRADIENT_COLOR_END,
  ];
  static const List<double> BG_GRADIENT_STOPS = [0.0, 1.0];

  List<Widget> _fragments = [
    //todo:
  ];

  final Completer<GoogleMapController> _googleMapController = Completer();

  static const CameraPosition INITIAL_POSITION = CameraPosition(
    target: LatLng(13.7563, 100.5018), // Bangkok
    zoom: 8,
  );

  bool _showDate = true;
  double _googleMapsHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()

  initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    final RenderBox googleMapsContainerRenderBox = _keyGoogleMaps.currentContext.findRenderObject();
    final Size googleMapsContainerSize = googleMapsContainerRenderBox.size;
    setState(() {
      _googleMapsHeight = googleMapsContainerSize.height;
    });
  }

  void _handleClickTab(int index) {
    //print(index.toString());
  }

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

  @override
  Widget build(BuildContext context) {
    /*
      Galaxy J7 Prime (5.5" @ 1920x1080) = 414 x 736 logical pixel @ 3.0 pixel ratio
      iPhone 7 Plus (5.5" @ 1920x1080) = 360 x 640 logical pixel @ 3.0 pixel ratio
    */
    final MediaQueryData queryData = MediaQuery.of(context);
    print('Device width: ${queryData.size.width}, ' +
        'height: ${queryData.size.height}, ' +
        'pixel ratio: ${queryData.devicePixelRatio}');

    return Scaffold(
      appBar: null,
      /*AppBar(
        title: Text('Home'),
      )*/
      drawer: Drawer(
        child: MyDrawer(),
      ),
      bottomNavigationBar: MyNavBar(
        onClickTab: _handleClickTab,
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
      ),*/
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: BG_GRADIENT_COLORS,
            stops: BG_GRADIENT_STOPS,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                    left: Constants.App.HORIZONTAL_MARGIN,
                    right: Constants.App.HORIZONTAL_MARGIN,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: getPlatformSize(0.0),
                            right: getPlatformSize(3.0),
                            top: getPlatformSize(16.0),
                            bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.all(
                                  Radius.circular(getPlatformSize(0.0)),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: getPlatformSize(3.0),
                                    right: getPlatformSize(3.0),
                                    top: getPlatformSize(2.0),
                                    bottom: getPlatformSize(3.0),
                                  ),
                                  child: Image(
                                    image: AssetImage('assets/images/home/ic_menu.png'),
                                    width: getPlatformSize(22.0),
                                    height: getPlatformSize(20.0),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.all(
                                  Radius.circular(getPlatformSize(18.0)),
                                ),
                                child: Image(
                                  image: AssetImage('assets/images/home/ic_phone_circle.png'),
                                  width: getPlatformSize(36.0),
                                  height: getPlatformSize(36.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: getPlatformSize(3.0),
                        ),
                        child: Text(
                          'Home',
                          style: TextStyle(
                            fontSize: getPlatformSize(42.0),
                            color: Colors.white,
                            height: 0.95,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _showDate,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: getPlatformSize(5.0),
                          ),
                          child: Text(
                            formattedDate, //'APRIL 23, 2020',
                            style: TextStyle(
                              fontSize: getPlatformSize(16.0),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    // maps
                    Container(
                      margin: EdgeInsets.only(top: Constants.HomeScreen.MAPS_VERTICAL_POSITION),
                      decoration: BoxDecoration(
                        //color: Color(0xFFF6F6F4),
                        color: Colors.white70,
                      ),
                      child: GoogleMap(
                        key: _keyGoogleMaps,
                        mapType: MapType.normal,
                        initialCameraPosition: INITIAL_POSITION,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _googleMapController.complete(controller);
                          _moveToCurrentPosition(context);
                        },
                      ),
                    ),
                    // search box
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      top: 0.0,
                      left: 0.0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Constants.App.HORIZONTAL_MARGIN,
                          right: Constants.App.HORIZONTAL_MARGIN,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                top: Constants.HomeScreen.SEARCH_BOX_VERTICAL_POSITION,
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
                                  Radius.circular(Constants.App.BOX_BORDER_RADIUS),
                                ),
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
                                        child: TextField(
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(
                                              top: getPlatformSize(4.0),
                                              bottom: getPlatformSize(8.0),
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'ค้นหา',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
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
                            Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                children: <Widget>[
                                  MapToolItem(
                                    icon: AssetImage(
                                        'assets/images/map_tools/ic_map_tool_location.png'),
                                    iconWidth: getPlatformSize(21.0),
                                    iconHeight: getPlatformSize(21.0),
                                    marginTop: getPlatformSize(16.0),
                                  ),
                                  MapToolItem(
                                    icon: AssetImage(
                                        'assets/images/map_tools/ic_map_tool_nearby.png'),
                                    iconWidth: getPlatformSize(26.6),
                                    iconHeight: getPlatformSize(21.6),
                                    marginTop: getPlatformSize(10.0),
                                  ),
                                  MapToolItem(
                                    icon: AssetImage(
                                        'assets/images/map_tools/ic_map_tool_schematic.png'),
                                    iconWidth: getPlatformSize(16.4),
                                    iconHeight: getPlatformSize(18.3),
                                    marginTop: getPlatformSize(10.0),
                                  ),
                                  MapToolItem(
                                    icon:
                                        AssetImage('assets/images/map_tools/ic_map_tool_layer.png'),
                                    iconWidth: getPlatformSize(15.5),
                                    iconHeight: getPlatformSize(16.5),
                                    marginTop: getPlatformSize(10.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // bottom sheet
                    MyBottomSheet(
                      collapsePosition: Constants.HomeScreen.MAPS_VERTICAL_POSITION +
                          _googleMapsHeight -
                          Constants.BottomSheet.HEIGHT_INITIAL,
                      expandPosition: Constants.HomeScreen.SEARCH_BOX_VERTICAL_POSITION - 1,
                    ),
                    // เงาบนแถบ bottom nav
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: 0.0,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x22777777),
                              blurRadius: getPlatformSize(20.0),
                              spreadRadius: getPlatformSize(10.0),
                              offset: Offset(
                                getPlatformSize(0.0), // move right
                                getPlatformSize(-2.0), // move down
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
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
  });

  final AssetImage icon;
  final double iconWidth;
  final double iconHeight;
  final double marginTop;

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
            Radius.circular(Constants.App.BOX_BORDER_RADIUS),
          )),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          //highlightColor: Constants.App.PRIMARY_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(Constants.App.BOX_BORDER_RADIUS)),
          child: Center(
            child: Image(
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