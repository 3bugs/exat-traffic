import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/models/notification_model.dart';

import 'notification_details_presenter.dart';

class NotificationDetails extends StatefulWidget {
  final NotificationModel notification;

  NotificationDetails({
    this.notification,
  });

  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  final GlobalKey _keyDummyContainer = GlobalKey();
  final GlobalKey _keyGoogleMaps = GlobalKey();
  NotificationDetailsPresenter _presenter;

  final Completer<GoogleMapController> _googleMapController = Completer();

  final double overlapHeight = getPlatformSize(30.0);
  double _mainContainerHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["การแจ้งเตือน", "Notification", "通知"];

  static const CameraPosition INITIAL_POSITION = CameraPosition(
    target: LatLng(13.7563, 100.5018), // Bangkok
    zoom: 8,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _presenter = NotificationDetailsPresenter(this);
    _presenter.getNotification(widget.notification);
    super.initState();
  }

  _afterLayout(_) {
    final RenderBox mainContainerRenderBox = _keyDummyContainer.currentContext.findRenderObject();
    setState(() {
      _mainContainerHeight = mainContainerRenderBox.size.height;
    });
  }

  Future<void> _moveToMarkerPosition(BuildContext context) async {
    /*final Position position =
        await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);*/
    final CameraPosition currentPosition = CameraPosition(
      target: LatLng(widget.notification.latitude, widget.notification.longitude),
      zoom: 15,
    );
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
  }

  Widget _content() {
    return Stack(
      key: _keyDummyContainer,
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          top: -overlapHeight,
          width: MediaQuery.of(context).size.width,
          height: _mainContainerHeight + overlapHeight,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                vertical: 0.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _googleMaps(),
                  _body(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Set<Marker> _createMarkerSet() {
    Set<Marker> markerSet = Set();
    if (widget.notification.latitude != null && widget.notification.longitude != null) {
      markerSet.add(_createMarker());
    }

    return markerSet;
  }

  Marker _createMarker() {
    final MarkerId markerId = MarkerId('marker');

    return Marker(
      markerId: markerId,
      position: LatLng(widget.notification.latitude, widget.notification.longitude),
      infoWindow: InfoWindow(
        title: widget.notification.detail,
        snippet: widget.notification.routeName,
      ),
      onTap: () {},
    );
  }

  Widget _googleMaps() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getPlatformSize(0.0),
        horizontal: getPlatformSize(0.0),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withOpacity(0.8),
          width: 0.0, // hairline width
        ),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GoogleMap(
          key: _keyGoogleMaps,
          mapType: MapType.normal,
          initialCameraPosition: INITIAL_POSITION,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          trafficEnabled: false,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _googleMapController.complete(controller);
            _moveToMarkerPosition(context);
          },
          markers: _createMarkerSet(),
        ),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: getPlatformSize(0.0),
          horizontal: getPlatformSize(0.0),
        ),
        child: SingleChildScrollView(
          child: _textData(),
        ),
      ),
    );
  }

  Widget _textData() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getPlatformSize(8.0),
        vertical: getPlatformSize(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: getPlatformSize(4.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                formatDateTime(_presenter.notification.createdAt),
                style: getTextStyle(
                  0,
                  sizeTh: Constants.Font.SMALLER_SIZE_TH,
                  sizeEn: Constants.Font.SMALLER_SIZE_EN,
                  color: Constants.Font.DIM_COLOR,
                ),
              ),
              Text(
                _presenter.notification.routeName,
                style: getTextStyle(
                  0,
                  sizeTh: Constants.Font.SMALLER_SIZE_TH,
                  sizeEn: Constants.Font.SMALLER_SIZE_EN,
                  color: Constants.Font.DIM_COLOR,
                ),
              ),
            ],
          ),
          SizedBox(
            height: getPlatformSize(10.0),
          ),
          Text(
            _presenter.notification.detail,
            style: getTextStyle(
              0,
              sizeTh: Constants.Font.BIGGER_SIZE_TH,
              sizeEn: Constants.Font.BIGGER_SIZE_EN,
              isBold: true,
            ),
          ),
          SizedBox(
            height: getPlatformSize(10.0),
          ),
        ],
      ),
//      child: Text(_presenter.aboutModel.data[0].content),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      titleList: _titleList,
      child: _content(),
    );
  }
}
