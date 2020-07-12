import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/home/map_test.dart';

class Home extends StatelessWidget {
  Home({
    @required this.onClickMapTool,
  });

  final Function onClickMapTool;

  @override
  Widget build(BuildContext context) {
    return HomeMain(onClickMapTool: onClickMapTool);
  }
}

class HomeMain extends StatefulWidget {
  HomeMain({
    @required this.onClickMapTool,
  });

  final Function onClickMapTool;

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final GlobalKey _keyGoogleMaps = GlobalKey();
  final Completer<GoogleMapController> _googleMapController = Completer();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  //final Uuid uuid = Uuid();
  Timer _timer;
  bool _mapToolLayerChecked = false;

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
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        _markers.removeWhere((key, value) =>
            new DateTime.now().millisecondsSinceEpoch - int.parse(key.value) > 60000);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController.complete(controller);
              _moveToCurrentPosition(context);
            },
            onTap: (LatLng latLng) {
              _addMarker(latLng);
              _sendToVisualization(latLng);
            },
            markers: Set<Marker>.of(_markers.values),
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
                    icon: AssetImage('assets/images/map_tools/ic_map_tool_schematic.png'),
                    iconWidth: getPlatformSize(16.4),
                    iconHeight: getPlatformSize(18.3),
                    marginTop: getPlatformSize(0.0),
                    isChecked: false,
                    onClick: () {},
                  ),
                  MapToolItem(
                    icon: AssetImage('assets/images/map_tools/ic_map_tool_nearby.png'),
                    iconWidth: getPlatformSize(26.6),
                    iconHeight: getPlatformSize(21.6),
                    marginTop: getPlatformSize(10.0),
                    isChecked: false,
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapTest()),
                      );
                    },
                  ),
                  MapToolItem(
                    icon: AssetImage('assets/images/map_tools/ic_map_tool_layer.png'),
                    iconWidth: getPlatformSize(15.5),
                    iconHeight: getPlatformSize(16.5),
                    marginTop: getPlatformSize(10.0),
                    isChecked: _mapToolLayerChecked,
                    onClick: () {
                      setState(() {
                        _mapToolLayerChecked = !_mapToolLayerChecked;
                      });
                      widget.onClickMapTool(2, _mapToolLayerChecked);
                    },
                  ),
                  MapToolItem(
                    icon: AssetImage('assets/images/map_tools/ic_map_tool_location.png'),
                    iconWidth: getPlatformSize(21.0),
                    iconHeight: getPlatformSize(21.0),
                    marginTop: getPlatformSize(10.0),
                    isChecked: false,
                    onClick: () {
                      setState(() {
                        _markers.clear();
                      });
                    },
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
    @required this.isChecked,
    @required this.onClick,
  });

  final AssetImage icon;
  final double iconWidth;
  final double iconHeight;
  final double marginTop;
  final bool isChecked;
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
            if (onClick != null) {
              onClick();
            }
          },
          //highlightColor: Constants.App.PRIMARY_COLOR,
          borderRadius: BorderRadius.all(
            Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
          ),
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
