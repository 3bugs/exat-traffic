import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/components/error_view.dart';
import 'FAQ_presenter.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["คำถามที่พบบ่อย", "FAQ", "经常问的问题"];

//  bool open = false;
  FAQPresenter _presenter;
  List<bool> open = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() {
    open.clear();
    _presenter.clearFAQ();
    _presenter.getFAQ();

    // if failed, use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Widget _content() {
    return _presenter.error != null
        ? Center(
            child: ErrorView(
              title: "ขออภัย",
              text: _presenter.error.message,
              buttonText: "ลองใหม่",
              withBackground: true,
              onClick: _presenter.getFAQ,
            ),
          )
        : _presenter.faqModel == null
            ? DataLoading()
            : Container(
                color: Constants.App.BACKGROUND_COLOR,
                child: SmartRefresher(
                  enablePullDown: true,
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                      vertical: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                    ),
                    physics: BouncingScrollPhysics(),
                    itemCount: _presenter.faqModel.data.length,
                    itemBuilder: (context, index) {
                      open.add(false);
                      return _dataCard(index);
                    },
                  ),
                ),
              );
  }

  Widget _dataCard(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          open[index] = !open[index];
        });
      },
      child: Card(
        elevation: getPlatformSize(5.0),
        shadowColor: Colors.black.withOpacity(0.5),
        margin: EdgeInsets.only(top: index == 0 ? 0.0 : getPlatformSize(16.0)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsets.only(
            top: getPlatformSize(10.0),
            bottom: getPlatformSize(10.0),
            right: getPlatformSize(10.0),
            left: getPlatformSize(20.0),
          ),
          color: open[index] ? Color(0xFFF8F8F8) : Colors.white,
//          height: 200,
//          width: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
//                height: getPlatformSize(50.0),
//                color: Colors.red,
                padding: EdgeInsets.only(
                  top: getPlatformSize(8.0),
                  bottom: getPlatformSize(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "${_presenter.faqModel.data[index].name}",
                        style: getTextStyle(
                          0,
                          color: open[index] ? Color(0xFF1C1C1C) : Constants.Font.DEFAULT_COLOR,
                          sizeTh: open[index]
                              ? Constants.Font.BIGGER_SIZE_TH
                              : Constants.Font.DEFAULT_SIZE_TH,
                          sizeEn: open[index]
                              ? Constants.Font.BIGGER_SIZE_EN
                              : Constants.Font.DEFAULT_SIZE_EN,
                          //isBold: true,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getPlatformSize(8.0),
                    ),
                    Container(
//                      color: Colors.red,
                      height: getPlatformSize(40.0),
                      width: getPlatformSize(25.0),
                      child: open[index]
                          ? Icon(
                              Icons.keyboard_arrow_up,
                              color: Color(0xFF626060),
                            )
                          : Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF626060),
                            ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: open[index],
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(
                          top: getPlatformSize(8.0),
                          bottom: getPlatformSize(8.0),
                        ),
                        child: Text(
                          "${_presenter.faqModel.data[index].detail}",
                          style: getTextStyle(0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _presenter = FAQPresenter(this);
    _presenter.getFAQ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YourScaffold(
      titleList: _titleList,
      child: _content(),
    );
  }
}
