import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/components/no_data.dart';
import 'package:exattraffic/screens/emergency/emergency_presenter.dart';
import 'package:exattraffic/models/emergency_number_model.dart';
import 'package:exattraffic/screens/emergency/components/emergency_view.dart';

class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  static const bool SHOW_SOS = false;
  final GlobalKey _keyDummyContainer = GlobalKey();

  final double overlapHeight = SHOW_SOS ? getPlatformSize(30.0) : 0.0;
  double _mainContainerHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["เบอร์โทรฉุกเฉิน", "Emergency Call", "紧急电话"];

  EmergencyPresenter _presenter;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _afterLayout(_) {
    final RenderBox mainContainerRenderBox = _keyDummyContainer.currentContext.findRenderObject();
    setState(() {
      _mainContainerHeight = mainContainerRenderBox.size.height;
    });
  }

  void _onRefresh() {
    _presenter.clearEmergencyNumberList();
    _presenter.getEmergencyNumberList();

    // if failed, use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _handleClickNotificationItem(EmergencyNumberModel emergencyNumber) {
    UrlLauncher.launch("tel:${emergencyNumber.number}");
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _presenter = EmergencyPresenter(this);
    _presenter.getEmergencyNumberList();
    super.initState();
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
            color: Constants.App.BACKGROUND_COLOR,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Visibility(visible: SHOW_SOS, child: _sos()),
                  Expanded(child: _list()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sos() {
    return EmergencyView(
      onClick: () {},
      isSos: true,
      emergencyNumber: EmergencyNumberModel(
        name: "ขอความช่วยเหลือ (SOS)",
        number: null,
        details: null,
        routeId: null,
        latitude: null,
        longitude: null,
      ),
      isFirstItem: false,
      isLastItem: false,
    );
  }

  Widget _list() {
    return Container(
      padding: EdgeInsets.only(
        top: getPlatformSize(0.0),
      ),
      //color: Constants.App.BACKGROUND_COLOR,
      child: _presenter.emergencyNumberList == null
          ? DataLoading()
          : SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: _presenter.emergencyNumberList.isNotEmpty
                  ? ListView.separated(
                      itemCount: _presenter.emergencyNumberList.length,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return EmergencyView(
                          onClick: () =>
                              _handleClickNotificationItem(_presenter.emergencyNumberList[index]),
                          emergencyNumber: _presenter.emergencyNumberList[index],
                          isFirstItem: SHOW_SOS ? false : (index == 0),
                          isLastItem: index == _presenter.emergencyNumberList.length - 1,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox.shrink();
                      },
                    )
                  : NoData(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(titleList: _titleList, child: _content());
  }
}