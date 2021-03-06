import 'package:flutter/material.dart';

import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/components/my_cached_image.dart';
import 'package:exattraffic/models/language_model.dart';
import 'package:exattraffic/models/locale_text.dart';

import 'incident_detail_presenter.dart';

class IncidentDetailPage extends StatefulWidget {
  final int id;

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
  LocaleText _title = LocaleText.incident();

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

  Widget _content() {
    return _presenter.incidentDetailModel == null
        ? Container(
            key: _keyDummyContainer,
            child: DataLoading(),
          )
        : Stack(
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
      /*child: Image(
        image: NetworkImage("${_presenter.incidentDetailModel.data.cover}"),
        width: getPlatformSize(Constants.LoginScreen.LOGO_SIZE),
        height: getPlatformSize(Constants.LoginScreen.LOGO_SIZE),
      ),*/
      child: AspectRatio(
        aspectRatio: 1.6,
        child: MyCachedImage(
          imageUrl: _presenter.incidentDetailModel.data.cover,
          progressIndicatorSize: ProgressIndicatorSize.large,
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
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            _textData(),
          ],
        ),
      ),
    );
//      _presenter.aboutModel==null?Expanded(child: DataLoading()):
  }

  Widget _textData() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getPlatformSize(8.0),
        vertical: getPlatformSize(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: getPlatformSize(4.0),
          ),
          Text(
            formatDateTime(_presenter.incidentDetailModel.data.createdAt),
            style: getTextStyle(
              LanguageName.thai,
              sizeTh: Constants.Font.SMALLER_SIZE_TH,
              sizeEn: Constants.Font.SMALLER_SIZE_EN,
              color: Constants.Font.DIM_COLOR,
            ),
          ),
          SizedBox(
            height: getPlatformSize(10.0),
          ),
          Text(
            _presenter.incidentDetailModel.data.title,
            style: getTextStyle(
              LanguageName.thai,
              sizeTh: Constants.Font.BIGGER_SIZE_TH,
              sizeEn: Constants.Font.BIGGER_SIZE_EN,
              isBold: true,
            ),
          ),
          SizedBox(
            height: getPlatformSize(10.0),
          ),
          for (var paragraph in _getParagraphList(_presenter.incidentDetailModel.data.detail))
            Padding(
              padding: EdgeInsets.only(
                bottom: getPlatformSize(Constants.Font.SPACE_BETWEEN_TEXT_PARAGRAPH),
              ),
              child: Text(
                paragraph,
                style: getTextStyle(LanguageName.thai),
              ),
            )
        ],
      ),
//      child: Text(_presenter.aboutModel.data[0].content),
    );
  }

  List<String> _getParagraphList(String details) {
    return details
        .split("\n")
        .where((paragraph) => paragraph != null && paragraph.trim().isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      title: _title,
      // แก้ไขตรง child นี้ได้เลย เพื่อแสดง content ตามที่ต้องการ
      child: _content(),
    );
  }
}
