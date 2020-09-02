import 'package:exattraffic/components/my_cached_image.dart';
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
                child: expressWay.imageUrl != null && expressWay.imageUrl.trim().startsWith("http")
                    ? SizedBox(
                        width: getPlatformSize(122.0),
                        height: getPlatformSize(78.0),
                        child: MyCachedImage(
                          imageUrl: expressWay.imageUrl.trim(),
                          progressIndicatorSize: ProgressIndicatorSize.small,
                        ),
                      )
                    : Image(
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

class LegView extends StatelessWidget {
  LegView({
    @required this.legModel,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.selected,
    @required this.onSelectLeg,
  });

  static const double BORDER_RADIUS = 16.0;

  final LegModel legModel;
  final bool isFirstItem;
  final bool isLastItem;
  final bool selected;
  final Function onSelectLeg;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: getPlatformSize(isFirstItem ? 14.0 : 4.0),
            right: getPlatformSize(isLastItem ? 14.0 : 4.0),
            top: getPlatformSize(2.0),
            bottom: getPlatformSize(2.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelectLeg(legModel),
              borderRadius: BorderRadius.all(
                Radius.circular(getPlatformSize(BORDER_RADIUS)),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getPlatformSize(12.0),
                  vertical: getPlatformSize(5.0),
                ),
                decoration: BoxDecoration(
                  color: selected ? Color(0xFFE8E8E8) : Colors.transparent,
                  border: Border.all(
                    width: getPlatformSize(0.8),
                    color: selected ? Color(0xFF000000) : Color(0xFF707070),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(getPlatformSize(BORDER_RADIUS)),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Consumer<LanguageModel>(
                      builder: (context, language, child) {
                        return Text(
                          legModel.origin,
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
                        return Text(
                          legModel.destination,
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
