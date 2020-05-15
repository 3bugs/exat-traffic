import 'package:flutter/material.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;
import 'package:exattraffic/models/express_way.dart';

class ExpressWayImageView extends StatelessWidget {
  ExpressWayImageView({
    @required this.expressWay,
    @required this.isFirstItem,
    @required this.isLastItem,
    @required this.onClick,
  });

  final ExpressWay expressWay;
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
          Radius.circular(getPlatformSize(5.0)),
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
                  top: getPlatformSize(6.0),
                ),
                child: Text(
                  expressWay.name,
                  style: TextStyle(
                    fontSize: getPlatformSize(Constants.Font.SMALLER_SIZE),
                    color: Constants.Font.DEFAULT_COLOR,
                  ),
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

  final ExpressWay expressWay;
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
                Radius.circular(getPlatformSize(6.0)),
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
                child: Center(
                  child: Text(
                    expressWay.name,
                    style: TextStyle(
                      fontSize: getPlatformSize(Constants.Font.SMALLER_SIZE),
                      color: Constants.Font.DEFAULT_COLOR,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
