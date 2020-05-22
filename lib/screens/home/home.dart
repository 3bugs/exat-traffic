import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

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
  final GlobalKey _keyGoogleMaps = GlobalKey();
  final Completer<GoogleMapController> _googleMapController = Completer();

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
        children: <Widget>[
          GoogleMap(
            key: _keyGoogleMaps,
            mapType: MapType.normal,
            initialCameraPosition: INITIAL_POSITION,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController.complete(controller);
              _moveToCurrentPosition(context);
            },
          ),
          Container(
            padding: EdgeInsets.only(
              top: getPlatformSize(42.0),
              left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
              right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  MapToolItem(
                    icon: AssetImage(
                        'assets/images/map_tools/ic_map_tool_location.png'),
                    iconWidth: getPlatformSize(21.0),
                    iconHeight: getPlatformSize(21.0),
                    marginTop: getPlatformSize(0.0),
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
          ),
        ],
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
            Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
          )),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          //highlightColor: Constants.App.PRIMARY_COLOR,
          borderRadius:
              BorderRadius.all(Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS))),
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
