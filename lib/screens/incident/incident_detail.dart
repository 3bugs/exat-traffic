import 'dart:math';

import 'package:exattraffic/components/data_loading.dart';
import 'package:flutter/material.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';

import 'incident_detail_presenter.dart';

class IncidentDetailPage extends StatefulWidget {
  int id;

  IncidentDetailPage({
    this.id,
  });

  @override
  _IncidentDetailPageState createState() => _IncidentDetailPageState();
}

class _IncidentDetailPageState extends State<IncidentDetailPage> {
  final GlobalKey _keyDummyContainer = GlobalKey();
  IncidentDetailPresenter _presenter;

  final double overlapHeight = getPlatformSize(30.0);
  double _mainContainerHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["เหตุการณ์", "Incident", "事件"];

  @override
  void initState() {
//    print("IncidentDetailPage ID : ${widget.id}");
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _presenter = IncidentDetailPresenter(this);
    _presenter.getIncidentDetail(widget.id);
    super.initState();
  }

  _afterLayout(_) {
    final RenderBox mainContainerRenderBox = _keyDummyContainer.currentContext.findRenderObject();
    setState(() {
      _mainContainerHeight = mainContainerRenderBox.size.height;
    });
  }

  String _getDummyText() {
    return new List(1000).fold("", (previousValue, element) => previousValue + "TEST-${Random().nextInt(100).toString()} ");
  }

  Widget _content(){
    return _presenter.incidentDetailModel == null ? DataLoading():

      Stack(
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  _banner(),
                  _body(),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _banner(){
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getPlatformSize(16.0),
        horizontal: 0.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withOpacity(0.8),
          width: 0.0, // hairline width
        ),
      ),
      child: Image(
        image: NetworkImage("${_presenter.incidentDetailModel.data.cover}"),
        width: getPlatformSize(Constants.LoginScreen.LOGO_SIZE),
        height: getPlatformSize(Constants.LoginScreen.LOGO_SIZE),
      ),
    );
  }

  Widget _body(){
    return
//      _presenter.aboutModel==null?Expanded(child: DataLoading()):
    Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: getPlatformSize(10.0),
          horizontal: 0.0,
        ),
        child: SingleChildScrollView(
          child: _textData(),
        ),
      ),
    );
  }

  Widget _textData(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10,),
          Text(_presenter.incidentDetailModel.data.title,style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 10,),
          Text(_presenter.incidentDetailModel.data.detail,style: TextStyle(
            fontSize: 16,
          ),),
        ],
      ),
//      child: Text(_presenter.aboutModel.data[0].content),
    );
  }



  @override
  Widget build(BuildContext context) {
    return YourScaffold(
        titleList: _titleList,
        // แก้ไขตรง child นี้ได้เลย เพื่อแสดง content ตามที่ต้องการ
        child: _content()
    );
  }
}



