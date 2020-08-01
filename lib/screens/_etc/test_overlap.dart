import 'dart:math';

import 'package:flutter/material.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';

class TestOverlap extends StatefulWidget {
  @override
  _TestOverlapState createState() => _TestOverlapState();
}

class _TestOverlapState extends State<TestOverlap> {
  final GlobalKey _keyDummyContainer = GlobalKey();

  final double overlapHeight = getPlatformSize(30.0);
  double _mainContainerHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["ทดสอบ Overlap", "Test Overlap", "关于我们"];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
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

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      titleList: _titleList,

      // แก้ไขตรง child นี้ได้เลย เพื่อแสดง content ตามที่ต้องการ
      child: Stack(
        key: _keyDummyContainer,
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: -overlapHeight,
            width: MediaQuery.of(context).size.width,
            height: _mainContainerHeight + overlapHeight,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.pink.withOpacity(0.5),
                  width: getPlatformSize(5.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                    vertical: 0.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
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
                          image: AssetImage('assets/images/login/exat_logo.png'),
                          width: getPlatformSize(Constants.LoginScreen.LOGO_SIZE),
                          height: getPlatformSize(Constants.LoginScreen.LOGO_SIZE),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: getPlatformSize(20.0),
                          horizontal: 0.0,
                        ),
                        child: Text(_getDummyText()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
