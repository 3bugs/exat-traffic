import 'dart:async';
import 'package:exattraffic/models/toll_plaza.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exattraffic/etc/utils.dart';
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

class _HomeMainState extends State<HomeMain> with TickerProviderStateMixin {
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

  bool _bottomSheetExpanded = false;
  AnimationController _controller;
  bool _showDate = true;
  double _googleMapsHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()

  final List<ExpressWay> _expressWayList = <ExpressWay>[
    ExpressWay(
      name: 'ทางพิเศษศรีรัช',
      image: AssetImage('assets/images/home/express_way_srirach.jpg'),
    ),
    ExpressWay(
      name: 'ทางพิเศษฉลองรัช',
      image: AssetImage('assets/images/home/express_way_chalong.jpg'),
    ),
    ExpressWay(
      name: 'ทางพิเศษบูรพาวิถี',
      image: AssetImage('assets/images/home/express_way_burapa.jpg'),
    ),
    ExpressWay(
      name: 'ทางพิเศษเฉลิมมหานคร',
      image: AssetImage('assets/images/home/express_way_chalerm.jpg'),
    ),
    ExpressWay(
      name: 'ทางพิเศษอุดรรัถยา',
      image: AssetImage('assets/images/home/express_way_udorn.jpg'),
    ),
    ExpressWay(
      name: 'ทางพิเศษสายบางนา',
      image: AssetImage('assets/images/home/express_way_bangna.jpg'),
    ),
    ExpressWay(
      name: 'ทางพิเศษกาญจนาภิเษก',
      image: AssetImage('assets/images/home/express_way_kanchana.jpg'),
    ),
  ];

  final List<TollPlaza> _tollPlazaList = <TollPlaza>[
    TollPlaza(
      name: 'ทางลงลาดพร้าว',
      image: AssetImage('assets/images/home/toll_plaza_dummy_1.jpg'),
      isEntrance: false,
      isExit: true,
    ),
    TollPlaza(
      name: 'รามอินทรา',
      image: AssetImage('assets/images/home/toll_plaza_dummy_2.jpg'),
      isEntrance: true,
      isExit: true,
    ),
    TollPlaza(
      name: 'สุขาภิบาล 5',
      image: AssetImage('assets/images/home/toll_plaza_dummy_1.jpg'),
      isEntrance: true,
      isExit: false,
    ),
    TollPlaza(
      name: 'โยธิน',
      image: AssetImage('assets/images/home/toll_plaza_dummy_2.jpg'),
      isEntrance: true,
      isExit: true,
    ),
  ];

  initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _bottomSheetExpanded = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _bottomSheetExpanded = false;
        });
      }
    });
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

  void _handleClickUpDownSheet(BuildContext context) {
    if (_bottomSheetExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    // toggle _bottomSheetExpanded ใน AnimationController's AnimationStatusListener
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
                    /*PositionedTransition(
                      rect: RelativeRectTween(
                        begin: RelativeRect.fromLTRB(
                          0,
                          Constants.HomeScreen.MAPS_VERTICAL_POSITION +
                              _googleMapsHeight -
                              Constants.BottomSheet.HEIGHT_INITIAL,
                          0,
                          0,
                        ),
                        end: RelativeRect.fromLTRB(
                          0,
                          Constants.HomeScreen.SEARCH_BOX_VERTICAL_POSITION - 1,
                          0,
                          0,
                        ),
                      ).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeInOutExpo,
                        ),
                      ),
                      child: ClipRRect(
                        //padding: EdgeInsets.all(getPlatformSize(20.0)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(getPlatformSize(13.0)),
                          topRight: Radius.circular(getPlatformSize(13.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: getPlatformSize(8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Color(0xFF665EFF),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Color(0xFF5773FF),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Color(0xFF3497FD),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Color(0xFF3ACCE1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(
                                  left: getPlatformSize(0.0),
                                  right: getPlatformSize(0.0),
                                  top: getPlatformSize(6.0),
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
                                          width: getPlatformSize(56.0), // 42 + 14
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              'ทางพิเศษ',
                                              style: TextStyle(
                                                fontSize: getPlatformSize(16.0),
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF585858),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              _handleClickUpDownSheet(context);
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
                                                  image: _bottomSheetExpanded
                                                      ? AssetImage(
                                                          'assets/images/home/ic_sheet_down.png')
                                                      : AssetImage(
                                                          'assets/images/home/ic_sheet_up.png'),
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
                                      child: Column(
                                        children: <Widget>[
                                          // list ทางพิเศษ (text)
                                          Container(
                                            height: getPlatformSize(44.0),
                                            child: ListView.separated(
                                              itemCount: _expressWayList.length,
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (BuildContext context, int index) {
                                                return ExpressWayTextView(
                                                  expressWay: _expressWayList[index],
                                                  isFirstItem: index == 0,
                                                  isLastItem: index == _expressWayList.length - 1,
                                                );
                                              },
                                              separatorBuilder: (BuildContext context, int index) {
                                                return SizedBox(
                                                  width: getPlatformSize(0.0),
                                                );
                                              },
                                            ),
                                          ),
                                          // list ด่านทางขึ้น-ลง
                                          Expanded(
                                            child: Container(
                                              child: ListView.separated(
                                                itemCount: _tollPlazaList.length,
                                                scrollDirection: Axis.vertical,
                                                physics: BouncingScrollPhysics(),
                                                itemBuilder: (BuildContext context, int index) {
                                                  return TollPlazaView(
                                                    tollPlaza: _tollPlazaList[index],
                                                    isFirstItem: index == 0,
                                                    isLastItem: index == _tollPlazaList.length - 1,
                                                  );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context, int index) {
                                                  return SizedBox(
                                                    width: getPlatformSize(0.0),
                                                  );
                                                },
                                              ),
                                            ),
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
                      ),
                    ),*/
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

class ExpressWayImageView extends StatelessWidget {
  ExpressWayImageView({
    @required this.expressWay,
    @required this.isFirstItem,
    @required this.isLastItem,
  });

  final ExpressWay expressWay;
  final bool isFirstItem;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.all(
          Radius.circular(getPlatformSize(5.0)),
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: getPlatformSize(isFirstItem ? 20.0 : 10.0),
            right: getPlatformSize(isLastItem ? 20.0 : 10.0),
            top: getPlatformSize(2.0),
            bottom: getPlatformSize(2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(Constants.App.BOX_BORDER_RADIUS),
                ),
                child: Image(
                  image: expressWay.image,
                  width: getPlatformSize(122.0),
                  height: getPlatformSize(78.0),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: getPlatformSize(6.0),
                ),
                child: Text(
                  expressWay.name,
                  style: TextStyle(
                    fontSize: getPlatformSize(14.0),
                    color: Color(0xFF585858),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpressWayTextView extends StatelessWidget {
  ExpressWayTextView({
    @required this.expressWay,
    @required this.isFirstItem,
    @required this.isLastItem,
  });

  final ExpressWay expressWay;
  final bool isFirstItem;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: getPlatformSize(isFirstItem ? 14.0 : 7.0),
            right: getPlatformSize(isLastItem ? 14.0 : 7.0),
            top: getPlatformSize(2.0),
            bottom: getPlatformSize(2.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.all(
                Radius.circular(getPlatformSize(6.0)),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getPlatformSize(8.0),
                  vertical: getPlatformSize(5.0),
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: getPlatformSize(1.0),
                    color: Color(0xFF707070),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                child: Center(
                  child: Text(
                    expressWay.name,
                    style: TextStyle(
                      fontSize: getPlatformSize(14.0),
                      color: Color(0xFF585858),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TollPlazaView extends StatelessWidget {
  TollPlazaView({
    @required this.tollPlaza,
    @required this.isFirstItem,
    @required this.isLastItem,
  });

  final TollPlaza tollPlaza;
  final bool isFirstItem;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: getPlatformSize(14.0),
            right: getPlatformSize(14.0),
            top: getPlatformSize(isFirstItem ? 7.0 : 7.0),
            bottom: getPlatformSize(isLastItem ? 21.0 : 7.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x11808080),
                  blurRadius: getPlatformSize(6.0),
                  spreadRadius: getPlatformSize(2.0),
                  offset: Offset(
                    getPlatformSize(2.0), // move right
                    getPlatformSize(2.0), // move down
                  ),
                ),
              ],
              color: Color(0xFFF4F4F4),
              border: Border.all(
                width: getPlatformSize(1.0),
                color: Color(0xFFE8E8E8),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(Constants.App.BOX_BORDER_RADIUS),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.all(
                  Radius.circular(Constants.App.BOX_BORDER_RADIUS),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    left: getPlatformSize(10.0),
                    right: getPlatformSize(10.0),
                    top: getPlatformSize(10.0),
                    bottom: getPlatformSize(10.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: getPlatformSize(4.0),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: getPlatformSize(4.0),
                          right: getPlatformSize(2.0),
                          top: getPlatformSize(0.0),
                          bottom: getPlatformSize(4.0),
                        ),
                        child: Image(
                          image: tollPlaza.isEntrance
                              ? AssetImage('assets/images/home/ic_arrow_green_up.png')
                              : AssetImage('assets/images/home/ic_arrow_red_up.png'),
                          width: getPlatformSize(15.6),
                          height: getPlatformSize(26.7),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: getPlatformSize(2.0),
                          right: getPlatformSize(4.0),
                          top: getPlatformSize(4.0),
                          bottom: getPlatformSize(0.0),
                        ),
                        child: Image(
                          image: tollPlaza.isExit
                              ? AssetImage('assets/images/home/ic_arrow_green_down.png')
                              : AssetImage('assets/images/home/ic_arrow_red_down.png'),
                          width: getPlatformSize(15.6),
                          height: getPlatformSize(26.7),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: getPlatformSize(30.0),
                          ),
                          child: Text(
                            tollPlaza.name,
                            style: TextStyle(
                              fontSize: getPlatformSize(16.0),
                              color: Color(0xFF717171),
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(getPlatformSize(9.0)),
                        ),
                        child: Image(
                          image: tollPlaza.image,
                          width: getPlatformSize(100.0),
                          height: getPlatformSize(65.0),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
