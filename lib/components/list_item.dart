import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:exattraffic/etc/utils.dart';
import 'package:exattraffic/constants.dart' as Constants;

class ListItem extends StatelessWidget {
  ListItem({
    @required this.child,
    @required this.marginTop,
    @required this.marginBottom,
    @required this.padding,
    @required this.onClick,
  });

  final Widget child;
  final double marginTop;
  final double marginBottom;
  final EdgeInsets padding;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
            right: getPlatformSize(Constants.App.HORIZONTAL_MARGIN),
            top: marginTop,
            bottom: marginBottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x22777777),
                  blurRadius: getPlatformSize(9.0),
                  spreadRadius: getPlatformSize(3.0),
                  offset: Offset(
                    getPlatformSize(2.0), // move right
                    getPlatformSize(2.0), // move down
                  ),
                ),
              ],
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(
                Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onClick,
                borderRadius: BorderRadius.all(
                  Radius.circular(getPlatformSize(Constants.App.BOX_BORDER_RADIUS)),
                ),
                child: Container(
                  padding: padding,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
