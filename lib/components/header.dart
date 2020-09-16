import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/language_model.dart';

class Header extends StatefulWidget {
  final String title; // list of title สำหรับแต่ละภาษา
  final bool showDate;
  final HeaderIcon leftIcon;
  final HeaderIcon rightIcon;

  Header({
    @required this.title,
    this.showDate = false,
    @required this.leftIcon,
    @required this.rightIcon,
  });

  @override
  _HeaderState createState() => _HeaderState();
}

// hardcode ไปก่อน
List<String> dateList = [
  '29 มิถุนายน 2563',
  'JUNE 29, 2020',
  '2020年6月29日',
];

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.only(
            left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
            right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ปุ่มเมนูแฮมเบอร์เกอร์, ปุ่มโทร
              Padding(
                padding: EdgeInsets.only(
                    left: getPlatformSize(0.0),
                    right: getPlatformSize(3.0),
                    top: getPlatformSize(16.0),
                    bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        widget.leftIcon == null
                            ? SizedBox.shrink()
                            : Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: widget.leftIcon.onClick,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(getPlatformSize(3.0)),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: getPlatformSize(3.0),
                                      right: getPlatformSize(12.0),
                                      top: getPlatformSize(6.0),
                                      bottom: getPlatformSize(8.0),
                                    ),
                                    child: Image(
                                      image: widget.leftIcon.image,
                                      width: getPlatformSize(22.0),
                                      height: getPlatformSize(20.0),
                                    ),
                                  ),
                                ),
                              ),
                        Image(
                          image: AssetImage('assets/images/splash/exat_logo_new_no_text.png'),
                          width: getPlatformSize(24.0 * 320 / 246),
                          height: getPlatformSize(24.0),
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    widget.rightIcon != null
                        ? Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: widget.rightIcon.onClick,
                              borderRadius: BorderRadius.all(
                                Radius.circular(getPlatformSize(18.0)),
                              ),
                              child: Image(
                                image: widget.rightIcon.image,
                                width: getPlatformSize(36.0),
                                height: getPlatformSize(36.0),
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: getPlatformSize(36.0),
                            height: getPlatformSize(36.0),
                          ),
                  ],
                ),
              ),
              // headline
              Padding(
                padding: EdgeInsets.only(
                  left: getPlatformSize(4.0),
                ),
                child: Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    return Text(
                      widget.title,
                      style: getHeadlineTextStyle(context, lang: language.lang),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
              // วันที่
              Visibility(
                visible: widget.showDate,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: getPlatformSize(5.0),
                  ),
                  child: Consumer<LanguageModel>(
                    builder: (context, language, child) {
                      return Text(
                        dateList[1],
                        style: getTextStyle(
                          language.lang,
                          color: Colors.white,
                          heightTh: 0.8 / 0.9,
                          heightEn: 1.15 / 0.9,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class HeaderIcon {
  final AssetImage image;
  final Function onClick;

  HeaderIcon({
    @required this.image,
    @required this.onClick,
  });
}
