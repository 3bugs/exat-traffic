import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/components/data_loading.dart';
import 'package:exattraffic/constants.dart' as Constants;
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
    _presenter.clearFAQ();
    _presenter.getFAQ();

    // if failed, use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Widget _content() {
    return _presenter.faqModel == null
        ? DataLoading()
        : Container(
            color: Color(0x09000000),
            child: SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
                  vertical: getPlatformSize(16.0),
                ),
                itemCount: _presenter.faqModel.data.length,
                itemBuilder: (context, index) {
                  open.add(false);
                  return _datacard(index);
                },
              ),
            ),
          );
  }

  Widget _datacard(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          if (open[index]) {
            open[index] = false;
          } else {
            open[index] = true;
          }
        });
      },
      child: Card(
        margin: EdgeInsets.only(top: index == 0 ? 0.0 : getPlatformSize(16.0)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsets.only(
            top: getPlatformSize(10.0),
            bottom: getPlatformSize(10.0),
            right: getPlatformSize(10.0),
            left: getPlatformSize(16.0),
          ),
          color: open[index] ? Colors.white : Colors.white,
//                height: 200,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                height: getPlatformSize(50.0),
//                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${_presenter.faqModel.data[index].name}",
                      style: getTextStyle(
                        0,
                        isBold: true,
                      ),
                    ),
                    Container(
//                      color: Colors.red,
                      height: getPlatformSize(50.0),
                      width: getPlatformSize(25.0),
                      child: open[index]
                          ? Icon(
                              Icons.keyboard_arrow_up,
                              color: Color(0xFFA7A7A7),
                            )
                          : Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFFA7A7A7),
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
                        child: Text(
                          "${_presenter.faqModel.data[index].detail}",
                          style: getTextStyle(0),
                        ),
                        padding: EdgeInsets.only(
                          top: getPlatformSize(15.0),
                          bottom: getPlatformSize(15.0),
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
