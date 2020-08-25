import 'package:flutter/material.dart';
import 'dart:io';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:exattraffic/components/data_loading.dart';

import 'about_presenter.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final GlobalKey _keyDummyContainer = GlobalKey();

  final double overlapHeight = getPlatformSize(30.0);
  double _mainContainerHeight = 400; // กำหนดไปก่อน ค่าจริงจะมาจาก _afterLayout()
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["เกี่ยวกับเรา", "About Us", "关于我们"];
  AboutPresenter _presenter;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _presenter = AboutPresenter(this);
    _presenter.getAbout();
    super.initState();
  }

  _afterLayout(_) {
    final RenderBox mainContainerRenderBox = _keyDummyContainer.currentContext.findRenderObject();
    setState(() {
      _mainContainerHeight = mainContainerRenderBox.size.height;
    });
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

  Widget _banner() {
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
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Image(
          image: AssetImage('assets/images/login/exat_logo.png'),
          width: getPlatformSize(Constants.LoginScreen.LOGO_SIZE),
          height: getPlatformSize(Constants.LoginScreen.LOGO_SIZE),
        ),
      ),
    );
  }

  Widget _body() {
    return _presenter.aboutModel == null
        ? Expanded(child: DataLoading())
        : Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: getPlatformSize(0.0),
                horizontal: getPlatformSize(0.0),
              ),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getPlatformSize(8.0),
                      vertical: getPlatformSize(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: getPlatformSize(10.0),
                        ),
                        for (var paragraph
                        in _getParagraphList(_presenter.aboutModel.data[0].content))
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: getPlatformSize(Constants.Font.SPACE_BETWEEN_TEXT_PARAGRAPH),
                            ),
                            child: Text(
                              paragraph,
                              style: getTextStyle(0),
                            ),
                          ),
                        SizedBox(
                          height: getPlatformSize(15.0),
                        ),
                        _iconLink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  /*Widget _textData() {
    return Container(
      child: Text(_presenter.aboutModel.data[0].content),
    );
  }*/

  List<String> _getParagraphList(String details) {
    return details
        .split("\n")
        .where((paragraph) => paragraph != null && paragraph.trim().isNotEmpty)
        .toList();
  }

  Widget _iconLink() {
    return Row(
      children: <Widget>[
        Platform.isIOS
            ? InkWell(
                onTap: () {
                  StoreRedirect.redirect(
                      androidAppId: "th.co.exat.android.exatportal", iOSAppId: "1295736283");
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 70,
                      height: 70,
//                      color: Colors.red,
                      child: Image.network(_presenter.aboutModel.data[0].reference[0].cover),
                    ),
                    Container(
                      alignment: Alignment.center,
//                      color: Colors.red,
                      width: 70,
                      height: 30,
                      child: Text(
                        _presenter.aboutModel.data[0].reference[0].title,
                        style: TextStyle(fontSize: 9),
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: () {
                  StoreRedirect.redirect(
                      androidAppId: "th.co.exat.android.exatportal", iOSAppId: "1295736283");
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 70,
                      height: 70,
//                      color: Colors.green,
                      child: Image.network(_presenter.aboutModel.data[0].reference[1].cover),
                    ),
                    Container(
                      alignment: Alignment.center,
//                      color: Colors.green,
                      width: 70,
                      height: 30,
                      child: Text(
                        _presenter.aboutModel.data[0].reference[1].title,
                        style: TextStyle(fontSize: 9),
                      ),
                    ),
                  ],
                ),
              ),
        SizedBox(
          width: 15,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
        titleList: _titleList,
        // แก้ไขตรง child นี้ได้เลย เพื่อแสดง content ตามที่ต้องการ
        child: _content());
  }
}
