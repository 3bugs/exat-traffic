import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:exattraffic/screens/widget/widget_presenter.dart';
import 'package:exattraffic/screens/scaffold2.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/etc/utils.dart';

class WidgetSetting extends StatefulWidget {
  @override
  _WidgetSettingState createState() => _WidgetSettingState();
}

// https://github.com/rxlabz/orderable_stack/tree/master/orderable_stack_example

class _WidgetSettingState extends State<WidgetSetting> {
  // กำหนด title ของแต่ละภาษา, ในช่วง dev ต้องกำหนดอย่างน้อย 3 ภาษา เพราะดัก assert ไว้ครับ
  List<String> _titleList = ["วิดเจ็ต", "Widget", "小部件"];

  WidgetPresenter _presenter;

  void _handleChangeSelect(int item, bool value) {

  }

  Widget _content() {
    return Container(
      color: Constants.App.BACKGROUND_COLOR,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
              vertical: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                WidgetSettingItem(
                  text: "ทางพิเศษ",
                  selected: true,
                  onChanged: (value) => _handleChangeSelect(0, value),
                  marginTop: getPlatformSize(0.0),
                ),
                WidgetSettingItem(
                  text: "รายการโปรด",
                  selected: false,
                  onChanged: (value) => _handleChangeSelect(1, value),
                  marginTop: getPlatformSize(4.0),
                ),
                WidgetSettingItem(
                  text: "เหตุการณ์",
                  selected: true,
                  onChanged: (value) => _handleChangeSelect(2, value),
                  marginTop: getPlatformSize(4.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _presenter = WidgetPresenter(this);
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

class WidgetSettingItem extends StatelessWidget {
  final String text;
  final bool selected;
  final Function onChanged;
  final double marginTop;

  WidgetSettingItem({
    @required this.text,
    @required this.selected,
    @required this.onChanged,
    @required this.marginTop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: this.marginTop),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: getPlatformSize(25.0),
            height: getPlatformSize(25.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Color(0xFFC6C6C6),
                toggleableActiveColor: Color(0xFF4E8305),
              ),
              child: Checkbox(
                value: this.selected,
                onChanged: this.onChanged,
              ),
            ),
          ),
          SizedBox(
            width: getPlatformSize(12.0),
          ),
          Expanded(
            child: Card(
              elevation: getPlatformSize(5.0),
              shadowColor: Colors.black.withOpacity(0.5),
//            margin: EdgeInsets.only(top: this.marginTop),
              clipBehavior: Clip.antiAlias,
              child: Container(
                padding: EdgeInsets.only(
                  top: getPlatformSize(10.0),
                  bottom: getPlatformSize(10.0),
                  right: getPlatformSize(12.0),
                  left: getPlatformSize(20.0),
                ),
                color: Colors.white,
//          height: 200,
//          width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(
//                height: getPlatformSize(50.0),
//                color: Colors.red,
                      padding: EdgeInsets.only(
                        top: getPlatformSize(6.0),
                        bottom: getPlatformSize(6.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              this.text,
                              style: getTextStyle(
                                0,
                                //color: Constants.App.ACCENT_COLOR,
                                //isBold: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getPlatformSize(8.0),
                            height: getPlatformSize(40.0),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.all(
                                Radius.circular(getPlatformSize(20.0)),
                              ),
                              child: Container(
                                width: getPlatformSize(40.0),
                                height: getPlatformSize(40.0),
                                child: Center(
                                  child: Icon(
                                    Icons.menu,
                                    color: Color(0xFFA7A7A7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
