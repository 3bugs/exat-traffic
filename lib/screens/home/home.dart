import 'dart:async';
import 'package:flutter/material.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../constants.dart' as Constants;
import 'components/drawer.dart';
import 'components/nav_bar.dart';

//https://medium.com/flutter-community/implement-real-time-location-updates-on-google-maps-in-flutter-235c8a09173e

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
  String formattedDate = new DateFormat.yMMMMd().format(new DateTime.now()).toUpperCase();

  List<Color> _bgGradientColors = const [
    Constants.App.HEADER_GRADIENT_COLOR_START,
    Constants.App.HEADER_GRADIENT_COLOR_END,
  ];
  List<double> _bgGradientStops = const [0.0, 1.0];

  List<Widget> _fragments = [
    //todo:
  ];

  Completer<GoogleMapController> _googleMapController = Completer();

  //Bangkok position
  static const CameraPosition INITIAL_POSITION = CameraPosition(
    target: LatLng(13.7563, 100.5018),
    zoom: 8,
  );

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
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _bgGradientColors,
            stops: _bgGradientStops,
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
                            left: getPlatformSize(3.0),
                            right: getPlatformSize(3.0),
                            top: getPlatformSize(16.0),
                            bottom: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/images/home/ic_menu.png'),
                              width: getPlatformSize(22.0),
                              height: getPlatformSize(20.0),
                            ),
                            Image(
                              image: AssetImage('assets/images/home/ic_phone_circle.png'),
                              width: getPlatformSize(36.0),
                              height: getPlatformSize(36.0),
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
                      Padding(
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
                    ],
                  )),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: Constants.HomeScreen.MAPS_VERTICAL_POSITION),
                      decoration: BoxDecoration(
                        //color: Color(0xFFF6F6F4),
                        color: Colors.black,
                      ),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: INITIAL_POSITION,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _googleMapController.complete(controller);
                          _moveToCurrentPosition(context);
                        },
                      ),
                      /*Center(
                        child: Text(
                          'ʕ•́ᴥ•̀ʔ\nGoogle Maps\ncoming soon.\n♡♡♡',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: getPlatformSize(40.0),
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),*/
                    ),
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
                                    )
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Constants.App.BOX_BORDER_RADIUS),
                                  )),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: getPlatformSize(10.0),
                                  bottom: getPlatformSize(10.0),
                                  left: getPlatformSize(20.0),
                                  right: getPlatformSize(16.0),
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
                                            contentPadding: EdgeInsets.symmetric(
                                              vertical: getPlatformSize(4.0),
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'ค้นหา',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Image(
                                      image: AssetImage('assets/images/home/ic_close_search.png'),
                                      width: getPlatformSize(24.0),
                                      height: getPlatformSize(24.0),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getPlatformSize(45.0),
      height: getPlatformSize(45.0),
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
      child: Center(
        child: Image(
          image: icon,
          width: iconWidth,
          height: iconHeight,
        ),
      ),
    );
  }
}
