import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/express_way_model.dart';
import 'package:exattraffic/models/language_model.dart';

class ExpressWayImageView extends StatelessWidget {
  ExpressWayImageView({
    @required this.expressWay,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.onClick,
  });

  final ExpressWayModel expressWay;
  final bool isFirstItem;
  final bool isLastItem;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.all(
          Radius.circular(getPlatformSize(12.0)),
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: getPlatformSize(isFirstItem ? 20.0 : 10.0),
            right: getPlatformSize(isLastItem ? 20.0 : 10.0),
            top: getPlatformSize(2.0),
            bottom: getPlatformSize(2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                ),
                child: Image(
                  image: expressWay.image,
                  width: getPlatformSize(122.0),
                  height: getPlatformSize(78.0),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: getPlatformSize(10.0),
                ),
                child: Consumer<LanguageModel>(
                  builder: (context, language, child) {
                    String name;
                    switch (language.lang) {
                      case 0:
                        name = expressWay.name;
                        break;
                      case 1:
                        name = 'Expressway';
                        break;
                      case 2:
                        name = '高速公路';
                        break;
                    }

                    return Text(
                      name,
                      style: getTextStyle(
                        language.lang,
                        sizeTh: Constants.Font.SMALLER_SIZE_TH,
                        sizeEn: Constants.Font.SMALLER_SIZE_EN,
                        heightTh: 1.0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpressWayTextView extends StatelessWidget {
  ExpressWayTextView({
    @required this.expressWay,
    @required this.isFirstItem,
    @required this.isLastItem,
  });

  final ExpressWayModel expressWay;
  final bool isFirstItem;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: getPlatformSize(isFirstItem ? 14.0 : 7.0),
            right: getPlatformSize(isLastItem ? 14.0 : 7.0),
            top: getPlatformSize(2.0),
            bottom: getPlatformSize(2.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.all(
                Radius.circular(getPlatformSize(10.0)),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getPlatformSize(8.0),
                  vertical: getPlatformSize(5.0),
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: getPlatformSize(1.0),
                    color: Color(0xFF707070),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Consumer<LanguageModel>(
                      builder: (context, language, child) {
                        String name;
                        switch (language.lang) {
                          case 0:
                            name = 'ดินแดง';
                            break;
                          case 1:
                            name = 'Din dang';
                            break;
                          case 2:
                            name = '中文';
                            break;
                        }

                        return Text(
                          name,
                          style: getTextStyle(
                            language.lang,
                            sizeTh: Constants.Font.SMALLER_SIZE_TH,
                            sizeEn: Constants.Font.SMALLER_SIZE_EN,
                            heightTh: 1.05,
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: getPlatformSize(8.0),
                        right: getPlatformSize(8.0),
                      ),
                      child: Image(
                        image: AssetImage('assets/images/home/ic_double_arrow.png'),
                        width: getPlatformSize(8.44),
                        height: getPlatformSize(9.84),
                      ),
                    ),
                    Consumer<LanguageModel>(
                      builder: (context, language, child) {
                        String name;
                        switch (language.lang) {
                          case 0:
                            name = 'บางนา';
                            break;
                          case 1:
                            name = 'Bangna';
                            break;
                          case 2:
                            name = '中文';
                            break;
                        }

                        return Text(
                          name,
                          style: getTextStyle(
                            language.lang,
                            sizeTh: Constants.Font.SMALLER_SIZE_TH,
                            sizeEn: Constants.Font.SMALLER_SIZE_EN,
                            heightTh: 1.05,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
